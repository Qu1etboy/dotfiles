#!/bin/bash

echo "🟠 Start Symlink Files..."

ln -sfn ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sfn ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sfn ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sfn ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sfn ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sfn ~/dotfiles/ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config

echo "🟠 Finish Symlink Files..."