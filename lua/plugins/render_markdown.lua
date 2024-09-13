return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		heading = {
			enabled = false,
			position = "inline",
		},
		code = {
			width = "block",
			left_pad = 2,
			right_pad = 4,
			position = "right",
		},
	},
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
}
