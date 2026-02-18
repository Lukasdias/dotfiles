-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys (must be before plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.diagnostics")

-- Load plugins
require("lazy").setup({
  spec = {
    { import = "plugins.colorscheme" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.git" },
    { import = "plugins.lsp" },
    { import = "plugins.tools" },
    { import = "plugins.completion" },
  },
  defaults = { lazy = false },
  install = { colorscheme = { "catppuccin-mocha" } },
  checker = { enabled = false },
})
