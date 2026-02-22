return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<M-l>",
        accept_word = "<M-right>",
        next = "<M-j>",
        prev = "<M-k>",
        dismiss = "<M-h>",
      },
    },
    panel = {
      enabled = true,
      keymap = {
        open = "<M-p>",
        accept = "<CR>",
        refresh = "r",
        close = "q",
      },
    },
    server = {
      override_editor_settings = true,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}
