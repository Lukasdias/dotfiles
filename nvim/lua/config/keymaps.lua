local keymap = vim.keymap.set

-- Clear search highlight
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save file
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Exit insert mode alternatives
keymap("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Quit
keymap("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })
keymap("i", "<C-q>", "<Esc><cmd>q<CR>", { desc = "Quit" })

-- Leader shortcuts
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })
keymap("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Mouse behavior
keymap("n", "<LeftMouse>", "<LeftMouse>", { desc = "Click to position" })
keymap("n", "<2-LeftMouse>", "<LeftMouse>i", { desc = "Double-click to insert" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
