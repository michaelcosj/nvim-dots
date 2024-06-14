return {
    --[
    -- "vigoux/notifier.nvim",
    -- config = function()
    --     require 'notifier'.setup {}
    -- end
    --]


    'rcarriga/nvim-notify',
    config = function()
        local notify = require 'notify'
        notify.setup {
            background_colour = "#000000",
            render = "wrapped-compact",
            stages = "slide",
        }

        vim.notify = notify
        vim.keymap.set("n", "<leader>nh", ":Telescope notify theme=dropdown<CR>", { desc = "Telescope open notification history" })
    end
}
