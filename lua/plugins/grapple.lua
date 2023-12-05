return {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "mf", require("grapple").toggle, { desc = "Toggle grapple tag" })

        vim.keymap.set("n", "mj", require("grapple").cycle_backward, { desc = "Goto prev tag" })
        vim.keymap.set("n", "mk", require("grapple").cycle_forward, { desc = "Goto next tag" })

        vim.keymap.set("n", "ma", require("grapple").popup_tags, { desc = "Open tags popup" })

        vim.keymap.set("n", "md", function()
            require("grapple").select({ key = 1 })
        end, { desc = "Goto tag 1" })

        vim.keymap.set("n", "ms", function()
            require("grapple").select({ key = 2 })
        end, { desc = "Goto tag 2" })

        vim.keymap.set("n", "mq", function()
            require("grapple").select({ key = 3 })
        end, { desc = "Goto tag 3" })

        vim.keymap.set("n", "mw", function()
            require("grapple").select({ key = 4 })
        end, { desc = "Goto tag 4" })

        vim.keymap.set("n", "m;", function()
            require("grapple").select({ key = 5 })
        end, { desc = "Goto tag 5" })
    end
}
