-- =============================================================================
-- General Settings
-- =============================================================================

-- set <space> as leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- basic vim settings
vim.o.mouse = "a"               -- enable mouse support
vim.o.relativenumber = true     -- enable relative line numbers
vim.o.number = true             -- show aboslute line
vim.o.ignorecase = true         -- search case-insensitive
vim.o.smartcase = true          -- search case-insensitive if all lowercase
vim.o.incsearch = true          -- enable incremental searching
vim.o.cursorline = true         -- highlight current line
vim.o.updatetime = 250          -- decrease update time
vim.o.ttimeoutlen = 50          -- decrease key code sequence timeout
vim.o.fileformat = "unix"       -- use unix-style line endings
vim.o.hlsearch = true           -- enable search highlighting
vim.o.splitbelow = true         -- with below, split new windows to left or right
vim.o.splitright = true         -- with above, split new windows to left or right
vim.o.tabstop = 2               -- tab charcter width
vim.o.softtabstop = 2           -- whitespace added or removed with tab or backspace
vim.o.shiftwidth = 2            -- whitespace used for one level of indentation
vim.o.expandtab = true          -- use space instead of tab character
vim.o.autoindent = true         -- autoindent new lines
vim.o.guicursor = ""            -- set cursor style to block
vim.o.inccommand = "split"      -- preview substitutions live
vim.o.signcolumn = "number"     -- display signs in the line number column
vim.o.showmode = false          -- hide mode
vim.o.cmdheight = 0             -- hide cmdline

-- set how certain whitespace characters are displayed in the editor
vim.o.list = true
vim.opt.listchars = { tab = "» ", nbsp = "␣" }

-- auto-complete to longest common match, then cycle
vim.o.wildmode = "longest:full,full"

-- diagnostic config
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = true, -- text shows up at the end of the line
  virtual_lines = false, -- text shows up underneath the line, with virtual lines

  -- auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

-- =============================================================================
-- Basic Keymaps
-- =============================================================================

-- center screen after moving up/down and searching
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- put without overwriting yank
vim.keymap.set("v", "p", '"_dP')

-- clear highlights on search when pressing <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- make split navigation easier
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- open quickfix list with diagnostics in the current buffer
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- =============================================================================
-- Basic Autocommands
-- =============================================================================

-- disable auto commenting on newline
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable auto-commenting on newline",
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({"c", "r", "o"})
  end,
})

-- remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  pattern = "*",
  command = ":%s/\\s\\+$//e"
})

-- highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function() vim.hl.on_yank() end,
})

-- =============================================================================
-- Enabling Plugins & LSP
-- =============================================================================

require("config.lazy")

vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime  = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
    },
  },
})
