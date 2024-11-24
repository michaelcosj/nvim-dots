return {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set("n", ",,", require("grapple").toggle_tags, { desc = "Open tags popup" })

		vim.keymap.set("n", ",g", require("grapple").toggle, { desc = "Toggle grapple tag" })

		vim.keymap.set("n", ",j", function()
			require("grapple").cycle_tags("prev")
		end, { desc = "Goto prev tag" })

		vim.keymap.set("n", ",k", function()
			require("grapple").cycle_tags("next")
		end, { desc = "Goto next tag" })

		vim.keymap.set("n", ",f", function()
			require("grapple").select({ index = 1 })
		end, { desc = "Goto tag 1" })

		vim.keymap.set("n", ",d", function()
			require("grapple").select({ index = 2 })
		end, { desc = "Goto tag 2" })

		vim.keymap.set("n", ",s", function()
			require("grapple").select({ index = 3 })
		end, { desc = "Goto tag 3" })

		vim.keymap.set("n", ",a", function()
			require("grapple").select({ index = 4 })
		end, { desc = "Goto tag 4" })

		vim.keymap.set("n", ",m", function()
			require("grapple").select({ index = 5 })
		end, { desc = "Goto tag 5" })
	end,
}
