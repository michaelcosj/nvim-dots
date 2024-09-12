local cfg = require("config.lsp")

return {
	-- https://github.com/folke/lazydev.nvim
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},
	-- https://github.com/neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			for type, icon in pairs(cfg.signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto prev diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic in loclist" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = cfg.on_attach,
			})
		end,
	},
	-- https://github.com/williamboman/mason.nvim
	{ "williamboman/mason.nvim", opts = { height = 0.8 } },
	-- https://github.com/williamboman/mason-lspconfig.nvim
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = vim.tbl_keys(cfg.servers or {}),
			handlers = {
				function(server_name)
					local lspconfig = require("lspconfig")

					local opts = cfg.servers[server_name] or {}
					opts.handlers = cfg.handlers

					opts.capabilities = vim.tbl_deep_extend("force", {}, cfg.capabilities(), opts.capabilities or {})

					lspconfig[server_name].setup(opts)
				end,
			},
		},
	},
}
