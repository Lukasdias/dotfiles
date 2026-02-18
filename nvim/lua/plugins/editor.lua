return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find in files (grep)" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fs", "<cmd>Telescope grep_string<CR>", desc = "Find string under cursor" },
      { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Find commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
      { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Find projects" },
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fa", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", desc = "Find all files" },
      { "<leader>fe", "<cmd>Telescope file_browser<CR>", desc = "File browser" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false } },
          file_ignore_patterns = {
            "node_modules", "%.git/", "dist/", "build/", "out/", "%.next/",
            ".nuxt/", ".cache", "target/", "__pycache__/", "%.vscode/", "%.idea/",
            "*.log", "%.lock", "*.tmp", ".DS_Store", "Thumbs.db",
          },
          preview = { treesitter = false },
        },
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = {
              "node_modules", "%.git/", "dist/", "build/", "out/", "%.next/",
              ".nuxt/", ".cache", "target/", "__pycache__/", "%.vscode/", "%.idea/",
              "*.log", "%.lock", "*.tmp", ".DS_Store", "Thumbs.db",
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              n = {
                N = require("telescope").extensions.file_browser.actions.create,
                h = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                ["/"] = function() vim.cmd("startinsert") end,
              },
            },
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "tris203/precognition.nvim",
    config = function() require("precognition").setup() end,
  },

  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = {
      cursor = { enable = true, timing = function() return 150 end },
      scroll = { enable = false },
      resize = { enable = true, timing = function() return 100 end },
      open = { enable = true, timing = function() return 150 end },
      close = { enable = true, timing = function() return 150 end },
    },
  },

  {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
      draw = { delay = 50, animation = function() return 10 end },
    },
  },

  {
    "echasnovski/mini.cursorword",
    event = "VeryLazy",
    opts = { delay = 100 },
  },

  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    opts = {
      buffer = { suffix = "b" },
      comment = { suffix = "c" },
      conflict = { suffix = "x" },
      diagnostic = { suffix = "d" },
      file = { suffix = "f" },
      indent = { suffix = "i" },
      jump = { suffix = "j" },
      location = { suffix = "l" },
      oldfile = { suffix = "o" },
      quickfix = { suffix = "q" },
      treesitter = { suffix = "t" },
      undo = { suffix = "u" },
      window = { suffix = "w" },
      yank = { suffix = "y" },
    },
  },
}
