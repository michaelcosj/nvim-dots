-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		window = {
			position = "bottom",
			border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
			mappings = {
				["<2-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["<esc>"] = "close_window",
				["P"] = "toggle_preview",
			},
		},
		follow_current_file = {
			enabled = true,
		},
		hijack_netrw_behavior = "disabled",
		event_handlers = {
			{
				event = "file_open_requested",
				handler = function()
					vim.cmd("Neotree close")
				end,
			},
		},
	},
	keys = {
		{ "<leader>fe", "<CMD>Neotree toggle reveal<CR>", desc = "[F]ile [E]xplorer" },
	},
}
