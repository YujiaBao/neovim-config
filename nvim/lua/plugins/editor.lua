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
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "vim", "python", "markdown", "latex", "bash" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Git Integration
  { "lewis6991/gitsigns.nvim", config = true },

  -- Tmux Navigation
  { "christoomey/vim-tmux-navigator" },
}
