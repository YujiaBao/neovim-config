#!/bin/bash
set -e

echo "🔄 Updating Neovim Config Environment..."

# 1. Update Python Tools
NVIM_VENV="$HOME/.config/nvim/venv"
if [ -d "$NVIM_VENV" ]; then
    echo "🐍 Updating Python tools in venv..."
    source "$NVIM_VENV/bin/activate"
    pip install --upgrade pip pynvim black
    deactivate
else
    echo "⚠️  Python venv not found at $NVIM_VENV. Run install.sh first if you need the python provider."
fi

# 2. Verify/Relink Configuration
TARGET_DIR="$HOME/.config/nvim"
SOURCE_DIR="$(pwd)/nvim"

# If the symlink points to the wrong place or doesn't exist, fix it.
if [ -L "$TARGET_DIR" ]; then
    CURRENT_LINK=$(readlink "$TARGET_DIR")
    if [ "$CURRENT_LINK" != "$SOURCE_DIR" ]; then
         echo "🔗 Fixing symlink: $SOURCE_DIR -> $TARGET_DIR"
         rm "$TARGET_DIR"
         ln -s "$SOURCE_DIR" "$TARGET_DIR"
    else
         echo "✅ Symlink is already correct."
    fi
else
    echo "🔗 Creating symlink..."
    # Backup if it's a real directory
    if [ -d "$TARGET_DIR" ]; then 
        echo "   Backing up existing directory to ${TARGET_DIR}.backup"
        mv "$TARGET_DIR" "${TARGET_DIR}.backup"
    fi
    ln -s "$SOURCE_DIR" "$TARGET_DIR"
fi

echo "✅ Update Complete!"
