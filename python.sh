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

if ! command_exists python3.9; then
    echo "Installing python..."
    if [ "$OS" == "arch" ]; then
        # Arch Linux
        sudo pacman -Sy --noconfirm python39 python-pip
        pip3.9 install --upgrade pip

    elif [ "$OS" == "ubuntu" ]; then
        sudo apt install -y software-properties-common > /dev/null 2>&1
        sudo add-apt-repository ppa:deadsnakes/ppa > /dev/null 2>&1
        sudo apt update > /dev/null 2>&1
        sudo apt install -y python3.9 python3.9-venv python3.9-distutils > /dev/null 2>&1
        sudo wget https://bootstrap.pypa.io/get-pip.py > /dev/null 2>&1
        sudo python3.9 get-pip.py > /dev/null 2>&1
        sudo rm get-pip.py > /dev/null 2>&1
        pip3.9 install --upgrade pip > /dev/null 2>&1
    else
        echo "Unsupported distribution."
        exit 1
    fi
fi

# echo "Installing python packages..."
# pip3.9 install nvitop opencv-python matplotlib tqdm lightning ipython -q > /dev/null 2>&1
# pip3.9 install torch torchvision --index-url https://download.pytorch.org/whl/cu121 --no-cache-dir -q

# assets
# docker
# fonts
# git
# kitty
# python
# vscode
# zsh