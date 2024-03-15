return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

        parser_config.blade = {
            install_info = {
                url = "https://github.com/EmranMR/tree-sitter-blade",
                files = { "src/parser.c" },
                branch = "main",
            },
            filetype = "blade"
        }

        vim.filetype.add({
            pattern = {
                ['.*%.blade%.php'] = 'blade',
            },
        })

        configs.setup({
            ensure_installed = {
                "c", "lua", "vim", "vimdoc",
                "query", "go", "typescript",
                "javascript", "bash", "html",
                "css", "python", "rust", "templ",
                "svelte", "sql", "php_only", "blade"
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })

    end
}
