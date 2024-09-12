local lsp = vim.lsp

local map = function(key, action, desc, buf)
	vim.keymap.set("n", key, action, { buffer = buf, desc = "LSP: " .. desc })
end

local M = {}

M.signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }

M.handlers = {
	["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" }),
}

M.capabilities = function()
	local capabilities = lsp.protocol.make_client_capabilities()

	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
	end

	return capabilities
end

M.servers = {
	templ = {},
	biome = {},
	cssls = {},
	volar = {},
	gopls = {},
	jsonls = {},
	bashls = {},
	lua_ls = {},
	clangd = {},
	svelte = {},
	pyright = {},
	eslint = {},
	intelephense = {},
	rust_analyzer = {},
	markdown_oxide = {
		capabilities = {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		},
	},
	vtsls = {
		filetypes = {
			"typescript",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"vue",
		},
		settings = {
			typescript = {
				format = {
					enable = false,
				},
				tsserver = {
					maxTsServerMemory = 4096,
				},
			},
			vtsls = {
				tsserver = {
					globalPlugins = {},
				},
			},
		},
		before_init = function(params, config)
			local vuePluginConfig = {
				name = "@vue/typescript-plugin",
				location = require("mason-registry").get_package("vue-language-server"):get_install_path()
					.. "/node_modules/@vue/language-server",
				languages = { "vue" },
				configNamespace = "typescript",
				enableForWorkspaceTypeScriptVersions = true,
			}
			table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
		end,
	},
	html = {
		filetypes = {
			"html",
			"edge",
			"templ",
			"blade",
		},
	},
	emmet_ls = {
		filetypes = {
			"css",
			"blade",
			"html",
			"sass",
			"scss",
			"svelte",
			"typescriptreact",
			"vue",
		},
	},
}

M.on_attach = function(ev)
	local client = lsp.get_client_by_id(ev.data.client_id)

	map("K", lsp.buf.hover, "Open Hover Float", ev.buf)
	map("<C-k>", lsp.buf.signature_help, "Open Signature Help", ev.buf)
	map("<leader>rn", lsp.buf.rename, "[R]e[n]ame Symbol", ev.buf)
	map("d.", function()
		vim.diagnostic.open_float(nil, {
			focusable = true,
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		})
	end, "Open [D]iagnostic Float", ev.buf)

	local ok, fzf_lua = pcall(require, "fzf-lua")
	if ok then
		map("g.", fzf_lua.lsp_code_actions, "Code Actions", ev.buf)

		map("gD", function()
			fzf_lua.lsp_declarations({ jump_to_single_result = true }, ev.buf)
		end, "[G]oto [D]eclaration")

		map("gd", function()
			fzf_lua.lsp_definitions({ jump_to_single_result = true }, ev.buf)
		end, "[G]oto [D]efintion")

		map("gr", function()
			fzf_lua.lsp_references({ jump_to_single_result = true }, ev.buf)
		end, "List [R]eferences")

		map("gi", function()
			fzf_lua.lsp_implementations({ jump_to_single_result = true }, ev.buf)
		end, "List [I]mplemetations")

		map("<leader>D", function()
			fzf_lua.lsp_typedefs({ jump_to_single_result = true }, ev.buf)
		end, "Type [D]efintion")

		map("<leader>ds", fzf_lua.lsp_document_symbols, "[D]ocument [S]ymbols", ev.buf)
		map("<leader>ws", fzf_lua.lsp_live_workspace_symbols, "[W]orkspace [S]ymbols", ev.buf)
	end

	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("<leader>th", function()
			lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({}), { bufnr = ev.buf })
		end, "[T]oggle Inlay [H]int", ev.buf)
	end

	-- setup Markdown Oxide daily note commands
	if client and client.name == "markdown_oxide" then
		vim.api.nvim_create_user_command("Daily", function(args)
			local input = args.args

			vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
		end, { desc = "Open daily note", nargs = "*" })
	end
end

return M
