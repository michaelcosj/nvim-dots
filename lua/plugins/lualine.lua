-- https://github.com/nvim-lualine/lualine.nvim
return {
	"nvim-lualine/lualine.nvim",
	enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			component_separators = { left = " ", right = " " },
			section_separators = { left = "▓▒░", right = "░▒▓" },
		},
		sections = {
			lualine_b = {
				"branch",
				"diff",
				"diagnostics",
				"require'arrow.statusline'.text_for_statusline_with_icons()",
			},
			lualine_x = { "filetype" },
		},
	},
}
