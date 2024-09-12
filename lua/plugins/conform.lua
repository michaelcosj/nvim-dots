-- Disable auto format
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end

	vim.notify("auto format disabled")
end, { desc = "Disable autoformat-on-save", bang = true })

-- Enable auto format
vim.api.nvim_create_user_command("FormatEnable", function(args)
	if args.bang then
		-- FormatEnable! will enable formatting just for this buffer
		vim.b.disable_autoformat = false
	else
		vim.g.disable_autoformat = false
	end

	vim.notify("auto format enabled")
end, { desc = "Re-enable autoformat-on-save" })

-- https://github.com/stevearc/conform.nvim
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "biome" },
			typescript = { "biome" },
			php = { "pint" },
			vue = { "prettierd" },
			blade = { "blade_formatter" },
		},
		format_on_save = function(bufnr)
			if not (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat) then
				vim.notify("formatting...")
				return { timeout_ms = 500, lsp_format = "fallback" }
			end
		end,
	},
}
