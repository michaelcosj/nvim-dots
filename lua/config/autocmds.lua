-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
    group = vim.api.nvim_create_augroup("gis_checktime", { clear = true }),
    command = "silent! checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("gis_highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("gis_close_with_q", { clear = true }),
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("gis_wrap_spell", { clear = true }),
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- set <leader> f to call ptop format for pascal files
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("pascal_format", { clear = true }),
    pattern = { "pascal" },
    callback = function()
        vim.keymap.set('n', '<leader>f', ':silent !ptop %:p %:p<cr>', { desc = "Format file with ptop", })
    end,
})

-- set <leader> f to call ptop format for prisma files
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("prisma_format", { clear = true }),
    pattern = { "prisma" },
    callback = function()
        vim.keymap.set('n', '<leader>f', ':silent !pnpm prisma format<cr>', { desc = "Format file with prisma format", })
    end,
})

-- filetypes
vim.filetype.add({
    pattern = {
        ['.*%.blade%.php'] = 'blade',
    },
})

vim.filetype.add({
    pattern = {
        ['aliasrc'] = 'bash',
    },
})
