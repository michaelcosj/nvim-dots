return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' }, { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
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
                    },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                    }
                },
                extensions = {
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                        path = "%:p:h",
                        follow_symlinks = true,
                        initial_mode = "normal"
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
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
}
