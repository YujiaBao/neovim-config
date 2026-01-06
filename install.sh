#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Neovim Setup for Mac..."

# 1. Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install Homebrew first."
    exit 1
fi

# 2. Install Dependencies
echo "📦 Installing System Dependencies..."
# ripgrep/fd are needed for Telescope; lazygit is a nice TUI for git
brew install neovim ripgrep fd lazygit

# 3. Install Nerd Font (Required for Icons)
echo "🔤 Installing Hack Nerd Font..."
brew install --cask font-hack-nerd-font

# 4. Create Python Virtual Environment for Neovim
# We do this to isolate Neovim's python dependencies from your system/projects
echo "🐍 Setting up Python Virtual Environment..."
NVIM_VENV="$HOME/.config/nvim/venv"

if [ ! -d "$NVIM_VENV" ]; then
    python3 -m venv "$NVIM_VENV"
    echo "   Virtual environment created at $NVIM_VENV"
fi

# Install Python provider tools inside the venv
source "$NVIM_VENV/bin/activate"
pip install --upgrade pip
pip install pynvim black
deactivate
echo "   Python tools (pynvim, black) installed."

# 5. Link Configuration
echo "🔗 Linking Configuration..."
TARGET_DIR="$HOME/.config/nvim"
SOURCE_DIR="$(pwd)/nvim"

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

echo "✅ Setup Complete!"
echo "   1. Open your terminal settings and change the font to 'Hack Nerd Font'."
echo "   2. Run 'nvim' to finish plugin installation."
