#!/bin/bash

echo "🟠 Start Symlink Files..."

ln -sfn ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sfn ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sfn ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sfn ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sfn ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sfn ~/dotfiles/ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
ln -sfn ~/dotfiles/cursor/settings.json $HOME/Library/Application\ Support/Cursor/User/settings.json
ln -sfn ~/dotfiles/mise.toml ~/.config/mise/config.toml

# Claude Code (Eli + Echo)
mkdir -p ~/.claude ~/.claude/skills ~/.claude/agents ~/.claude/output-styles ~/.claude/themes
ln -sfn ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -sfn ~/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sfn ~/dotfiles/claude/skills/ship ~/.claude/skills/ship
ln -sfn ~/dotfiles/claude/agents/echo.md ~/.claude/agents/echo.md
ln -sfn ~/dotfiles/claude/output-styles/eli.md ~/.claude/output-styles/eli.md
ln -sfn ~/dotfiles/claude/themes/eli.json ~/.claude/themes/eli.json

echo "🟠 Finish Symlink Files..."
