-- Leader key (must be set before plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Essential settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- WSL/Windows Terminal performance
vim.opt.lazyredraw = true
vim.opt.ttyfast = true
vim.opt.synmaxcol = 200

-- Smooth UI animations
vim.opt.mousescroll = "ver:1,hor:1"
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_scroll_animation_length = 0.1

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 8
vim.opt.undofile = true

-- Swap file management
vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("state") .. "/swap/"
vim.opt.updatecount = 100

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
