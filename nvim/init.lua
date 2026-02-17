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

-- Set leader key (space is most popular, easy to reach)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Essential settings for a comfortable experience
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers (great for vim motions)
vim.opt.mouse = "a"             -- Enable mouse (helpful while learning)
vim.opt.ignorecase = true       -- Case insensitive search
vim.opt.smartcase = true        -- Unless you use capitals
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.breakindent = true      -- Wrapped lines keep indentation
vim.opt.tabstop = 2             -- Tab width
vim.opt.shiftwidth = 2          -- Indent width
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.cursorline = true       -- Highlight current line
vim.opt.termguicolors = true    -- True color support
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.updatetime = 300        -- Slightly slower for WSL performance
vim.opt.timeoutlen = 500        -- Slightly slower for WSL performance

-- WSL/Windows Terminal performance optimizations
vim.opt.lazyredraw = true       -- Don't redraw during macros
vim.opt.ttyfast = true          -- Faster terminal connection
vim.opt.synmaxcol = 200         -- Limit syntax highlighting to 200 columns

-- Smooth UI animations (like Takuya's setup)
vim.opt.mousescroll = "ver:1,hor:1"  -- Smooth mouse scrolling
vim.g.neovide_cursor_animation_length = 0.05  -- Fast cursor animations (if using neovide)
vim.g.neovide_scroll_animation_length = 0.1   -- Smooth scroll animations (if using neovide)

-- Diagnostics configuration (Neovim 0.11+ requires explicit opt-in)
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Could be '■', '▎', 'x', '●'
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
vim.opt.splitright = true       -- Vertical splits to the right
vim.opt.splitbelow = true       -- Horizontal splits below
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.scrolloff = 8           -- Keep 8 lines above/below cursor
vim.opt.undofile = true         -- Persistent undo

-- Swap file management (prevent annoying warnings)
vim.opt.swapfile = true         -- Keep swap files for crash recovery
vim.opt.directory = vim.fn.stdpath("state") .. "/swap/" -- Centralized swap location
vim.opt.updatecount = 100       -- Write swap file every 100 characters
vim.opt.updatetime = 250        -- Also affects swap file writes

-- Auto-delete swap files on clean exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Clean up swap files older than 1 hour on exit
    vim.fn.system("find " .. vim.fn.stdpath("state") .. "/swap/ -name '*.swp' -type f -mmin +60 -delete 2>/dev/null || true")
  end,
})

-- Basic keymaps to make life easier
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- BEGINNER-FRIENDLY: Easy mode switching and saving/quitting
-- Double-tap Escape to ensure you're in Normal mode (muscle memory helper)
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode (alternative)" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode (alternative)" })

-- Ctrl+Q to quit (like most apps)
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("i", "<C-q>", "<Esc><cmd>q<CR>", { desc = "Quit" })

-- Leader shortcuts for save/quit (press Space then the key)
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })
vim.keymap.set("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Swap file management commands
vim.keymap.set("n", "<leader>sc", function()
  -- Clean up all swap files
  local swap_dir = vim.fn.stdpath("state") .. "/swap/"
  vim.fn.system("rm -f " .. swap_dir .. "*.swp")
  vim.notify("Swap files cleaned up", "info")
end, { desc = "Clean swap files" })

-- When you click with mouse, stay in Normal mode but position cursor
vim.keymap.set("n", "<LeftMouse>", "<LeftMouse>", { desc = "Click to position" })

-- Double-click to enter insert mode at that position
vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse>i", { desc = "Double-click to insert" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Load plugins
require("lazy").setup({
  -- Colorscheme: Catppuccin is beautiful and easy on the eyes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Which-key: Shows available keybindings (ESSENTIAL for learning!)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" },
    },
  },

  -- File explorer (like VSCode sidebar)
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

  -- Web devicons (file icons)
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        -- explicitly set icons for various file types
        override = {
          css = {
            icon = "",
            color = "#1572B6",
            name = "Css"
          },
          -- Vite configs
          ["vite.config.ts"] = {
            icon = "",
            color = "#646CFF",
            name = "ViteConfig"
          },
          ["vite.config.js"] = {
            icon = "",
            color = "#646CFF",
            name = "ViteConfig"
          },
          ["vite.config.mjs"] = {
            icon = "",
            color = "#646CFF",
            name = "ViteConfig"
          },
          -- Next.js configs
          ["next.config.js"] = {
            icon = "▲",
            color = "#000000",
            name = "NextConfig"
          },
          ["next.config.mjs"] = {
            icon = "▲",
            color = "#000000",
            name = "NextConfig"
          },
          ["next.config.ts"] = {
            icon = "▲",
            color = "#000000",
            name = "NextConfig"
          },
          -- Storybook stories
          ["stories.tsx"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          },
          ["stories.ts"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          },
          ["stories.jsx"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          },
          ["stories.js"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          }
        },
        -- Override by file extension pattern
        override_by_extension = {
          ["stories.tsx"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          },
          ["stories.ts"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          },
          ["stories.jsx"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          },
          ["stories.js"] = {
            icon = "📖",
            color = "#FF4785",
            name = "Storybook"
          }
        },
        default = true,
      })
    end,
  },

  -- Fuzzy finder (Ctrl+P like in VSCode)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
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
      { "<leader>fa", "<cmd>Telescope find_files hidden=true no_ignore=true<CR>", desc = "Find all files (including hidden/ignored)" },
      { "<leader>fe", "<cmd>Telescope file_browser<CR>", desc = "File browser" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
          -- File/directory ignore patterns
          file_ignore_patterns = {
            -- Dependencies and package managers
            "node_modules",
            "%.pnpm%-store",
            "%.yarn",

            -- Version control
            "%.git/",
            "%.svn/",
            "%.hg/",

            -- Build outputs
            "dist/",
            "build/",
            "out/",
            "%.next/",
            ".nuxt/",
            ".vuepress/",
            ".cache",
            ".parcel-cache",
            "target/",
            "%.cargo/",
            "__pycache__/",
            "%.pytest_cache/",
            ".mypy_cache",

            -- Documentation
            ".docusaurus/",
            "docs/build",
            ".vitepress/cache",

            -- IDE and editors
            "%.vscode/",
            "%.idea/",
            ".vs/",
            "*.swp",
            "*.swo",
            ".DS_Store",

            -- Logs and temporary files
            "*.log",
            "%.lock",
            "package%-lock.json",
            "yarn.lock",
            "pnpm-lock.yaml",
            "*.tmp",
            "*.temp",

            -- OS generated files
            "Thumbs.db",
            "Desktop.ini",
          },
          -- Disable treesitter previewer to avoid ft_to_lang error
          preview = {
            treesitter = false,
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            -- Additional ignore patterns for find_files
            file_ignore_patterns = {
              -- Dependencies and package managers
              "node_modules",
              "%.pnpm%-store",
              "%.yarn",

              -- Version control
              "%.git/",
              "%.svn/",
              "%.hg/",

              -- Build outputs
              "dist/",
              "build/",
              "out/",
              "%.next/",
              ".nuxt/",
              ".vuepress/",
              ".cache",
              ".parcel-cache",
              "target/",
              "%.cargo/",
              "__pycache__/",
              "%.pytest_cache/",
              ".mypy_cache",

              -- Documentation
              ".docusaurus/",
              "docs/build",
              ".vitepress/cache",

              -- IDE and editors
              "%.vscode/",
              "%.idea/",
              ".vs/",
              "*.swp",
              "*.swo",
              ".DS_Store",

              -- Logs and temporary files
              "*.log",
              "%.lock",
              "package%-lock.json",
              "yarn.lock",
              "pnpm-lock.yaml",
              "*.tmp",
              "*.temp",

              -- OS generated files
              "Thumbs.db",
              "Desktop.ini",
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            mappings = {
              ["n"] = {
                ["N"] = require("telescope").extensions.file_browser.actions.create,
                ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                ["/"] = function()
                  vim.cmd("startinsert")
                end,
                ["<C-u>"] = function(prompt_bufnr)
                  for i = 1, 10 do
                    require("telescope.actions").move_selection_previous(prompt_bufnr)
                  end
                end,
                ["<C-d>"] = function(prompt_bufnr)
                  for i = 1, 10 do
                    require("telescope.actions").move_selection_next(prompt_bufnr)
                  end
                end,
                ["<PageUp>"] = require("telescope.actions").preview_scrolling_up,
                ["<PageDown>"] = require("telescope.actions").preview_scrolling_down,
              },
            },
          },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
    end,
  },

  -- Syntax highlighting (makes code look beautiful)
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

  -- Statusline (pretty bottom bar)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
      },
    },
  },

  -- Auto-pairs (automatically close brackets, quotes, etc.)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  -- Indent guides (shows indentation levels)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Comment toggling (gcc to comment a line, gc in visual mode)
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Surround (easily add/change/delete surrounding characters)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Precognition (virtual text hints for motions)
  {
    "tris203/precognition.nvim",
    config = function()
      require("precognition").setup()
    end,
  },



  -- Incline (floating statuslines for inactive buffers)
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
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- Inc-rename (incremental LSP renaming)
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },





  -- Buffer tabs at the top
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

  -- Dashboard (nice start screen)
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

  -- Notifications (prettier messages)
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 10000,
    },
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },

  -- Better diagnostics/quickfix window
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions/References (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {},
  },

  -- Terminal (like VSCode integrated terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<leader>T", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
    },
  },

  -- Global search and replace (like VSCode find/replace)
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", '<cmd>lua require("spectre").open()<CR>', desc = "Search and replace" },
      { "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = "Search current word" },
      { "<leader>sf", '<cmd>lua require("spectre").open_file_search()<CR>', desc = "Search in current file" },
    },
  },

  -- Session management (auto-save/restore workspace like VSCode)
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      })
    end,
  },

  -- Project management (like VSCode workspaces)
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
      })
    end,
  },

  -- Git integration (Fugitive for commands - stable and works with any Neovim version)
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

   -- Better Git diff viewer (like VSCode git features)
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open git diff" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
    },
  },

  -- Mason: LSP server manager (like VSCode extensions)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
   },

   -- LSP Config for IntelliSense (Neovim 0.11+ native API)
   {
     "neovim/nvim-lspconfig",
     dependencies = { "williamboman/mason-lspconfig.nvim" },
     config = function()
       local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup Mason LSP servers
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",  -- TypeScript language server (correct name)
          "html",
          "cssls",
          "jsonls",
        },
        handlers = {
          function(server_name)
            vim.lsp.config(server_name, {
              capabilities = capabilities,
            })
            vim.lsp.enable(server_name)
          end,
          -- Special configuration for specific servers
          lua_ls = function()
            vim.lsp.config("lua_ls", {
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
            })
            vim.lsp.enable("lua_ls")
          end,
        },
      })

       -- LSP keymaps (Neovim 0.11+ compatible)
       vim.api.nvim_create_autocmd("LspAttach", {
         group = vim.api.nvim_create_augroup("UserLspConfig", {}),
         callback = function(ev)
           local opts = { buffer = ev.buf }
           vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
           vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
           vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
           vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
           vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
           vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
           vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code actions" })
           vim.keymap.set("n", "<leader>fd", function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf, desc = "Format document" })

           -- Diagnostic keymaps
           vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show diagnostic error messages" })
           vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = ev.buf, desc = "Go to previous diagnostic" })
           vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to next diagnostic" })
         end,
       })
     end,
   },

  -- Mason (LSP server and tool manager)
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Install essential tools
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettierd", -- Fast prettier daemon
          "stylua", -- Lua formatter
          "black", -- Python formatter

          -- Linters
          "eslint_d", -- Fast ESLint daemon
          "stylelint", -- CSS linter
          "jsonlint", -- JSON linter
        },
        auto_update = true,
      })
    end,
  },

  -- Formatter (modern replacement for null-ls formatting)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false, -- Disable to avoid deprecation warnings
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        -- JavaScript/TypeScript/React
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },

        -- Web formats
        css = { "prettierd" },
        scss = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },

        -- Other languages
        lua = { "stylua" },
        python = { "black" },
      },
      formatters = {
        prettierd = {
          -- Use local prettierd if available
          command = function()
            local local_prettierd = vim.fn.fnamemodify("./node_modules/.bin/prettierd", ":p")
            if vim.fn.executable(local_prettierd) == 1 then
              return local_prettierd
            else
              return "prettierd"
            end
          end,
        },
      },
    },
  },

  -- Mini.animate (smooth animations - properly configured)
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = {
      -- Cursor path animation
      cursor = {
        enable = true,
        timing = function()
          return 150 -- Cursor animation duration in ms
        end,
        -- Use default path generator (shortest line path)
      },

      -- Scroll animation (disabled as requested)
      scroll = {
        enable = false,
      },

      -- Window resize animation
      resize = {
        enable = true,
        timing = function()
          return 100 -- Resize animation duration in ms
        end,
      },

      -- Window open/close animations
      open = {
        enable = true,
        timing = function()
          return 150 -- Window open animation duration
        end,
      },
      close = {
        enable = true,
        timing = function()
          return 150 -- Window close animation duration
        end,
      },
    },
  },

  -- Mini.indentscope (animated indent guides)
  {
    "echasnovski/mini.indentscope",
    event = "VeryLazy",
    opts = {
      symbol = "│", -- Vertical line for indent guides
      options = {
        try_as_border = true, -- Try to draw as border
      },
      draw = {
        delay = 50, -- Animation delay
        animation = function()
          return 10 -- Animation frames
        end,
      },
    },
  },

  -- Mini.cursorword (auto-highlight word under cursor)
  {
    "echasnovski/mini.cursorword",
    event = "VeryLazy",
    opts = {
      delay = 100, -- Delay in ms before highlighting
    },
  },

  -- Mini.trailspace (highlight and remove trailing spaces)
  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    opts = {}, -- Will highlight trailing spaces in red
  },

  -- Mini.bracketed (navigate with square brackets)
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    opts = {
      -- Enable various bracketed navigation
      buffer     = { suffix = 'b', options = {} },
      comment    = { suffix = 'c', options = {} },
      conflict   = { suffix = 'x', options = {} },
      diagnostic = { suffix = 'd', options = {} },
      file       = { suffix = 'f', options = {} },
      indent     = { suffix = 'i', options = {} },
      jump       = { suffix = 'j', options = {} },
      location   = { suffix = 'l', options = {} },
      oldfile    = { suffix = 'o', options = {} },
      quickfix   = { suffix = 'q', options = {} },
      treesitter = { suffix = 't', options = {} },
      undo       = { suffix = 'u', options = {} },
      window     = { suffix = 'w', options = {} },
      yank       = { suffix = 'y', options = {} },
    },
  },

  -- Linter (modern replacement for null-ls linting)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      lint.linters_by_ft = {
        -- JavaScript/TypeScript/React
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },

        -- Web styles
        css = { "stylelint" },
        scss = { "stylelint" },

        -- Data formats
        json = { "jsonlint" },

        -- Python
        python = { "pylint" },
      }

      -- Configure eslint_d to use local config
      lint.linters.eslint_d = {
        cmd = function()
          local local_eslint = vim.fn.fnamemodify("./node_modules/.bin/eslint_d", ":p")
          if vim.fn.executable(local_eslint) == 1 then
            return local_eslint
          else
            return "eslint_d" -- fallback to mason-installed
          end
        end,
      }

      -- Auto-run linters on events
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if file has been modified and is not too large
          if vim.fn.wordcount().bytes < 1000000 then -- Skip files larger than 1MB
            lint.try_lint()
          end
        end,
      })

      -- Manual lint keybinding
      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- Autocompletion (enhanced with snippets and multiple sources)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim", -- VSCode-like icons
      "L3MON4D3/LuaSnip", -- Ensure LuaSnip is loaded before cmp
    },
    config = function()
      local cmp = require("cmp")
      local ok_luasnip, luasnip = pcall(require, "luasnip")
      local ok_lspkind, lspkind = pcall(require, "lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif ok_luasnip and luasnip.expandable() then
                luasnip.expand()
              elseif ok_luasnip and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif ok_luasnip and luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp", priority = 1000 } },
          (ok_luasnip and { { name = "luasnip", priority = 750 } } or {}),
          { { name = "buffer", priority = 500 }, { name = "path", priority = 250 } }
        ),
        formatting = {
          format = ok_lspkind and lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }) or nil,
        },
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },
})

-- LSP keymaps (available when LSP attaches to buffers)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code actions" })
    vim.keymap.set("n", "<leader>fd", function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf, desc = "Format document" })
  end,
})

-- LSP servers are installed via :Mason
-- They will auto-attach when opening matching files
-- Manual configuration removed to avoid API compatibility issues

-- OpenCode Integration (run opencode commands from Neovim)
vim.api.nvim_create_user_command('OpenCode', function(opts)
  -- Run opencode with provided arguments
  local cmd = 'opencode ' .. (opts.args or '')
  vim.cmd('terminal ' .. cmd)
end, { nargs = '*' })

-- Keybindings for basic opencode operations
vim.keymap.set('n', '<leader>oc', ':OpenCode ', { desc = 'Run OpenCode command' })
vim.keymap.set('n', '<leader>oh', ':OpenCode --help<CR>', { desc = 'OpenCode help' })
vim.keymap.set('n', '<leader>ov', ':vsplit | terminal opencode<CR>', { desc = 'Open OpenCode in vertical split' })

-- Better terminal mode exit (double Esc instead of Ctrl+\ Ctrl+n)
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Note: Some plugins may show deprecation warnings for vim.lsp.buf_get_clients()
-- This is normal and will be fixed when plugins update to Neovim 0.11 APIs
-- The functionality still works correctly
