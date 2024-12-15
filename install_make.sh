#!/bin/bash

set -e

echo "Checking for package manager and installing make..."

if command -v apt > /dev/null 2>&1; then
    echo "Using apt (Debian/Ubuntu)."
    sudo apt update
    sudo apt install -y make
elif command -v dnf > /dev/null 2>&1; then
    echo "Using dnf (Fedora)."
    sudo dnf install -y make
elif command -v pacman > /dev/null 2>&1; then
    echo "Using pacman (Arch)."
    sudo pacman -Syu --noconfirm make
elif command -v zypper > /dev/null 2>&1; then
    echo "Using zypper (openSUSE)."
    sudo zypper install -y make
else
    echo "Unsupported package manager. Please install 'make' manually."
    exit 1
fi

echo "make installed successfully!"

