local lsp = vim.lsp

local handlers = {
  ["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" }),
}

local servers = {
  templ = {},
  biome = {},
  cssls = {},
  volar = {},
  jsonls = {},
  bashls = {},
  lua_ls = {},
  clangd = {},
  svelte = {},
  pyright = {},
  intelephense = {},
  rust_analyzer = {},
  vtsls = {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    settings = {
      typescript = {
        format = {
          enable = false
        },
        tsserver = {
          useSeparateSyntaxServer = false,
          maxTsServerMemory = 4096,
        }
      },
      vtsls = {
        tsserver = {
          globalPlugins = {}
        },
      },
    },
    before_init = function(params, config)
      local result = vim.system(
        { "npm", "query", "#vue" },
        { cwd = params.workspaceFolders[1].name, text = true }
      ):wait()
      if result.stdout ~= "[]" then
        local vuePluginConfig = {
          name = "@vue/typescript-plugin",
          location = require("mason-registry").get_package("vue-language-server"):get_install_path()
              .. "/node_modules/@vue/language-server",
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        }
        table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
      end
    end,
  },
  htmx = {
    filetypes = {
      'html',
      'edge',
      'templ',
      'blade',
    }
  },
  html = {
    filetypes = {
      'html',
      'edge',
      'templ',
      'blade',
    }
  },
  emmet_language_server = {
    filetypes = {
      'html',
      'edge',
      'templ',
      'blade',
      'vue',
    }
  },
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        }
      }
    }
  }
}

return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",           opts = {} },
      { "williamboman/mason-lspconfig.nvim", opts = { ensure_installed = vim.tbl_keys(servers or {}) } },
    },
    config = function()
      local lspconfig = require('lspconfig')

      local capabilities = lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local opts = servers[server_name] or {}

            opts.handlers = handlers
            opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
              opts.capabilities or {})

            lspconfig[server_name].setup(opts)
          end,
        },
      }

      -- diagnostics signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- diagnostics mappings.
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Goto prev diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostic in loclist" })

      -- only mapped after the language server
      -- attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),

        callback = function(ev)
          local client = lsp.get_client_by_id(ev.data.client_id)

          local map = function(key, action, desc)
            vim.keymap.set('n', key, action, { buffer = ev.buf, desc = 'LSP: ' .. desc })
          end

          map('g.', lsp.buf.code_action, "Code Actions")
          map('gD', lsp.buf.declaration, "[G]oto [D]eclaration")
          map('gd', require("telescope.builtin").lsp_definitions, "[G]oto [D]efintion")
          map('gr', require("telescope.builtin").lsp_references, "List [R]eferences")
          map('gi', require("telescope.builtin").lsp_implementations, "List [I]mplemetations")
          map('<leader>D', require("telescope.builtin").lsp_type_definitions, "Type [D]efintion")

          map('<leader>ds', require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map('<leader>ws', require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          map('K', lsp.buf.hover, "Open hover float")
          map('<C-k>', lsp.buf.signature_help, "Open signature help")

          map('<leader>rn', lsp.buf.rename, "Rename symbol")

          vim.keymap.set('v', '<leader>f', function()
            lsp.buf.format({ range = {} })
          end, { desc = 'LSP [F]ormat Selection', buffer = ev.buf })

          map('<leader>f', function()
            if vim.bo.filetype == "templ" then
              local bufnr = vim.api.nvim_get_current_buf()
              local filename = vim.api.nvim_buf_get_name(bufnr)
              local cmd = "templ fmt " .. vim.fn.shellescape(filename)

              vim.fn.jobstart(cmd, {
                on_exit = function()
                  -- Reload the buffer only if it's still the current buffer
                  if vim.api.nvim_get_current_buf() == bufnr then
                    vim.cmd('e!')
                  end
                end,
              })
            else
              lsp.buf.format { async = true }
            end
          end, "[F]ormat buffer")

          -- auto open float diagnostic
          vim.api.nvim_create_autocmd("CursorHold", {
            buffer = ev.buf,
            callback = function()
              local floatOpts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
              }
              vim.diagnostic.open_float(nil, floatOpts)
            end
          })

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({}), { bufnr = ev.buf })
            end, "[T]oggle Inlay [H]int")
          end
        end,
      })
    end
  }
}
