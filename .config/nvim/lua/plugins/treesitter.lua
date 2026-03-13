return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",

  config = function()
    local ts = require("nvim-treesitter")

    -- check for dependencies before installing
    local function has_treesitter_cli()
      return vim.fn.executable("tree-sitter") == 1
    end

    local function has_c_compiler()
      return vim.fn.executable("cc") == 1
      or vim.fn.executable("gcc") == 1
      or vim.fn.executable("clang") == 1
      or vim.fn.executable("zig") == 1
    end

    -- parsers to install
    local parsers = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    }

    if has_treesitter_cli() and has_c_compiler() then
      -- install missing parsers asnychronously
      ts.install(parsers)
    else
      local missing = {}
      if not has_treesitter_cli() then table.insert(missing, "tree-sitter-cli") end
      if not has_c_compiler() then table.insert(missing, "a C compiler (gcc/clang/zig)") end
      vim.notify(
        "[treesitter] Skipping parser install — missing: " .. table.concat(missing, ", "),
        vim.log.levels.WARN
      )
    end

    -- enabling highlighting and other features
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-features", { clear = true }),
      callback = function(ev)
        -- pcall so a missing parser doesn't throw an error
        pcall(vim.treesitter.start, ev.buf)
      end,
    })
  end,
}
