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
    # Install Python 3.9, pip3.9, and venv module
    if [ "$OS" == "arch" ]; then
        # Arch Linux
        sudo pacman -Sy --noconfirm python39 python-pip
        pip3.9 install --upgrade pip

    elif [ "$OS" == "ubuntu" ]; then
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository ppa:deadsnakes/ppa
        sudo apt-get update
        sudo apt-get install -y python3.9 python3.9-venv python3.9-distutils
        sudo wget https://bootstrap.pypa.io/get-pip.py
        sudo python3.9 get-pip.py
        sudo rm get-pip.py
        pip3.9 install --upgrade pip
    else
        echo "Unsupported distribution."
        exit 1
    fi
fi

echo "Installing python packages..."
pip3.9 install nvitop opencv-python matplotlib tqdm lightning ipython
pip3.9 install torch torchvision --index-url https://download.pytorch.org/whl/cu121 --no-cache-dir