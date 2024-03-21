return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "williamboman/mason.nvim" },
        {
            "jay-babu/mason-null-ls.nvim",
            opts = {
                ensure_installed = {
                    "mypy", "black", "pint", "blade_formatter" }
            }
        }
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                -- python
                null_ls.builtins.formatting.black,
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = function()
                        local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
                        return { "--python-executable", virtual .. "/bin/python3" }
                    end,
                }),

                -- php
                null_ls.builtins.formatting.pint,
                null_ls.builtins.formatting.blade_formatter
            }
        })
    end
}
