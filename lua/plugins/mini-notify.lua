return {
	"echasnovski/mini.notify",
	version = "*",
	config = function()
		require("mini.notify").setup({
			lsp_progress = {
				enable = false,
			},
		})
	end,
}
