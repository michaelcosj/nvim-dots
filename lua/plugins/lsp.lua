-- TODO: create an lsp config folder to put lsp configuration in it
-- this file should just import the config and register it

local lsp = vim.lsp

local ok, servers = pcall(require, "config.lsp-servers")
if not ok then
	return {}
end

local handlers = {
	["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" }),
}

return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			{ "williamboman/mason-lspconfig.nvim", opts = { ensure_installed = vim.tbl_keys(servers or {}) } },
		},
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local opts = servers[server_name] or {}

						opts.handlers = handlers
						opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})

						lspconfig[server_name].setup(opts)
					end,
				},
			})

			-- diagnostics signs
			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- diagnostics mappings.
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto prev diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic in loclist" })

			-- only mapped after the language server
			-- attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),

				callback = function(ev)
					local client = lsp.get_client_by_id(ev.data.client_id)

					local map = function(key, action, desc)
						vim.keymap.set("n", key, action, { buffer = ev.buf, desc = "LSP: " .. desc })
					end

					map("g.", lsp.buf.code_action, "Code Actions")
					map("gD", lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efintion")
					map("gr", require("telescope.builtin").lsp_references, "List [R]eferences")
					map("gi", require("telescope.builtin").lsp_implementations, "List [I]mplemetations")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efintion")

					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					map("K", lsp.buf.hover, "Open hover float")
					map("<C-k>", lsp.buf.signature_help, "Open signature help")

					map("<leader>rn", lsp.buf.rename, "Rename symbol")

					-- auto open float diagnostic
					vim.api.nvim_create_autocmd("CursorHold", {
						buffer = ev.buf,
						callback = function()
							local floatOpts = {
								focusable = false,
								close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
								border = "rounded",
								source = "always",
								prefix = " ",
								scope = "cursor",
							}
							vim.diagnostic.open_float(nil, floatOpts)
						end,
					})

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({}), { bufnr = ev.buf })
						end, "[T]oggle Inlay [H]int")
					end
				end,
			})
		end,
	},
}
