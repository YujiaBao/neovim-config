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
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      require("mason").setup()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = { "basedpyright", "ruff", "lua_ls", "texlab" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
          ["basedpyright"] = function()
            require("lspconfig").basedpyright.setup({
              capabilities = capabilities,
              -- Prioritise workspace-root markers over per-package pyproject.toml
              -- so multi-package repos anchor at the correct root.
              root_dir = function(fname)
                local util = require("lspconfig.util")
                return util.root_pattern("pyrightconfig.json", "uv.lock")(fname)
                  or util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt")(fname)
              end,
              -- For uv projects the env may live outside .venv.
              -- Create/refresh a .venv symlink and point basedpyright at it via
              -- venvPath + venv so it treats it as a proper venv (not source).
              on_new_config = function(new_config, root)
                if vim.fn.filereadable(root .. "/uv.lock") == 1 then
                  local prefix = vim.fn.trim(vim.fn.system(
                    "cd " .. vim.fn.shellescape(root)
                    .. " && uv run python -c 'import sys; print(sys.prefix)' 2>/dev/null"
                  ))
                  if prefix ~= "" and vim.fn.isdirectory(prefix) == 1 then
                    vim.fn.system(
                      "ln -sfn " .. vim.fn.shellescape(prefix)
                      .. " " .. vim.fn.shellescape(root .. "/.venv")
                    )
                  end
                end
                if vim.fn.isdirectory(root .. "/.venv") == 1 then
                  new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, {
                    python = { venvPath = root, venv = ".venv" },
                  })
                end
              end,
            })
          end,
        },
      })

      -- Diagnostic Config
      vim.diagnostic.config({
        float = { border = "rounded" },
      })

      -- Global LSP Keymaps (Buffer local)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gs", function() vim.cmd("split"); vim.lsp.buf.definition() end, opts) -- Split horizontal
          vim.keymap.set("n", "gv", function() vim.cmd("vsplit"); vim.lsp.buf.definition() end, opts) -- Split vertical
          vim.keymap.set("n", "gt", function() vim.cmd("tab split"); vim.lsp.buf.definition() end, opts) -- New tab
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Action
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)       -- Show line diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)        -- Prev diagnostic
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)        -- Next diagnostic

          -- Attach lsp_signature for automatic signature help
          require("lsp_signature").on_attach({
            bind = true,
            handler_opts = { border = "rounded" },
          }, args.buf)
        end,
      })
    end,
  },

  -- Formatting (Ruff for Python)
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = { timeout_ms = 2500, lsp_fallback = true },
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
    },
  },

  -- Autocompletion (CMP)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
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
          { name = 'path' },
        }, {
          { name = 'buffer' },
        })
      })
    end,
  },
}
