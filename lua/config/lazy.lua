local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- coq configuration
-- Have to place it before lazy setup
-- https://github.com/ms-jpq/coq_nvim/issues/403
vim.g.coq_settings = {
    auto_start = true,
    keymap = { recommended = false },
    clients = {
        lsp = {
            always_on_top = {},
        }
    }
}

require("lazy").setup("plugins", {
    checker = { enabled = true },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    }
})
