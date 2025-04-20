#!/bin/bash

if ! command -v wget >/dev/null 2>&1; then
  echo "Installing wget..."
  sudo apt update
  sudo apt install -y wget
else
  echo "wget is already installed: $(wget --version | head -n 1)"
fi
if ! command -v go >/dev/null 2>&1; then
  echo "Go is not installed. Installing..."
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

    rm "$GO_TARBALL"
else
  go_version=$(go version)
  echo "Go is already installed: $go_version"
fi

if command -v make >/dev/null 2>&1; then
    make_version=$(make --version | head -n 1)
    echo "make is already installed with version: $make_version"
else
    echo "make not found. Installing..."
    # Your install logic here (e.g., apt, pacman, etc.)
    sudo apt update
    sudo apt install -y make
fi

if command -v zsh >/dev/null 2>&1; then
    zsh_version=$(zsh --version)
    echo "Zsh is already installed with version: $zsh_version"
else
    echo "Zsh not found. Installing..."
    # Your install logic here (e.g., apt, pacman, etc.)
    sudo apt update
    sudo apt install -y zsh
fi

echo "Setting up Zsh configuration..."

# Backup current .zshrc (if it exists)
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up current .zshrc to .zshrc.bak"
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# Link your custom .zshrc
echo "Linking custom .zshrc..."
ln -sf "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh-autosuggestions plugin if not already installed
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting plugin if not already installed
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Set theme (optional)
echo "Setting theme..."
ZSH_THEME="agnoster"  # Or choose a theme like 'powerlevel10k'
echo "ZSH_THEME=\"$ZSH_THEME\"" >> "$HOME/.zshrc"

# Source the new configuration
source "$HOME/.zshrc"

echo "Zsh configuration setup completed!"