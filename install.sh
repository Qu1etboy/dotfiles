echo "🍺 Installing everything from Brewfile..."
if [ -f ~/dotfiles/Brewfile ]; then
    brew bundle --file=~/dotfiles/Brewfile
fi

echo "🛠️ Installing languages via Mise..."
mise install # This installs everything in your .mise.toml
