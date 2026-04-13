#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Neovim Setup for Ubuntu/Linux..."

# 1. Install system dependencies via apt
echo "📦 Installing System Dependencies..."
sudo apt-get update -qq
sudo apt-get install -y \
    curl \
    wget \
    git \
    gcc \
    unzip \
    ripgrep \
    fd-find \
    python3 \
    python3-venv \
    python3-pip \
    xclip

# fd is packaged as 'fdfind' on Ubuntu; create a local 'fd' symlink for Telescope
if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    echo "   Created 'fd' symlink at ~/.local/bin/fd"
    echo "   Ensure ~/.local/bin is in your PATH (add to ~/.bashrc or ~/.zshrc)."
fi

# 2. Install Neovim (latest stable from GitHub releases)
echo "📝 Installing Neovim..."
NVIM_LATEST=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" \
    | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
NVIM_CURRENT=""
if command -v nvim &> /dev/null; then
    NVIM_CURRENT="v$(nvim --version | head -1 | sed -E 's/NVIM v//')"
fi

if [ "$NVIM_CURRENT" != "$NVIM_LATEST" ]; then
    echo "   Upgrading Neovim: ${NVIM_CURRENT:-not installed} -> $NVIM_LATEST"
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)  NVIM_ARCH="nvim-linux-x86_64" ;;
        aarch64) NVIM_ARCH="nvim-linux-arm64" ;;
        *)       echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
    esac
    NVIM_TMP=$(mktemp -d)
    curl -L "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ARCH}.tar.gz" \
        -o "$NVIM_TMP/nvim.tar.gz"
    tar -xzf "$NVIM_TMP/nvim.tar.gz" -C "$NVIM_TMP"
    sudo rm -rf /opt/nvim
    sudo mv "$NVIM_TMP/$NVIM_ARCH" /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm -rf "$NVIM_TMP"
    echo "   Neovim $NVIM_LATEST installed to /opt/nvim"
else
    echo "   Neovim already up to date: $NVIM_CURRENT"
fi

# 3. Install lazygit (latest from GitHub releases)
echo "🦥 Installing lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    LAZYGIT_TMP=$(mktemp -d)
    curl -L "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
        -o "$LAZYGIT_TMP/lazygit.tar.gz"
    tar -xzf "$LAZYGIT_TMP/lazygit.tar.gz" -C "$LAZYGIT_TMP" lazygit
    sudo install "$LAZYGIT_TMP/lazygit" /usr/local/bin/lazygit
    rm -rf "$LAZYGIT_TMP"
    echo "   lazygit installed."
else
    echo "   lazygit already installed."
fi

# 4. Install tree-sitter-cli (required for Treesitter parser compilation)
echo "🌲 Installing tree-sitter-cli..."
if ! command -v tree-sitter &> /dev/null; then
    if command -v npm &> /dev/null; then
        npm install -g tree-sitter-cli
    elif command -v cargo &> /dev/null; then
        cargo install tree-sitter-cli
    else
        echo "⚠️  Neither npm nor cargo found. tree-sitter-cli was not installed."
        echo "   Treesitter parsers may fail to compile. To fix, install Node.js and run:"
        echo "   npm install -g tree-sitter-cli"
    fi
else
    echo "   tree-sitter-cli already installed."
fi

# 5. Install Hack Nerd Font
echo "🔤 Installing Hack Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts/HackNerdFont"
if [ ! -d "$FONT_DIR" ] || [ -z "$(ls -A "$FONT_DIR" 2>/dev/null)" ]; then
    mkdir -p "$FONT_DIR"
    FONT_TMP=$(mktemp -d)
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip" \
        -o "$FONT_TMP/Hack.zip"
    unzip -o "$FONT_TMP/Hack.zip" -d "$FONT_DIR" > /dev/null
    rm -rf "$FONT_TMP"
    fc-cache -f "$HOME/.local/share/fonts"
    echo "   Hack Nerd Font installed and font cache updated."
else
    echo "   Hack Nerd Font already installed."
fi

# 6. Create Python Virtual Environment for Neovim
# We do this to isolate Neovim's python dependencies from your system/projects
echo "🐍 Setting up Python Virtual Environment..."
NVIM_VENV="$HOME/.config/nvim/venv"

if [ ! -d "$NVIM_VENV" ]; then
    python3 -m venv "$NVIM_VENV"
    echo "   Virtual environment created at $NVIM_VENV"
fi

# Install Python provider tools inside the venv
source "$NVIM_VENV/bin/activate"
pip install --upgrade pip -q
pip install pynvim black -q
deactivate
echo "   Python tools (pynvim, black) installed."

# 7. Link Configuration
echo "🔗 Linking Configuration..."
TARGET_DIR="$HOME/.config/nvim"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/nvim"

# Backup existing config if it exists
if [ -d "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
    echo "   Backing up existing nvim config to ${TARGET_DIR}.backup"
    mv "$TARGET_DIR" "${TARGET_DIR}.backup"
fi

# Create symlink
if [ -L "$TARGET_DIR" ]; then
    echo "   Symlink already exists, updating..."
    rm "$TARGET_DIR"
fi
ln -s "$SOURCE_DIR" "$TARGET_DIR"
echo "   Symlink created: $SOURCE_DIR -> $TARGET_DIR"

# 8. Link tmux configuration (optional)
echo ""
read -r -p "🔧 Link .tmux.conf to ~/.tmux.conf? [y/N] " link_tmux || true
if [[ "$link_tmux" =~ ^[Yy]$ ]]; then
    TMUX_SOURCE="$(cd "$(dirname "$0")" && pwd)/.tmux.conf"
    TMUX_TARGET="$HOME/.tmux.conf"
    if [ -f "$TMUX_TARGET" ] && [ ! -L "$TMUX_TARGET" ]; then
        echo "   Backing up existing tmux config to ${TMUX_TARGET}.backup"
        mv "$TMUX_TARGET" "${TMUX_TARGET}.backup"
    fi
    if [ -L "$TMUX_TARGET" ]; then
        rm "$TMUX_TARGET"
    fi
    ln -s "$TMUX_SOURCE" "$TMUX_TARGET"
    echo "   Symlink created: $TMUX_SOURCE -> $TMUX_TARGET"
    echo "   Reload inside tmux with: prefix + r"
else
    echo "   Skipped tmux config."
fi

echo ""
echo "✅ Setup Complete!"
echo "   1. Open your terminal settings and change the font to 'Hack Nerd Font'."
echo "   2. Ensure ~/.local/bin is in your PATH for the 'fd' command."
echo "   3. Run 'nvim' to finish plugin installation."
