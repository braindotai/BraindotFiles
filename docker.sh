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

if ! command_exists docker; then
    echo "Installing docker..."
    if [ "$OS" == "arch" ]; then
        # Arch Linux
        sudo pacman -Sy --noconfirm docker
        pip3.9 install --upgrade pip

    elif [ "$OS" == "ubuntu" ]; then
        # Add Docker's official GPG key:
        sudo apt-get install ca-certificates curl > /dev/null 2>&1
        sudo install -m 0755 -d /etc/apt/keyrings > /dev/null 2>&1
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc > /dev/null 2>&1
        sudo chmod a+r /etc/apt/keyrings/docker.asc > /dev/null 2>&1

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update > /dev/null 2>&1
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
    else
        echo "Unsupported distribution."
        exit 1
    fi
fi
