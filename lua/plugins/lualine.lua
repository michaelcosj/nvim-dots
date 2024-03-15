return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'cbochs/grapple.nvim' },
    opts = {
        options = {
            theme = 'nightfly',
            component_separators = { left = '|', right = '|' },
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_b = {
                "branch", "diff", "diagnostics",
                {
                    require("grapple").statusline,
                    cond = require("grapple").exists
                }
            }
        }
    }
}
