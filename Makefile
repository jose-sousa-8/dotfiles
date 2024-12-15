.PHONY: all install config plugins dependencies clean

# Default target
all: install config dependencies plugins

# Install Neovim
install:
	bash install_neovim.sh

# Configure Neovim
config:
	@echo "Linking Neovim configuration..."
	mkdir -p ~/.config/nvim
	ln -sf $(PWD)/nvim/* ~/.config/nvim/

# Install Plugins
plugins:
	@echo "Installing plugins..."
	nvim --headless +PackerSync +qa

# Install Dependencies
dependencies:
	@echo "Installing optional dependencies..."
	bash install_neovim.sh --dependencies

# Clean Neovim config
clean:
	@echo "Cleaning up Neovim configuration..."
	rm -rf ~/.config/nvim

