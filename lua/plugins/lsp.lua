local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local servers = {
    'templ', 'htmx', 'cssls', 'jsonls', 'bashls', 'phpactor',
    'lua_ls', 'clangd', 'pyright', 'tsserver', 'gopls',
    'svelte', 'volar', 'rust_analyzer', 'html', 'emmet_language_server'
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim",           opts = {} },
        { "williamboman/mason-lspconfig.nvim", opts = { ensure_installed = servers } },
        { 'hrsh7th/nvim-cmp',                  optional = true },
    },
    config = function()
        local lspconfig = require('lspconfig')

        -- Setup language servers.
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        for _, server in ipairs(servers) do
            local opts = { capabilities = capabilities, handlers = handlers }
            if server == 'html' or server == 'emmet_language_server' or server == 'htmx' then
                opts.filetypes = { 'html', 'edge', 'templ', 'blade' }
            elseif server == 'biome' then
                opts.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "biome.json", "biome.jsonc")
            elseif server == 'tsserver' then
                local mason_registry = require('mason-registry')
                local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
                    '/node_modules/@vue/language-server'

                opts.init_options = {
                    plugins = {
                        {
                            name = '@vue/typescript-plugin',
                            location = vue_language_server_path,
                            languages = { 'vue' },
                        },
                    },
                }
                opts.filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
            elseif server == 'intelephense' then
                opts.filetypes = { "php", "blade" }
                opts.settings = {
                    intelephense = {
                        filetypes = { "php", "blade" },
                        files = {
                            associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
                            maxSize = 5000000,
                        },
                    }
                }
            end

            lspconfig[server].setup(opts)
        end

        -- Global mappings.
        vim.keymap.set('n', '<leader>xe', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Goto prev diagnostic" })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostic in loclist" })

        -- diagnostic signs
        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- only mapped after the language server
        -- attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local make_opts = function(d)
                    return { desc = d, buffer = ev.buf }
                end

                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, make_opts("Goto Declaration"))
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, make_opts("Goto Defintion"))
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, make_opts("List references"))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, make_opts("List Implemetations"))
                vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, make_opts("Show type definition"))

                vim.keymap.set('n', 'K', vim.lsp.buf.hover, make_opts("Open hover float"))
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, make_opts("Open signature help"))

                vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, make_opts("Add workspace folder"))
                vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
                    make_opts("Remove workspace folder"))
                vim.keymap.set('n', '<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, make_opts("List Workspace folder"))

                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, make_opts("Rename symbol"))
                vim.keymap.set({ 'n', 'v' }, '<leader>xa', vim.lsp.buf.code_action, make_opts("Show code actions"))

                vim.keymap.set('n', '<leader>f', function()
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
                        vim.lsp.buf.format { async = true }
                    end
                end, make_opts("Format document"))

                vim.keymap.set('v', '<leader>f', function()
                    vim.lsp.buf.format({ range = {} })
                end, make_opts('Format Document ranged'))

                -- auto open float diagnostic
                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = ev.buf,
                    callback = function()
                        local opts = {
                            focusable = false,
                            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                            border = 'rounded',
                            source = 'always',
                            prefix = ' ',
                            scope = 'cursor',
                        }
                        vim.diagnostic.open_float(nil, opts)
                    end
                })
            end,
        })
    end
}
