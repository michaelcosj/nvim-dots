return {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "mg", require("grapple").toggle, { desc = "Toggle grapple tag" })

        vim.keymap.set("n", "mj", require("grapple").cycle_backward, { desc = "Goto prev tag" })
        vim.keymap.set("n", "mk", require("grapple").cycle_forward, { desc = "Goto next tag" })

        vim.keymap.set("n", "ma", require("grapple").toggle_tags, { desc = "Open tags popup" })

        vim.keymap.set("n", "mf", function()
            require("grapple").select({ index = 1 })
        end, { desc = "Goto tag 1" })

        vim.keymap.set("n", "md", function()
            require("grapple").select({ index = 2 })
        end, { desc = "Goto tag 2" })

        vim.keymap.set("n", "ms", function()
            require("grapple").select({ index = 3 })
        end, { desc = "Goto tag 3" })

        vim.keymap.set("n", "mn", function()
            require("grapple").select({ index = 4 })
        end, { desc = "Goto tag 4" })

        vim.keymap.set("n", "m;", function()
            require("grapple").select({ index = 5 })
        end, { desc = "Goto tag 5" })
    end
}
