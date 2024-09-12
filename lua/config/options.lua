-- Basic vim settings

local options = {
	backup = false,
	background = "dark",
	clipboard = "unnamedplus",
	completeopt = { "menuone", "noselect" },
	conceallevel = 3,
	cursorline = true,
	expandtab = true,
	ignorecase = true,
	laststatus = 3,
	list = true,
	listchars = { trail = "·", tab = "  " },
	mouse = "a",
	number = true,
	pumblend = 10,
	pumheight = 10,
	relativenumber = true,
	scrolloff = 8,
	shiftwidth = 0,
	showmode = false,
	sidescrolloff = 8,
	signcolumn = "yes",
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 2,
	termguicolors = true,
	timeout = true,
	timeoutlen = 500,
	undofile = true,
	updatetime = 300,
	wrap = false,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")

-- set c fileype for headers, not cpp
vim.g.c_syntax_for_h = 1

-- set templ filetype
vim.filetype.add({ extension = { templ = "templ" } })

vim.cmd([[
  if exists("$TMUX")
      let &t_RB = "\ePtmux;\e\e]11;?\007\e\\"
  endif
  if has('termguicolors') "true colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
]])
