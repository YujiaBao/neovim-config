# 🚀 Optimized Neovim Configuration for Python & AI Workflows

Welcome to a professional Neovim setup designed for high-velocity Python development and modern LLM-integrated workflows. This configuration is built to be fast, stable, and intuitive for those transitioning from IDEs or traditional Vim.

---

## 🛠 Installation & Setup

### 1. Prerequisite (Mac)
Ensure you have Homebrew installed. Then, simply run the installation script:
```bash
./install.sh
```
This script handles system dependencies (`ripgrep`, `fd`, `lazygit`), sets up a dedicated Python virtual environment for Neovim, and installs the required Nerd Font.

### 2. Post-Installation
1.  **Change Font:** Set your terminal font to **"Hack Nerd Font"** to ensure all icons display correctly.
2.  **Initialize Plugins:** Open Neovim by typing `nvim`. It will automatically download and install all plugins.

---

## ⌨️ A Note on the "Leader" Key
Most shortcuts in this config use a "Leader" key as a prefix. By default, the **Leader key is set to `Space`**.
*   When you see `<leader>ff`, it means press `Space`, then `f`, then `f`.
*   You can find or change this setting in `nvim/lua/config/options.lua`.

---

## 🔍 Powerful Fuzzy Finding (Telescope)
One of the most powerful features of this setup is the ability to find anything in your project instantly using a floating fuzzy finder.

*   **Find Files:** Press `;` or `<leader>ff` to search for files by name. It’s fast, even in massive repositories.
*   **Live Grep:** Press `<leader>fg` to search for specific code or text *inside* every file in your project.
*   **Buffer Search:** Press `<leader>fb` to see a list of your currently open files and jump between them.

**Pro Tip:** Inside the fuzzy finder window, use `<Ctrl-j/k>` to navigate the list and `<Enter>` to open the file.

---

## 🐍 Daily Python Workflow

This config is tuned for Python developers, featuring high-performance LSP (Language Server Protocol) integration and deep syntax understanding.

### Coding with Precision
*   **Auto-completion:** As you type, suggestions appear automatically. Press `<Tab>` to navigate suggestions and `<Enter>` to confirm.
*   **Signatures & Docs:** 
    *   While typing a function, a signature popup appears automatically.
    *   Hover over any symbol and press `K` to see its documentation.
*   **Formatting:** Your code is automatically formatted on save using **Ruff**, ensuring PEP8 compliance without manual effort.

### Navigation & Tracing
*   **Jump to Definition:** Press `gd` to go to a definition. Want it in a split? Use `gs` (horizontal) or `gv` (vertical).
*   **Handling Errors/Diagnostics:**
    *   `gl`: Show the full error message for the current line in a floating window.
    *   `]d` / `[d`: Quickly jump to the next or previous error/warning in the file.
*   **Rename:** Press `<leader>rn` to rename a variable or function across your entire project.

---

## 🖥️ The Command Center (Terminals)

A key feature of this config is the separation between **Ephemeral** and **Persistent** terminals.

### 1. Persistent Terminal (AI & Tools)
Triggered with `'` or `<Ctrl-'>`, this floating terminal persists even if you switch files or close the window. It is perfect for running **Gemini CLI**, **Claude Code**, or long-running monitoring tasks.
*   `'` or `<Ctrl-'>`: Toggle the persistent terminal.
*   `<leader>tn`: Create a **new tab** within the persistent terminal session.
*   `gt` / `gT`: Switch between terminal tabs.
*   Type `exit` inside a tab to close it permanently.

### 2. Ephemeral Terminals (Development)
For quick commands related to your current split, use these standard split terminals. These are "wipe-on-exit" and tied to your layout.
*   `<leader>ts`: Open terminal in a **horizontal** split.
*   `<leader>tv`: Open terminal in a **vertical** split.
*   `<leader>tt`: Open terminal in a **new tab**.

---

## 📂 Project Management

### File Tree (Neo-tree)
*   `<Ctrl-n>`: Toggle the file explorer.
*   **Inside the tree:**
    *   `v`: Open file in a vertical split.
    *   `s`: Open file in a horizontal split.
    *   `a`: Create a new file or directory.
    *   `d`: Delete a file.

### Fuzzy Finder (Telescope)
*   `;` or `<leader>ff`: Find files by name.
*   `<leader>fg`: "Live Grep" – find text across all files in your project.
*   `<leader>fb`: Search through currently open buffers.

---

## 🧩 Managing Plugins

We use **Lazy.nvim** for lightning-fast plugin management.
*   **Update Plugins:** Press `<leader>l` to open the Lazy dashboard. Here you can press `U` to check for updates and `S` to sync.
*   **LSP/Linters:** Press `:Mason` to manage Language Servers, Linters, and Formatters (like Pyright or Ruff).

### Code Folding (Treesitter-powered)
Manage large files easily by folding code blocks.
*   `z1`, `z2`, `z3`: Show level 1 (Classes), level 2 (Methods), or level 3.
*   `z0`: Close all folds.
*   `zO` / `zC`: Open/Close all folds.

---

## ⌨️ Core Keymap Summary

| Key | Action |
|-----|--------|
| `<leader>w` | Save File |
| `<leader>q` | Quit |
| `<C-n>` | Toggle File Tree |
| `;` | Find Files |
| `'` | Toggle Persistent Terminal |
| `gd` | Go to Definition |
| `K` | View Documentation |
| `gl` | Show Line Diagnostics |
| `]d` / `[d` | Next/Prev Diagnostic |
| `z1` / `z2` | Fold Level 1 (Classes) / 2 (Methods) |
| `<leader>ca` | Code Action (Fix-it) |

> **Pro Tip:** Use `<Ctrl-h/j/k/l>` to navigate seamlessly between Neovim splits and your terminal panes.
