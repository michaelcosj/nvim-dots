-- Basic Key map settings


local opts = { silent = true }
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- leader w for write
map("n", "<leader>w", "<cmd>w<cr>")

-- turn of highlighting after search
map("n", "<Esc>", "<cmd>noh<cr>")

-- Arrow keys to adjust window size
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Up>", "<cmd>resize -2<CR>", opts)

-- buffer maps
map("n", "<leader>bn", "<cmd>bnext<cr>", opts)
map("n", "<leader>bp", "<cmd>bprevious<cr>", opts)

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>ws", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split window right", remap = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move in insert mode with the <ctrl> hjkl keys
map("i", "<C-h>", "<Left>", { desc = "Go to left window", remap = true })
map("i", "<C-j>", "<Down>", { desc = "Go to lower window", remap = true })
map("i", "<C-k>", "<Up>", { desc = "Go to upper window", remap = true })
map("i", "<C-l>", "<Right>", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
