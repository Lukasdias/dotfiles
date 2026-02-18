return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal

      local right_panel_buf = nil
      local right_panel_win = nil
      local current_right_app = nil

      local function open_in_right_panel(cmd, app_name)
        if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
          vim.api.nvim_set_current_win(right_panel_win)
          vim.cmd("terminal " .. cmd)
          current_right_app = app_name
        else
          vim.cmd("vsplit")
          vim.cmd("wincmd l")
          local total_width = vim.o.columns
          local right_width = math.floor(total_width * 0.38)
          vim.cmd("vertical resize " .. right_width)
          right_panel_win = vim.api.nvim_get_current_win()
          vim.cmd("terminal " .. cmd)
          current_right_app = app_name
        end
        vim.cmd("startinsert!")
      end

      local lazygit_term = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "vertical",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<leader>gx", "<cmd>lua toggle_right_panel('opencode')<CR>", { noremap = true, silent = true, desc = "Switch to opencode" })
        end,
        on_close = function()
          right_panel_win = nil
          current_right_app = nil
        end,
      })

      local opencode_term = Terminal:new({
        cmd = "opencode",
        direction = "vertical",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<leader>gx", "<cmd>lua toggle_right_panel('lazygit')<CR>", { noremap = true, silent = true, desc = "Switch to lazygit" })
        end,
        on_close = function()
          right_panel_win = nil
          current_right_app = nil
        end,
      })

      local bottom_term = Terminal:new({
        cmd = vim.o.shell,
        direction = "horizontal",
        size = 7,
        on_open = function()
          vim.cmd("startinsert!")
        end,
      })

      _G.toggle_right_panel = function(app)
        if app == "lazygit" then
          if current_right_app == "lazygit" and right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
            vim.api.nvim_win_close(right_panel_win, true)
            right_panel_win = nil
            current_right_app = nil
          else
            if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
              vim.api.nvim_win_close(right_panel_win, true)
            end
            vim.cmd("vsplit")
            vim.cmd("wincmd l")
            local total_width = vim.o.columns
            local right_width = math.floor(total_width * 0.38)
            vim.cmd("vertical resize " .. right_width)
            right_panel_win = vim.api.nvim_get_current_win()
            vim.cmd("terminal lazygit")
            current_right_app = "lazygit"
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(0, "n", "<leader>gx", "<cmd>lua toggle_right_panel('opencode')<CR>", { noremap = true, silent = true })
          end
        elseif app == "opencode" then
          if current_right_app == "opencode" and right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
            vim.api.nvim_win_close(right_panel_win, true)
            right_panel_win = nil
            current_right_app = nil
          else
            if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
              vim.api.nvim_win_close(right_panel_win, true)
            end
            vim.cmd("vsplit")
            vim.cmd("wincmd l")
            local total_width = vim.o.columns
            local right_width = math.floor(total_width * 0.38)
            vim.cmd("vertical resize " .. right_width)
            right_panel_win = vim.api.nvim_get_current_win()
            vim.cmd("terminal opencode")
            current_right_app = "opencode"
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(0, "n", "<leader>gx", "<cmd>lua toggle_right_panel('lazygit')<CR>", { noremap = true, silent = true })
          end
        end
      end

      _G.toggle_lazygit = function()
        toggle_right_panel("lazygit")
      end

      _G.toggle_opencode = function()
        toggle_right_panel("opencode")
      end

      _G.toggle_bottom_term = function()
        bottom_term:toggle()
      end

      _G.open_dev_layout = function()
        local main_win = vim.api.nvim_get_current_win()
        
        vim.cmd("vsplit")
        vim.cmd("wincmd l")
        local total_width = vim.o.columns
        local right_width = math.floor(total_width * 0.38)
        vim.cmd("vertical resize " .. right_width)
        right_panel_win = vim.api.nvim_get_current_win()
        vim.cmd("terminal lazygit")
        current_right_app = "lazygit"
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>gx", "<cmd>lua toggle_right_panel('opencode')<CR>", { noremap = true, silent = true })
        
        vim.api.nvim_set_current_win(main_win)
        
        vim.cmd("split")
        vim.cmd("wincmd j")
        vim.cmd("resize 7")
        bottom_term:open()
        
        vim.api.nvim_set_current_win(main_win)
      end

      _G.close_right_panel = function()
        if right_panel_win and vim.api.nvim_win_is_valid(right_panel_win) then
          vim.api.nvim_win_close(right_panel_win, true)
          right_panel_win = nil
          current_right_app = nil
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
      { "<leader>gl", "<cmd>lua toggle_lazygit()<CR>", desc = "Toggle lazygit in right panel" },
      { "<leader>go", "<cmd>lua toggle_opencode()<CR>", desc = "Toggle opencode in right panel" },
      { "<leader>gx", "<cmd>lua toggle_right_panel(current_right_app == 'lazygit' and 'opencode' or 'lazygit')<CR>", desc = "Switch lazygit/opencode" },
      { "<leader>gt", "<cmd>lua toggle_bottom_term()<CR>", desc = "Toggle bottom terminal" },
      { "<leader>gL", "<cmd>lua open_dev_layout()<CR>", desc = "Open dev layout (editor | lazygit / terminal)" },
      { "<leader>gc", "<cmd>lua close_right_panel()<CR>", desc = "Close right panel" },
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
