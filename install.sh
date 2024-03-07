#!/bin/bash

bash zsh.sh
bash kitty.sh
bash python.sh

# Store the current working directory
ORIGINAL_DIR=$(pwd)

# Install stow if not already installed
if ! command_exists stow; then
    echo "stow is not installed. Installing..."
    case "$OS" in
        ubuntu)
            sudo apt-get update > /dev/null 2>&1
            sudo apt-get install -y stow > /dev/null 2>&1
            ;;
        arch)
            sudo pacman -Sy --noconfirm stow > /dev/null 2>&1
            ;;
        *)
            echo "Unsupported distribution. Please install stow manually."
            exit 1
            ;;
    esac
fi

# Clone the BraindotFiles repository
echo "Setting up BraindotFiles..."
git clone https://github.com/braindotai/BraindotFiles ~/BraindotFiles > /dev/null 2>&1

# Create the ~/.local/share/fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Copy all .ttf fonts from the BraindotFiles repository to ~/.local/share/fonts
cp ~/BraindotFiles/fonts/*.ttf ~/.local/share/fonts/

# Rebuild the font cache
fc-cache -f -v > /dev/null 2>&1

# Change the current working directory to the BraindotFiles repository
cd ~/BraindotFiles

# Use stow to create symbolic links from the BraindotFiles repository
stow .

# Move back to the original directory
cd "$ORIGINAL_DIR"

echo "Welcome to Braindotai"
