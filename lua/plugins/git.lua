return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		config = function()
			require("neogit").setup({})
			vim.keymap.set("n", "<leader>gg", ":Neogit kind=auto<cr>", { desc = "Open neogit window" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, key, action, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, key, action, opts)
				end

				-- Navigation
				map("n", "<leader>gn", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange" })

				map("n", "<leader>gp", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange" })

				-- Actions
				-- visual mode
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git [S]tage Hunk" })
				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Git [R]eset Hunk" })

				-- normal mode
				map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git [S]tage Hunk" })
				map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git [R]eset Hunk" })
				map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git [S]tage Buffer" })
				map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Git [U]ndo Stage Hunk" })
				map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git [R]eset Buffer" })
				map("n", "<leader>gh", gitsigns.preview_hunk, { desc = "Git Preview [H]unk" })
				map("n", "<leader>gb", gitsigns.blame_line, { desc = "Git [B]lame Line" })
				map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git [D]iff Against Index" })
				map("n", "<leader>gD", function()
					gitsigns.diffthis("@")
				end, { desc = "Git [D]iff Against Last Commit" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle Git Show [B]lame Line" })
				map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle Git Show [D]eleted" })
			end,
		},
	},
}
