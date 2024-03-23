return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-tree/nvim-web-devicons' },
            { "nvim-telescope/telescope-file-browser.nvim" },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')

            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous
                        },
                        n = {
                            ["q"] = actions.close
                        }
                    },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
                    }
                },
                extensions = {
                    file_browser = {
                        theme = "ivy",
                        path = "%:p:h",
                        follow_symlinks = true,
                        initial_mode = "normal",
                        grouped = true,
                    },
                },
            }

            local builtin = require('telescope.builtin')

            telescope.load_extension "file_browser"
            telescope.load_extension('fzf')

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope find files" })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = "Telescope old files" })
            vim.keymap.set('n', '<leader>ft', builtin.buffers, { desc = "Telescope open buffers" })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Telescope open help tags" })
            vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "Telescope open file browser" })

            -- Hijack netrw with telescope-find-files
            -- https://github.com/nvim-telescope/telescope.nvim/issues/2806#issuecomment-1904877188
            local find_files_hijack_netrw = vim.api.nvim_create_augroup("find_files_hijack_netrw", { clear = true })
            -- clear FileExplorer appropriately to prevent netrw from launching on folders
            -- netrw may or may not be loaded before telescope-find-files
            -- conceptual credits to nvim-tree and telescope-file-browser
            vim.api.nvim_create_autocmd("VimEnter", {
                pattern = "*",
                once = true,
                callback = function()
                    pcall(vim.api.nvim_clear_autocmds, { group = "FileExplorer" })
                end,
            })

            vim.api.nvim_create_autocmd("BufEnter", {
                group = find_files_hijack_netrw,
                pattern = "*",
                callback = function()
                    vim.schedule(function()
                        -- Early return if netrw or not a directory
                        if vim.bo[0].filetype == "netrw" or vim.fn.isdirectory(vim.fn.expand("%:p")) == 0 then
                            return
                        end

                        vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

                        require("telescope.builtin").find_files({
                            cwd = vim.fn.expand("%:p:h"),
                        })
                    end)
                end,
            })
        end
    },
}
