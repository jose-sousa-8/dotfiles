#!/bin/bash

# Update package list and install wget if needed
echo "Installing wget..."
sudo apt update
sudo apt install -y wget

# Variables for Go version and tarball
GO_VERSION="go1.24.2"
GO_TARBALL="${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"

echo "Installing Go version ${GO_VERSION}..."

# Check if the Go tarball already exists
if [ -f "$GO_TARBALL" ]; then
    echo "File $GO_TARBALL already exists, skipping download."
else
    echo "Downloading $GO_TARBALL..."
    wget "$GO_URL"
fi

echo "Removing previous Go installation (if any)..."
sudo rm -rf /usr/local/go

echo "Extracting Go archive..."
sudo tar -C /usr/local -xzf "$GO_TARBALL"

# Create a symlink for the Go executable at /usr/bin/go
echo "Creating symlink for go in /usr/bin..."
sudo ln -sf /usr/local/go/bin/go /usr/bin/go

# Clear the shell's command hash cache
hash -r

# Add Go to PATH for the current script execution
export PATH=$PATH:/usr/local/go/bin

echo "Verifying Go installation..."
go version

echo "Adding Go to PATH permanently..."
if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.profile; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
    echo "Added Go to PATH in ~/.profile."
else
    echo "Go PATH entry already exists in ~/.profile."
fi

echo "Go ${GO_VERSION} installed successfully!"

sleep 1

echo "Checking for package manager and installing make..."

if command -v apt > /dev/null 2>&1; then
    echo "Using apt (Debian/Ubuntu)."
    sudo apt update
    sudo apt install -y make
else 
    echo "Unsupported package manager. Please install 'make' manually."
    exit 1
fi

echo "make installed successfully!"
