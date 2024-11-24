return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
					},
					buffers = {
						previewer = false,
					},
				},
			})

			pcall(telescope.load_extension, "fzf")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by grep" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind recent files" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[] Find buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind help tags" })

			-- [Stolen from https://github.com/nvim-lua/kickstart.nvim]
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzy search current buffer" })

			vim.keymap.set("n", "<leader>f/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[F]ind [/] in Open Files" })

			-- Hijack netrw with telescope-find-files
			-- https://github.com/nvim-telescope/telescope.nvim/issues/2806#issuecomment-1904877188
			-- adapted from this - https://www.reddit.com/r/neovim/comments/1avthpm/small_snippet_to_use_fzflua_as_replacement_for/
			-- Open telescope find fles in the directory when opening a directory buffer
			local loaded_buffs = {}
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function(args)
					-- If netrw is enabled just keep it, but it should be disabled
					if vim.bo[args.buf].filetype == "netrw" then
						return
					end

					-- Get buffer name and check if it's a directory
					local bufname = vim.api.nvim_buf_get_name(args.buf)
					if vim.fn.isdirectory(bufname) == 0 then
						return
					end

					-- Prevent reopening the explorer after it's been closed
					if loaded_buffs[bufname] then
						return
					end

					loaded_buffs[bufname] = true

					-- Do not list directory buffer and wipe it on leave
					vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = args.buf })
					vim.api.nvim_set_option_value("buflisted", false, { buf = args.buf })

					-- Open telescope in the directory
					vim.schedule(function()
						builtin.find_files({
							cwd = vim.fn.expand("%:p:h"),
						})
					end)
				end,
			})

			-- This makes sure that the explorer will open again after opening same buffer again
			-- FIXME: this doesn't work
			vim.api.nvim_create_autocmd("BufLeave", {
				pattern = "*",
				callback = function(args)
					local bufname = vim.api.nvim_buf_get_name(args.buf)

					if vim.bo.filetype == "TelescopePrompt" then
						loaded_buffs[bufname] = nil
					end
				end,
			})
		end,
	},
}
