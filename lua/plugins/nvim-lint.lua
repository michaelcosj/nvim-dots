return {
	"mfussenegger/nvim-lint",
	opts = {},
	config = function()
		require("lint").linters_by_ft = {
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			svelte = { "biomejs" },
			vue = { "biomejs" },
			json = { "biomejs" },
			php = { "phpinsights" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
