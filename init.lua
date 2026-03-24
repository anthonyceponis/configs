-- Set leader key to Space
-- This must happen before lazy.nvim and other plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- THE STATUSLINE (Full Path at Bottom)
-- %F = Full path, %m = modified flag, %r = readonly, %= = right align, %l:%c = line:column
vim.opt.laststatus = 2 -- Always show statusline
vim.opt.statusline = " %F %m %r %= %y [%l:%c] "

-- EDITOR SETTINGS
vim.g.mapleader = " " -- Set space as your leader key
vim.opt.background = "light"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.diagnostic.config({
  underline = true,    -- This enables the underline
  virtual_text = true, -- (Optional) Shows the error message next to the code
  signs = true,        -- Keeps your gutter signs
  update_in_insert = false,
  severity_sort = true,
})

-- BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- PLUGIN SETUP
require("lazy").setup({
  -- LSP Support
  { "neovim/nvim-lspconfig" },              -- Provides the default server settings
  { "williamboman/mason.nvim", opts = {} }, -- Installer
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "pyright", "lua_ls", "ts_ls" },
      automatic_enable = true,
    }
  },

  -- The modern Choice for Auto-formatting
  { "stevearc/conform.nvim", opts = {} },

  -- Light Theme --
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- Ensure it loads first
    config = function()
      require('onedark').setup({
        -- Choose from 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
        style = 'light',
        transparent = false,   -- Show the actual theme background
        term_colors = true,    -- Use terminal colors
        ending_tildes = false, -- Show the end-of-buffer tildes
      })
      require('onedark').load()
    end,
  },

  -- FUZZY FINDER: Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Fuzzy find files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Fuzzy grep text" })
    end
  },

  -- LINTING --
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "flake8" }, -- or "ruff"
    }

    -- Create an autocommand to trigger linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,

})

-- MODERN LSP CONFIGURATION (0.11+)
-- Instead of per-server setup calls, we use a global autocommand
-- to set up keybindings whenever any LSP attaches to a buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    -- Native-style keybindings
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)  -- New 0.11 default style
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)      -- New 0.11 default style
    vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, opts) -- New 0.11 default style
  end,
})

-- Activate servers
-- Since we have nvim-lspconfig installed, vim.lsp.enable()
-- will automatically find and use the correct settings for Pyright.
vim.lsp.enable('pyright')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')

-- CONFORM (AUTO-FORMATTING)
require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" },
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
  },
  format_on_save = { timeout_ms = 2000, lsp_fallback = true },
})
