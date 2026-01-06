return {
  -- Gruvbox Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark" -- Ensure dark mode
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "gruvbox" } },
  },
}
