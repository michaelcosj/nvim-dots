-- https://github.com/folke/todo-comments.nvim
return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keywords = {
			QUESTION = {
				icon = " ",
				color = "hint",
			},
		},
		highlight = {
			keyword = "fg",
		},
	},
}
