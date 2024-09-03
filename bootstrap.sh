#!/bin/bash

echo "Installing Homebrew..."
curl -s https://raw.githubusercontent.com/Qu1etboy/dotfiles/main/brew/install.sh | bash

echo "Installing dependencies..."
curl -s https://raw.githubusercontent.com/Qu1etboy/dotfiles/main/install-deps.sh | bash

echo "Setting up symlinks..."
curl -s https://raw.githubusercontent.com/Qu1etboy/dotfiles/main/links.sh | bash

echo "Done! 🚀"