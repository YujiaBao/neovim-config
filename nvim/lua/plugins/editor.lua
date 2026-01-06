return {
  -- File Tree (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<C-n>", ":Neotree filesystem reveal left toggle<CR>", desc = "Toggle Tree" },
    },
  },

  -- Fuzzy Finder (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep Text" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
  },

  -- Treesitter (Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "python", "markdown", "latex" },
        highlight = { enable = true },
      })
    end,
  },

  -- Git Integration
  { "lewis6991/gitsigns.nvim", config = true },

  -- Tmux Navigation
  { "christoomey/vim-tmux-navigator" },
}
