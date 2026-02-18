return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
      },
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          css = { icon = "", color = "#1572B6", name = "Css" },
          ["vite.config.ts"] = { icon = "", color = "#646CFF", name = "ViteConfig" },
          ["vite.config.js"] = { icon = "", color = "#646CFF", name = "ViteConfig" },
          ["vite.config.mjs"] = { icon = "", color = "#646CFF", name = "ViteConfig" },
          ["next.config.js"] = { icon = "▲", color = "#000000", name = "NextConfig" },
          ["next.config.mjs"] = { icon = "▲", color = "#000000", name = "NextConfig" },
          ["next.config.ts"] = { icon = "▲", color = "#000000", name = "NextConfig" },
          ["stories.tsx"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
          ["stories.ts"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
          ["stories.jsx"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
          ["stories.js"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
        },
        override_by_extension = {
          ["stories.tsx"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
          ["stories.ts"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
          ["stories.jsx"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
          ["stories.js"] = { icon = "📖", color = "#FF4785", name = "Storybook" },
        },
        default = true,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "catppuccin" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {},
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "<leader>x", "<cmd>bdelete<CR>", desc = "Close buffer" },
    },
  },

  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep<CR>"),
        dashboard.button("e", "  File explorer", ":Neotree<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = { timeout = 10000 },
  },

  {
    "j-hui/fidget.nvim",
    config = function() require("fidget").setup() end,
  },

  {
    "b0o/incline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.mauve, guifg = colors.base },
            InclineNormalNC = { guifg = colors.blue, guibg = colors.mantle },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = { cursorline = true },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then filename = "[+] " .. filename end
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
}
