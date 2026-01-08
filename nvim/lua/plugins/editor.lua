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

      -- Custom Folding for Python (Show Signatures)
      -- This overrides the default query to fold the 'block' (body) instead of the definition.
      local python_folds = [[
        (function_definition body: (block) @fold)
        (class_definition body: (block) @fold)
        (while_statement body: (block) @fold)
        (for_statement body: (block) @fold)
        (if_statement consequence: (block) @fold alternative: (block)? @fold)
        (with_statement body: (block) @fold)
        (try_statement body: (block) @fold)
        [(import_statement) (import_from_statement)]+ @fold
      ]]
      vim.treesitter.query.set("python", "folds", python_folds)
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
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      persist_mode = false,
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
      -- Persistent Floating Terminal (ToggleTerm ID 1)
      { "'", function() require("toggleterm").toggle(1, nil, nil, "float") end, desc = "Floating Terminal" },
      { "<C-'>", function() require("toggleterm").toggle(1, nil, nil, "float") end, mode = { "n", "t" }, desc = "Floating Terminal" },

      -- Non-persistent Split Terminals (Native Neovim terminals)
      { "<leader>ts", function()
        vim.cmd("split | term")
        vim.cmd("resize 10")
        vim.opt_local.bufhidden = "wipe"
        vim.cmd("startinsert")
      end, desc = "Horizontal Terminal" },

      { "<leader>tv", function()
        vim.cmd("vsplit | term")
        vim.cmd("vertical resize 80")
        vim.opt_local.bufhidden = "wipe"
        vim.cmd("startinsert")
      end, desc = "Vertical Terminal" },

      { "<leader>tt", function()
        vim.cmd("tabnew | term")
        vim.opt_local.bufhidden = "wipe"
        vim.cmd("startinsert")
      end, desc = "Tab Terminal" },
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

        -- Terminal UI defaults
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end

      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
  },
}
