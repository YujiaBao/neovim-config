# Yujia's Neovim Configuration

A modern, reproducible Neovim configuration built for Python/ML engineering.

## Architecture
* **Config:** Native Lua (`init.lua` + modules)
* **Manager:** [Lazy.nvim](https://github.com/folke/lazy.nvim)
* **LSP:** Native LSP + Mason (Pyright, Texlab)
* **Formatting:** Conform (Ruff)
* **Treesitter:** Main Branch (Native Folding)
* **Theme:** Gruvbox

> **For AI Agents:** Please refer to [AGENT_GUIDE.md](./AGENT_GUIDE.md) for structural details and conventions.

## Installation (Mac)

1. **Clone the repo:**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/neovim-config.git](https://github.com/YOUR_USERNAME/neovim-config.git) ~/neovim-config
   cd ~/neovim-config

```

2. **Run setup:**

This script installs Neovim, fonts, ripgrep, tree-sitter-cli, creates a Python virtualenv, and symlinks the config.

```bash

./install.sh

```


3. **Post-Install:**
* **Important:** Open Terminal/iTerm settings and set font to **"Hack Nerd Font"**.
* Run `nvim` (it will install plugins automatically).
* Run `:Mason` to verify language servers are installed.



## Keymaps

| Key | Action |
| --- | --- |
| `<Space>` | Leader Key |
| `<Space>ff` | Find Files |
| `<Space>fg` | Live Grep |
| `<Ctrl-n>` | Toggle File Tree |
| `gd` | Go to Definition |
| `K` | Hover Documentation |
| `gl` | Show Line Diagnostics |
| `[d` / `]d` | Previous / Next Diagnostic |
| `<Space>w` | Fast Save |

### Telescope Navigation (in search window)
| Key | Action |
| --- | --- |
| `<Ctrl-j>` | Next Result |
| `<Ctrl-k>` | Previous Result |
| `<Ctrl-l>` | Scroll Preview Down |
| `<Ctrl-h>` | Scroll Preview Up |

### Terminal (ToggleTerm)
| Key | Action |
| --- | --- |
| `'` | Toggle Terminal 1 (Float) |
| `<Space>tt` | Tab Terminal 1 |
| `<Space>ts` | Horizontal Split Terminal 1 |
| `<Space>tv` | Vertical Split Terminal 1 |
| `<Space>tf` | Float Terminal 1 |
| `<Space>[N]tt` | Tab Terminal N (N=1,2,3) |
| `<Space>[N]ts` | Horizontal Split Terminal N |
| `<Space>[N]tv` | Vertical Split Terminal N |
| `<Space>[N]tf` | Float Terminal N |
| **Inside Terminal** | |
| `<Esc>` or `jk` | Enter Normal Mode |
| `<Ctrl-h/j/k/l>` | Window Navigation |

### Code Folding (Native)
| Key | Action |
| --- | --- |
| `zc` | Close Fold |
| `zo` | Open Fold |
| `zR` | Open All Folds |
| `zM` | Close All Folds |
