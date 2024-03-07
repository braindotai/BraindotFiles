#!/bin/bash

# Determine the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else    
    echo "Unable to determine the distribution. Assuming Arch Linux."
    OS="arch"
fi

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

backup_existing_files() {
    local file
    for file in "$@"; do
        if [ -e "$file" ]; then
            mv "$file" "$file.bak"
            echo "Backed up existing file: $file to $file.bak"
        fi
    done
}

# Install zsh based on the distribution
if [ "$OS" == "ubuntu" ]; then
    if ! command_exists zsh; then
        echo "Installing Zsh..."
        sudo apt-get update > /dev/null 2>&1
        sudo apt-get install -y zsh > /dev/null 2>&1
        sudo chsh -s "$(command -v zsh)" "$USER"
    fi
elif [ "$OS" == "arch" ]; then
    if ! command_exists zsh; then
        echo "Installing Zsh..."
        sudo pacman -Sy --noconfirm zsh > /dev/null 2>&1
        sudo chsh -s "$(command -v zsh)" "$USER"
    fi
else
    echo "Unsupported distribution. Please install Zsh manually."
    exit 1
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
fi

# Backup existing files before installing Powerlevel10k theme and plugins
backup_existing_files "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.config/kitty"

# Install Powerlevel10k theme if not installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"  > /dev/null 2>&1
fi

# Install zsh-autosuggestions if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Installing terminal autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" > /dev/null 2>&1
fi

# Install zsh-syntax-highlighting if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing terminal syntax highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"  > /dev/null 2>&1
fi

# Install zsh-autocomplete if not installed
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete" ]; then
    echo "Installing terminal autocomplete..."
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete"  > /dev/null 2>&1
fi
