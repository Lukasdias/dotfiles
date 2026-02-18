return {
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gg", "<cmd>Git<CR>", desc = "Open Git status" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff" },
      { "<leader>gl", "<cmd>Git log<CR>", desc = "Git log" },
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open git diff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
    },
  },
}
