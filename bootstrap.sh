#!/bin/bash

echo "🟠 Start Installing Homebrew..."
curl -s https://raw.githubusercontent.com/Qu1etboy/dotfiles/main/brew/install.sh | bash
echo "🟠 Finish Installing Homebrew..."

echo "🔵 Start Installing Dependencies..."
curl -s https://raw.githubusercontent.com/Qu1etboy/dotfiles/main/install-deps.sh | bash
echo "🔵 Finish Installing Dependencies..."