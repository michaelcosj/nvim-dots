local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}


return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        'FelipeLema/cmp-async-path',
        {
            'L3MON4D3/LuaSnip',
            version = "v2.*",
            build = "make install_jsregexp",
            dependencies = {
                "rafamadriz/friendly-snippets"
            },
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = string.format('%s  %s', kind_icons[vim_item.kind], vim_item.kind)
                    vim_item.menu = ({
                        path = "[Path]",
                        buffer = "[Buf]",
                        cmdline = "[Cmd]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snip]",
                        nvim_lua = "[Lua]",
                    })[entry.source.name]
                    return vim_item
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),

                ['<C-o>'] = cmp.mapping.open_docs(),
                ['<C-c>'] = cmp.mapping.close_docs(),

                ['<C-;>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),

                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),

                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                ['<C-h>'] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end),

                ['<C-H>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lua' },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'async_path' },
                {
                    name = 'buffer',
                    option = {
                        -- to show text from all buffers
                        get_bufnrs = function()
                            return vim.api.nvim_list_bufs()
                        end
                    }
                },
            }, {})
        })

        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'buffer' },
            })
        })

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'async_path' }
            }, {
                { name = 'cmdline' }
            })
        })
    end
}
