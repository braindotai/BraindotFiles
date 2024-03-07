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

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install stow if not already installed``
if ! command_exists git; then
    echo "git is not installed. Installing..."
    case "$OS" in
        ubuntu)
            sudo apt-get update > /dev/null 2>&1
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

# Clone the BraindotFiles repository
echo "Initializing BraindotFiles..."
git clone https://github.com/braindotai/BraindotFiles ~/BraindotFiles > /dev/null 2>&1



# Install stow if not already installed``
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

# Create the ~/.local/share/fonts directory if it doesn't exist
echo 'Instaling fonts...'
mkdir -p ~/.local/share/fonts
cp ~/BraindotFiles/fonts/*.ttf ~/.local/share/fonts/
fc-cache -f -v > /dev/null 2>&1
cd ~/BraindotFiles

echo 'Installing...'
stow .

cd "$ORIGINAL_DIR"
echo "Welcome to Braindotai"
