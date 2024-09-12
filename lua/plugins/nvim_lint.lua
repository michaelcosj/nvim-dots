-- https://github.com/mfussenegger/nvim-lint
return {
	"mfussenegger/nvim-lint",
	opts = {},
	config = function()
		require("lint").linters_by_ft = {
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			svelte = { "eslint_d" },
			vue = { "eslint_d" },
			json = { "biomejs" },
			php = { "phpstan" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
