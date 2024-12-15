#!/bin/bash

set -e

# Variables
NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_NVIM_DIR="$(pwd)/nvim"

# Step 1: Install Neovim
install_neovim() {
    echo "Installing Neovim..."
    if command -v apt > /dev/null 2>&1; then
        sudo apt update && sudo apt install -y neovim
    elif command -v dnf > /dev/null 2>&1; then
        sudo dnf install -y neovim
    elif command -v pacman > /dev/null 2>&1; then
        sudo pacman -Syu --noconfirm neovim
    else
        echo "Unsupported package manager. Install Neovim manually."
        exit 1
    fi
}

# Step 2: Set up configuration
setup_config() {
    echo "Setting up Neovim configuration..."
    mkdir -p "$NVIM_CONFIG_DIR"
    ln -sf "$REPO_NVIM_DIR"/* "$NVIM_CONFIG_DIR/"
}

# Step 3: Install Plugins
install_plugins() {
    echo "Installing Neovim plugins..."
    nvim --headless +PackerSync +qa
}

install_dependencies() {
    echo "Installing optional dependencies..."
    if command -v apt > /dev/null 2>&1; then
        sudo apt update
        sudo apt install -y nodejs npm python3-pip ripgrep
    elif command -v dnf > /dev/null 2>&1; then
        sudo dnf install -y nodejs npm python3-pip ripgrep
    elif command -v pacman > /dev/null 2>&1; then
        sudo pacman -Syu --noconfirm nodejs npm python-pip ripgrep
    elif command -v zypper > /dev/null 2>&1; then
        sudo zypper install -y nodejs npm python3-pip ripgrep
    fi

    pip install pynvim
    sudo npm install -g neovim
}

# Run steps
install_neovim
setup_config
install_dependencies
install_plugins

echo "Neovim installation complete!"

