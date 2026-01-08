# Agent Guide for Neovim Configuration

This document is intended for AI agents (Gemini, ChatGPT, etc.) to understand the structure and conventions of this Neovim configuration repository.

## Project Overview

This is a personal Neovim configuration based on:
-   **Neovim** (>= 0.9.0)
-   **Lua** for all configuration.
-   **Lazy.nvim** as the plugin manager.
-   **Mason** for managing external tools (LSPs, Formatters).

## Directory Structure

```text
/
├── install.sh          # Setup script (Mac specific): Installs deps, venv, symlinks.
├── update.sh           # Maintenance script: Updates venv tools, fixes symlinks.
├── .gitignore          # Git ignore rules (ignores nvim/venv).
├── README.md           # User facing documentation.
└── nvim/               # The actual configuration directory (symlinked to ~/.config/nvim).
    ├── init.lua        # Entry point. Loads 'config' and 'plugins'.
    ├── lazy-lock.json  # Lockfile for Lazy.nvim plugins. KEEP THIS.
    ├── venv/           # (Ignored) Python virtualenv for pynvim/black provider.
    └── lua/
        ├── config/     # Core Neovim settings (no plugins).
        │   ├── keymaps.lua  # Global keymaps.
        │   ├── lazy.lua     # Lazy.nvim bootstrap & setup.
        │   └── options.lua  # vim.opt settings (tabs, numbers, etc).
        └── plugins/    # Plugin specs (returned as Lua tables).
            ├── editor.lua   # Telescope, Neo-tree, Treesitter.
            ├── lsp.lua      # LSPConfig, Mason, CMP, Conform, Signature.
            └── ui.lua       # Colorscheme, Lualine.
```

## Key Conventions

1.  **Plugin Management**:
    *   All plugins are defined in `nvim/lua/plugins/*.lua`.
    *   Each file returns a table (or list of tables) conforming to Lazy.nvim specs.
    *   **Do not** use `packer` or `vim-plug` syntax.

2.  **LSP & Autocomplete**:
    *   **LSP Config**: Managed in `nvim/lua/plugins/lsp.lua`.
    *   **Servers**: Installed via Mason (`ensure_installed` in `lsp.lua`).
    *   **Capabilities**: Must inject `cmp_nvim_lsp` capabilities into `lspconfig`.
    *   **Formatting**: Managed by `conform.nvim` in `lsp.lua` (e.g., Black for Python).

5.  **Treesitter Configuration**:
    *   **Branch**: Must use `branch = "main"` (the rewrite version).
    *   **Setup**: Use `require("nvim-treesitter").install({...})` for parsers.
    *   **Do not use**: `require("nvim-treesitter.configs")` (deprecated).
    *   **Folding**: Use `vim.treesitter.foldexpr()` (native).

3.  **Keymaps**:
    *   **Global**: Put in `nvim/lua/config/keymaps.lua`.
    *   **Plugin-specific**: Put in the `keys = { ... }` table within the plugin's spec in `nvim/lua/plugins/`.
    *   **LSP-specific**: Defined in the `LspAttach` autocommand in `nvim/lua/plugins/lsp.lua`.

4.  **Python Provider**:
    *   The configuration relies on a dedicated virtualenv at `nvim/venv`.
    *   When adding Python tools (linters/formatters), consider if they should be in the venv or installed via Mason (Mason is preferred).

5.  **Terminal Management**:
    *   **Persistent**: Use ToggleTerm (ID 1) for the floating terminal.
    *   **One-off**: Use native `:term` for splits and tabs.
    *   **Cleanup**: Set `bufhidden = "wipe"` for native terminals.
    *   **UI**: All terminals should have numbers disabled via the `TermOpen` autocommand.

## Common Tasks

*   **Adding a Plugin**: Create a new file in `nvim/lua/plugins/` (e.g., `coding.lua`) or add to an existing category file.
*   **Changing Options**: Edit `nvim/lua/config/options.lua`.
*   **Fixing LSP**: Check `nvim/lua/plugins/lsp.lua`.

## Do's and Don'ts

*   **DO** preserve `lazy-lock.json`.
*   **DO NOT** put large blocks of code in `init.lua`. Keep it minimal.
*   **DO NOT** assume `coc.nvim`. We use native LSP + CMP.
