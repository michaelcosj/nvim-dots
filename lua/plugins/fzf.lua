-- https://github.com/ibhagwan/fzf-lua
return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	config = function(opts)
		local fzf_lua = require("fzf-lua")
		fzf_lua.setup({
			fzf_colors = true,
			winopts = {
				width = 0.8,
				height = 0.8,
				default = {
					preview = "bat_native",
				},
				preview = {
					hidden = "hidden",
				},
			},
			files = {
				cwd_prompt = false,
			},
			grep = {
				actions = {
					["ctrl-q"] = {
						fn = fzf_lua.actions.file_edit_or_qf,
						prefix = "select-all+",
					},
				},
			},
		})

		fzf_lua.config.defaults.keymap.builtin["<C-d>"] = "preview-page-down"
		fzf_lua.config.defaults.keymap.builtin["<C-u>"] = "preview-page-up"
		fzf_lua.config.defaults.keymap.builtin["<C-p>"] = "toggle-preview"

		vim.keymap.set("n", "<leader>ff", fzf_lua.files, { desc = "[F]ind files" })
		vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep, { desc = "[F]ind by grep" })
		vim.keymap.set("n", "<leader>fo", fzf_lua.oldfiles, { desc = "[F]ind recent files" })
		vim.keymap.set("n", "<leader><leader>", fzf_lua.buffers, { desc = "[] Find buffers" })
		vim.keymap.set("n", "<leader>fh", fzf_lua.helptags, { desc = "[F]ind help tags" })

		vim.keymap.set("n", "<leader>/", fzf_lua.lgrep_curbuf, { desc = "[/] Find by grep in current buffer" })

		fzf_lua.register_ui_select(function(_, items)
			local min_h, max_h = 0.15, 0.70
			local h = (#items + 4) / vim.o.lines
			if h < min_h then
				h = min_h
			elseif h > max_h then
				h = max_h
			end
			return { winopts = { height = h, width = 0.60, row = 0.40 } }
		end)

		-- hijack netrw with fzf-lua
		-- Disable netrw
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- https://www.reddit.com/r/neovim/comments/1avthpm/small_snippet_to_use_fzflua_as_replacement_for/
		-- Open fzf in the directory when opening a directory buffer
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

				-- Open fzf in the directory
				vim.schedule(function()
					fzf_lua.files({
						cwd = vim.fn.expand("%:p:h"),
					})
				end)
			end,
		})

		-- This makes sure that the explorer will open again after opening same buffer again
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*",
			callback = function(args)
				local bufname = vim.api.nvim_buf_get_name(args.buf)
				if vim.fn.isdirectory(bufname) == 0 then
					return
				end
				loaded_buffs[bufname] = nil
			end,
		})
	end,
}
