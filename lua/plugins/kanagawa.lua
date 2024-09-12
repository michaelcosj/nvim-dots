return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		dimInactive = true,
		colors = {
			theme = {
				background = {
					dark = "dragon",
					light = "lotus",
				},
				all = {
					ui = {
						bg_gutter = "none",
					},
				},
			},
		},
		overrides = function(colors)
			local theme = colors.theme
			return {
				-- dark completion menus
				Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
				PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
				PmenuSbar = { bg = theme.ui.bg_m1 },
				PmenuThumb = { bg = theme.ui.bg_p2 },
				CmpItemMenu = { italic = true },

				-- transparent floating windows
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE" },
				FloatTitle = { bg = "NONE" },
				NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
				LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

				-- fzf selected highlights looked wonky
				FzfLuaFzfCursorLine = { fg = theme.ui.fg, bg = theme.ui.bg_p2 },
			}
		end,
	},
}
