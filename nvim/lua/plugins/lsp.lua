return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff", "lua_ls", "texlab" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
          end,
        },
      })

      -- Global LSP Keymaps (Buffer local)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Action
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)       -- Show line diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)        -- Prev diagnostic
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)        -- Next diagnostic
        end,
      })
    end,
  },

  -- Formatting (Black for Python)
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      formatters_by_ft = {
        python = { "black" },
      },
    },
  },

  -- Autocompletion (CMP)
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },
}
