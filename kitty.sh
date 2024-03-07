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

# Install Kitty terminal if not installed
if ! command_exists kitty; then
    echo "Installing kitty..."
    case "$OS" in
        ubuntu)
            curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin > /dev/null 2>&1

            ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
            # Place the kitty.desktop file somewhere it can be found by the OS
            cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
            # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
            cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
            # Update the paths to the kitty and its icon in the kitty.desktop file(s)
            sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
            sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
            ;;
        arch)
            sudo pacman -Sy --noconfirm kitty > /dev/null 2>&1
            ;;
        *)
            echo "Unsupported distribution. Please install stow manually."
            exit 1
            ;;
    esac
fi