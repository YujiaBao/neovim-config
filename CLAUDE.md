# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A personal Neovim configuration using Lua, Lazy.nvim (plugin manager), and Mason (LSP/tool manager). The `nvim/` directory is symlinked to `~/.config/nvim`.

## Installation

```bash
./install.sh          # macOS: installs deps via Homebrew, sets up venv, creates symlink
./install_ubuntu.sh   # Ubuntu/Linux: installs deps via apt + GitHub releases, creates symlink
```

Both scripts install system tools (ripgrep, fd, lazygit, tree-sitter-cli), create a Python venv at `nvim/venv/` with pynvim/black, and symlink `nvim/` → `~/.config/nvim`. They also optionally symlink `.tmux.conf` → `~/.tmux.conf` (prompted during install).

## Architecture

```
nvim/
├── init.lua               # Entry point — only loads config.options, config.keymaps, config.lazy
├── lazy-lock.json         # Lazy.nvim lockfile — MUST be preserved
└── lua/
    ├── config/
    │   ├── options.lua    # vim.opt settings
    │   ├── keymaps.lua    # Global keymaps (leader = Space)
    │   └── lazy.lua       # Lazy.nvim bootstrap; scans lua/plugins/
    ├── plugins/
    │   ├── editor.lua     # Neo-tree, Telescope, Treesitter, Gitsigns, ToggleTerm
    │   ├── lsp.lua        # nvim-lspconfig, Mason, nvim-cmp, conform.nvim, lsp_signature
    │   └── ui.lua         # Gruvbox colorscheme, lualine statusline
    └── util/
        └── terminal.lua   # Persistent floating terminal tab logic
```

## Key Conventions

### Plugin Management
- All plugins live in `nvim/lua/plugins/*.lua`, each returning Lazy.nvim spec tables.
- Do not use packer or vim-plug syntax.
- To add a plugin: add to an existing category file or create a new `nvim/lua/plugins/<category>.lua`.

### Treesitter
- Must use `branch = "main"` (the rewrite version).
- Use `require("nvim-treesitter").install({...})` — do **not** use `require("nvim-treesitter.configs")` (deprecated).
- Folding: use `vim.treesitter.foldexpr()` (native).

### LSP / Completion
- Use native Neovim LSP + nvim-cmp. Do **not** assume coc.nvim.
- LSP capabilities must inject `cmp_nvim_lsp.default_capabilities()`.
- Formatting via conform.nvim (Python: ruff_fix → ruff_format → ruff_organize_imports, format on save).
- LSP keymaps are defined inside the `LspAttach` autocommand in `lsp.lua`.
- Servers installed via Mason `ensure_installed`: basedpyright, ruff, lua_ls, texlab.
- Python LSP uses `basedpyright` (not `pyright`). `on_new_config` creates a `.venv` symlink for uv projects and sets `venvPath`/`venv` so basedpyright treats it as a venv rather than source.
- `root_dir` for basedpyright prioritises `pyrightconfig.json`/`uv.lock` over `pyproject.toml` so multi-package repos anchor at the workspace root.

### Keymap Organization
- **Global keymaps**: `nvim/lua/config/keymaps.lua`
- **Plugin-specific keymaps**: `keys = { ... }` table inside the plugin spec in `nvim/lua/plugins/`
- **LSP keymaps**: `LspAttach` autocommand in `nvim/lua/plugins/lsp.lua`

### Terminal Management
- **Persistent floating terminal** (ToggleTerm ID 1): managed via `util/terminal.lua`, supports multiple tabs (`gn` = new tab, `gt`/`gT` = switch tabs).
- **Ephemeral split/tab terminals**: native `:term`, set `bufhidden = "wipe"`.
- All terminals must disable line numbers via the `TermOpen` autocommand.

### Python Provider
- Dedicated venv at `nvim/venv/` (gitignored).
- New Python tools should be installed via Mason rather than the venv.

## Do's and Don'ts

- **DO** preserve `lazy-lock.json`.
- **DO NOT** put large code blocks in `init.lua` — keep it minimal.
- **DO NOT** use `require("nvim-treesitter.configs")`.
- **DO NOT** assume coc.nvim — native LSP + CMP is used.
