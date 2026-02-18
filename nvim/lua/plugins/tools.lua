return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal

      local right_panel_win = nil
      local bottom_term_win = nil
      local current_right_app = nil
      local main_win = nil

      local function open_right_panel(app)
        if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
          vim.api.nvim_set_current_win(right_panel_win)
          return
        end
        
        vim.cmd("vsplit")
        vim.cmd("wincmd l")
        local total_width = vim.o.columns
        local right_width = math.floor(total_width * 0.38)
        vim.cmd("vertical resize " .. right_width)
        right_panel_win = vim.api.nvim_get_current_win()
        
        if app == "lazygit" then
          vim.cmd("terminal lazygit")
          current_right_app = "lazygit"
        else
          vim.cmd("terminal opencode")
          current_right_app = "opencode"
        end
        
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>lua close_right_panel()<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>gx", "<cmd>lua switch_right_panel()<CR>", { noremap = true, silent = true })
      end

      local function open_bottom_term()
        if bottom_term_win and vim.api.nvim_win_is_valid(bottom_term_win) then
          return
        end
        
        vim.cmd("split")
        vim.cmd("wincmd j")
        vim.cmd("resize 7")
        bottom_term_win = vim.api.nvim_get_current_win()
        vim.cmd("terminal " .. vim.o.shell)
        vim.cmd("startinsert!")
      end

      _G.toggle_right_panel = function(app)
        if not app then
          app = (current_right_app == "lazygit") and "opencode" or "lazygit"
        end
        
        if current_right_app == app and right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
          vim.api.nvim_win_close(right_panel_win, true)
          right_panel_win = nil
          current_right_app = nil
          return
        end
        
        if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
          vim.api.nvim_win_close(right_panel_win, true)
        end
        
        local save_main = main_win
        open_right_panel(app)
        main_win = save_main
      end

      _G.switch_right_panel = function()
        local new_app = (current_right_app == "lazygit") and "opencode" or "lazygit"
        toggle_right_panel(new_app)
      end

      _G.toggle_lazygit = function()
        toggle_right_panel("lazygit")
      end

      _G.toggle_opencode = function()
        toggle_right_panel("opencode")
      end

      _G.toggle_bottom_term = function()
        if bottom_term_win and vim.api.nvim_win_is_valid(bottom_term_win) then
          vim.api.nvim_win_close(bottom_term_win, true)
          bottom_term_win = nil
        else
          open_bottom_term()
        end
      end

      _G.open_dev_layout = function()
        if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) and 
           bottom_term_win and vim.api.nvim_win_is_valid(bottom_term_win) then
          vim.api.nvim_set_current_win(main_win or vim.api.nvim_get_current_win())
          return
        end
        
        main_win = vim.api.nvim_get_current_win()
        
        if not (right_panel_win and vim.api.nvim_win_is_valid(right_panel_win)) then
          open_right_panel("lazygit")
          vim.api.nvim_set_current_win(main_win)
        end
        
        if not (bottom_term_win and vim.api.nvim_win_is_valid(bottom_term_win)) then
          vim.cmd("split")
          vim.cmd("wincmd j")
          vim.cmd("resize 7")
          bottom_term_win = vim.api.nvim_get_current_win()
          vim.cmd("terminal " .. vim.o.shell)
          vim.cmd("startinsert!")
          vim.api.nvim_set_current_win(main_win)
        end
      end

      _G.close_right_panel = function()
        if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
          vim.api.nvim_win_close(right_panel_win, true)
          right_panel_win = nil
          current_right_app = nil
        end
      end

      _G.close_dev_layout = function()
        close_right_panel()
        if bottom_term_win and vim.api.nvim_win_is_valid(bottom_term_win) then
          vim.api.nvim_win_close(bottom_term_win, true)
          bottom_term_win = nil
        end
      end

      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = false,
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
      { "<leader>gl", "<cmd>lua toggle_lazygit()<CR>", desc = "Toggle lazygit in right panel" },
      { "<leader>go", "<cmd>lua toggle_opencode()<CR>", desc = "Toggle opencode in right panel" },
      { "<leader>gx", "<cmd>lua switch_right_panel()<CR>", desc = "Switch lazygit/opencode" },
      { "<leader>gt", "<cmd>lua toggle_bottom_term()<CR>", desc = "Toggle bottom terminal" },
      { "<leader>gL", "<cmd>lua open_dev_layout()<CR>", desc = "Open dev layout (editor | lazygit / terminal)" },
      { "<leader>gc", "<cmd>lua close_right_panel()<CR>", desc = "Close right panel" },
      { "<leader>gC", "<cmd>lua close_dev_layout()<CR>", desc = "Close all layout panels" },
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
