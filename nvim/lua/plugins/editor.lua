return {
  -- File Tree (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<C-n>", ":Neotree filesystem reveal left toggle<CR>", desc = "Toggle Tree" },
    },
    opts = {
      window = {
        mappings = {
          ["v"] = "open_vsplit",
          ["s"] = "open_split",
        },
      },
    },
  },

  -- Fuzzy Finder (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { ";", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep Text" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          preview = {
            treesitter = false,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-l>"] = actions.preview_scrolling_down,
              ["<C-h>"] = actions.preview_scrolling_up,
              ["<C-v>"] = actions.file_vsplit,
              ["<C-s>"] = actions.file_split,
            },
            n = {
              ["v"] = actions.file_vsplit,
              ["s"] = actions.file_split,
              ["<C-v>"] = actions.file_vsplit,
              ["<C-s>"] = actions.file_split,
            },
          },
        },
      })
    end,
  },

  -- Treesitter (Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- The new nvim-treesitter (main branch) uses .install() instead of configs.setup()
      require("nvim-treesitter").setup({})
      require("nvim-treesitter").install({ 
        "c", "lua", "vim", "python", "markdown", "latex", "bash" 
      })
    end,
  },

  -- Git Integration
  { "lewis6991/gitsigns.nvim", config = true },

  -- Tmux Navigation
  { "christoomey/vim-tmux-navigator" },

  -- Terminal Integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[']],
      hide_numbers = true,
      shade_filetypes = {},
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
      on_open = function(term)
        vim.cmd("startinsert!")
        if term.direction == "float" then
          local config = vim.api.nvim_win_get_config(term.window)
          config.title = " Terminal " .. term.id .. " "
          config.title_pos = "center"
          vim.api.nvim_win_set_config(term.window, config)
        end
      end,
    },
    keys = {
      { "'", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },

      -- Terminal 1 (Default)
      { "<leader>tt", "<cmd>1ToggleTerm direction=tab<cr>", desc = "Tab Terminal 1" },
      { "<leader>ts", "<cmd>1ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal 1" },
      { "<leader>tv", "<cmd>1ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal 1" },
      { "<leader>tf", "<cmd>1ToggleTerm direction=float<cr>", desc = "Float Terminal 1" },

      -- Terminal 1 (Explicit)
      { "<leader>1tt", "<cmd>1ToggleTerm direction=tab<cr>", desc = "Tab Terminal 1" },
      { "<leader>1ts", "<cmd>1ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal 1" },
      { "<leader>1tv", "<cmd>1ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal 1" },
      { "<leader>1tf", "<cmd>1ToggleTerm direction=float<cr>", desc = "Float Terminal 1" },

      -- Terminal 2
      { "<leader>2tt", "<cmd>2ToggleTerm direction=tab<cr>", desc = "Tab Terminal 2" },
      { "<leader>2ts", "<cmd>2ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal 2" },
      { "<leader>2tv", "<cmd>2ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal 2" },
      { "<leader>2tf", "<cmd>2ToggleTerm direction=float<cr>", desc = "Float Terminal 2" },

      -- Terminal 3
      { "<leader>3tt", "<cmd>3ToggleTerm direction=tab<cr>", desc = "Tab Terminal 3" },
      { "<leader>3ts", "<cmd>3ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal 3" },
      { "<leader>3tv", "<cmd>3ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal 3" },
      { "<leader>3tf", "<cmd>3ToggleTerm direction=float<cr>", desc = "Float Terminal 3" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      function _G.set_terminal_keymaps()
        local options = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], options)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], options)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], options)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], options)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], options)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], options)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], options)
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
  },
}
