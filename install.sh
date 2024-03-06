#!/bin/bash

# Store the current working directory
ORIGINAL_DIR=$(pwd)

# Determine the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Unable to determine the distribution. Assuming Arch Linux."
    OS="arch"
fi

# Install stow if not already installed
if ! command -v stow &> /dev/null; then
    echo "stow is not installed. Installing..."
    case "$OS" in
        ubuntu)
            sudo apt-get update
            sudo apt-get install -y stow
            ;;
        arch)
            sudo pacman -Sy --noconfirm stow
            ;;
        *)
            echo "Unsupported distribution. Please install stow manually."
            exit 1
            ;;
    esac
fi

# Clone the BraindotFiles repository
git clone https://github.com/braindotai/BraindotFiles ~/BraindotFiles

# Create the ~/.local/share/fonts directory if it doesn't exist
mkdir -p ~/.local/share/fonts

# Copy all .ttf fonts from the BraindotFiles repository to ~/.local/share/fonts
cp ~/BraindotFiles/fonts/*.ttf ~/.local/share/fonts/

# Rebuild the font cache
fc-cache -f -v

# Change the current working directory to the BraindotFiles repository
cd ~/BraindotFiles

# Use stow to create symbolic links from the BraindotFiles repository
stow .

# Move back to the original directory
cd "$ORIGINAL_DIR"
