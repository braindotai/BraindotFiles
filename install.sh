#!/bin/bash

# Clone the BraindotFiles repository
echo "Initializing BraindotFiles..."

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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

case "$OS" in
    ubuntu)
        echo 'Updating your Ubuntu...'
        sudo apt-get update > /dev/null 2>&1
        sudo apt-get upgrade > /dev/null 2>&1
        ;;
    arch)
        echo 'Updating your Arch'
        sudo pacman -Syyuu
        ;;
    *)
        echo "Unsupported distribution. Please update your system manually..."
        ;;
esac
            


# Install git if not already installed``
if ! command_exists git; then
    echo "Installing git..."
    case "$OS" in
        ubuntu)
            sudo apt-get install -y git > /dev/null 2>&1
            ;;
        arch)
            sudo pacman -Sy --noconfirm git > /dev/null 2>&1
            ;;
        *)
            echo "Unsupported distribution. Please install git manually."
            exit 1
            ;;
    esac
fi

git clone https://github.com/braindotai/BraindotFiles ~/BraindotFiles > /dev/null 2>&1

# Install stow if not already installed``
if ! command_exists stow; then
    echo "Installing stow..."
    case "$OS" in
        ubuntu)
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

# Create the ~/.local/share/fonts directory if it doesn't exist
echo 'Instaling fonts...'
mkdir -p ~/.local/share/fonts
cp ~/BraindotFiles/fonts/*.ttf ~/.local/share/fonts/
fc-cache -f -v > /dev/null 2>&1
cd ~/BraindotFiles

bash zsh.sh
bash kitty.sh
bash python.sh
bash docker.sh

echo 'Installing...'
stow .

cd "$ORIGINAL_DIR"
echo "Welcome to 🧠 Braindotai"
