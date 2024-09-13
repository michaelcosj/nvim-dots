return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function(opts)
		require("vscode").setup(opts)
		vim.cmd.colorscheme("vscode")
	end,
}
