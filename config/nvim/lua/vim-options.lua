vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===========================================================================
-- Basics
-- ===========================================================================

vim.opt.mouse = "a"
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.encoding = "utf-8"
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.fileformat="unix"
vim.opt.hlsearch = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- ===========================================================================
-- Commands & Aliases
-- ===========================================================================

-- center screen after moving up/down and searching
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
vim.keymap.set("n", "n", "nzzzv", {})
vim.keymap.set("n", "N", "Nzzzv", {})

-- replace all aliased to S
vim.keymap.set("n", "S", ":%s//g<Left><Left>", {})

-- disable auto commenting on newline
-- autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

-- copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed)
-- requires xterm_clipboard to be enabled (vim --version | grep xterm_clipboard)
vim.keymap.set("n", "<C-c>", "\"+y", {})
vim.keymap.set("n", "<C-p>", "\"+P", {})

-- remove trailing whitespace on save
-- autocmd BufWritePre * :%s/\s\+$//e

-- put without overwriting yank
vim.keymap.set({"v", "n"}, "p", "\"_dP", {})

