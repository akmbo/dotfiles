-- =============================================================================
-- General Settings
-- =============================================================================

-- set <space> as leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- basic vim settings
vim.o.mouse = "a" -- enable mouse support
vim.o.relativenumber = true -- enable relative line numbers
vim.o.number = true -- show aboslute line
vim.o.ignorecase = true -- search case-insensitive
vim.o.smartcase = true -- search case-insensitive if all lowercase
vim.o.incsearch = true -- enable incremental searching
vim.o.cursorline = true -- highlight current line
vim.o.updatetime = 250 -- decrease update time
vim.o.ttimeoutlen = 50 -- decrease key code sequence timeout
vim.o.fileformat = "unix" -- use unix-style line endings
vim.o.hlsearch = true -- enable search highlighting
vim.o.splitbelow = true -- with below, split new windows to left or right
vim.o.splitright = true -- with above, split new windows to left or right
vim.o.tabstop = 2 -- tab charcter width
vim.o.softtabstop = 2 -- whitespace added or removed with tab or backspace
vim.o.shiftwidth = 2 -- whitespace used for one level of indentation
vim.o.expandtab = true -- use space instead of tab character
vim.o.autoindent = true -- autoindent new lines
vim.o.guicursor = "" -- set cursor style to block
vim.o.inccommand = "split" -- preview substitutions live
vim.o.signcolumn = "yes" -- always display sign column (use "number" to collapse)
vim.o.cmdheight = 1 -- height of the command-line area
vim.o.laststatus = 1 -- only show status line with multiple windows/splits

-- set how certain whitespace characters are displayed in the editor
vim.o.list = true
vim.opt.listchars = { tab = "» ", nbsp = "␣" }

-- auto-complete to longest common match, then cycle
vim.o.wildmode = "longest:full,full"

-- diagnostic config
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = true, -- text shows up at the end of the line
  virtual_lines = false, -- text shows up underneath the line, with virtual lines

  -- auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
})

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
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- =============================================================================
-- Plugins
-- =============================================================================

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/catppuccin/nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/saghen/blink.cmp", vim.version.range("1.x") },
  "https://github.com/lewis6991/gitsigns.nvim",
})

require("catppuccin").setup({
  flavour = "mocha",
  lsp_styles = {
    underlines = {
      errors = { "undercurl" },
      hints = { "undercurl" },
      warnings = { "undercurl" },
      information = { "undercurl" },
    },
  },
  integrations = {
    mason = true,
    fzf = true,
    blink_cmp = {
      style = "bordered",
    },
    gitsigns = true,
  },
})
vim.cmd.colorscheme("catppuccin-nvim")

require("mason").setup({
  ensure_installed = { "lua_ls" },
})

require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = {
      "ruff_fix",
      "ruff_format",
    },
  },
})

require("blink.cmp").setup({
  keymap = { preset = "super-tab" },
  appearance = { nerd_font_variant = "mono" },
  completion = { documentation = { auto_show = false } },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "lua" },
})

-- plugin keymaps

vim.keymap.set("n", "<leader>sf", function()
  require("fzf-lua").files()
end, { desc = "[S]search [f]iles" })

-- =============================================================================
-- LSP
-- =============================================================================

vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "ty",
})
