return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal

      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "vertical",
        size = vim.o.columns * 0.4,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })

      local opencode_term = Terminal:new({
        cmd = "opencode",
        direction = "vertical",
        size = vim.o.columns * 0.4,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      local bottom_term = Terminal:new({
        cmd = vim.o.shell,
        direction = "horizontal",
        size = 15,
        on_open = function()
          vim.cmd("startinsert!")
        end,
      })

      _G.toggle_lazygit = function()
        lazygit:toggle()
      end

      _G.toggle_opencode = function()
        opencode_term:toggle()
      end

      _G.toggle_bottom_term = function()
        bottom_term:toggle()
      end

      _G.open_dev_layout = function()
        local current_win = vim.api.nvim_get_current_win()
        
        vim.cmd("vsplit")
        vim.cmd("wincmd l")
        vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.4))
        
        lazygit:open()
        
        vim.api.nvim_set_current_win(current_win)
        
        vim.cmd("split")
        vim.cmd("wincmd j")
        vim.cmd("resize 15")
        
        bottom_term:open()
        
        vim.api.nvim_set_current_win(current_win)
      end

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
          highlights = { border = "Normal", background = "Normal" },
        },
      })
    end,
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<leader>T", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
      { "<leader>gl", "<cmd>lua toggle_lazygit()<CR>", desc = "Toggle lazygit" },
      { "<leader>go", "<cmd>lua toggle_opencode()<CR>", desc = "Toggle opencode in terminal" },
      { "<leader>gt", "<cmd>lua toggle_bottom_term()<CR>", desc = "Toggle bottom terminal" },
      { "<leader>gL", "<cmd>lua open_dev_layout()<CR>", desc = "Open dev layout (editor | lazygit / terminal)" },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", '<cmd>lua require("spectre").open()<CR>', desc = "Search and replace" },
      { "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = "Search current word" },
      { "<leader>sf", '<cmd>lua require("spectre").open_file_search()<CR>', desc = "Search in current file" },
    },
  },

  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      })
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
      })
    end,
  },
}
