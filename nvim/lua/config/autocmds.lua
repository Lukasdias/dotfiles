local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Swap file cleanup on exit
autocmd("VimLeavePre", {
  group = augroup("SwapCleanup", { clear = true }),
  callback = function()
    vim.fn.system("find " .. vim.fn.stdpath("state") .. "/swap/ -name '*.swp' -type f -mmin +60 -delete 2>/dev/null || true")
  end,
})

-- Clean swap files command
vim.keymap.set("n", "<leader>sc", function()
  local swap_dir = vim.fn.stdpath("state") .. "/swap/"
  vim.fn.system("rm -f " .. swap_dir .. "*.swp")
  vim.notify("Swap files cleaned up", "info")
end, { desc = "Clean swap files" })

-- OpenCode Integration
vim.api.nvim_create_user_command("OpenCode", function(opts)
  local cmd = "opencode " .. (opts.args or "")
  vim.cmd("terminal " .. cmd)
end, { nargs = "*" })

vim.keymap.set("n", "<leader>oc", ":OpenCode ", { desc = "Run OpenCode command" })
vim.keymap.set("n", "<leader>oh", ":OpenCode --help<CR>", { desc = "OpenCode help" })
vim.keymap.set("n", "<leader>ov", ":vsplit | terminal opencode<CR>", { desc = "Open OpenCode in vertical split" })
