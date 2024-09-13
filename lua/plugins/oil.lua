-- https://github.com/stevearc/oil.nvim
return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		default_file_explorer = false,
		delete_to_trash = true,
		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},
		float = {
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			-- preview_split: Split direction: "auto", "left", "right", "above", "below".
			preview_split = "auto",
			-- This is the config that will be passed to nvim_open_win.
			-- Change values here to customize the layout
			override = function(conf)
				return conf
			end,
		},
		keymaps = {
			["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
			["<C-s>"] = {
				"actions.select",
				opts = { horizontal = true },
				desc = "Open the entry in a horizontal split",
			},
			["<esc>"] = "actions.close",
		},
	},
	keys = {
		{ "<leader>fe", "<CMD>:lua require('oil').toggle_float()<CR>", desc = "[F]ile [E]xplorer" },
	},
}
