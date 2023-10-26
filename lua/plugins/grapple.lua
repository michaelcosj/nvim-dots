return {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "<leader>ma", require("grapple").toggle, { desc = "Toggle grapple tag" })

        vim.keymap.set("n", "<leader>mj", require("grapple").cycle_backward, { desc = "Goto prev tag" })
        vim.keymap.set("n", "<leader>mk", require("grapple").cycle_forward, { desc = "Goto next tag" })

        vim.keymap.set("n", "<leader>mt", require("grapple").popup_tags, { desc = "Open tags popup" })

        vim.keymap.set("n", "<leader>m1", function()
            require("grapple").select({ key = 1 })
        end, { desc = "Goto tag 1" })

        vim.keymap.set("n", "<leader>m2", function()
            require("grapple").select({ key = 2 })
        end, { desc = "Goto tag 2" })

        vim.keymap.set("n", "<leader>m3", function()
            require("grapple").select({ key = 3 })
        end, { desc = "Goto tag 3" })

        vim.keymap.set("n", "<leader>m4", function()
            require("grapple").select({ key = 4 })
        end, { desc = "Goto tag 4" })

        vim.keymap.set("n", "<leader>m5", function()
            require("grapple").select({ key = 5 })
        end, { desc = "Goto tag 5" })
    end
}
