#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install zsh if not installed
if ! command_exists zsh; then
    sudo apt-get update
    sudo apt-get install -y zsh
    chsh -s $(which zsh)
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
fi

# Install Powerlevel10k theme if not installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh-autosuggestions if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install zsh-autocomplete if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete" ]; then
    git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
fi

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
fc-cache -f -v > /dev/null

# Change the current working directory to the BraindotFiles repository
cd ~/BraindotFiles

# Use stow to create symbolic links from the BraindotFiles repository
stow .

# Move back to the original directory
cd "$ORIGINAL_DIR"
