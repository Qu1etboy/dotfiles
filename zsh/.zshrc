source ~/dotfiles/.aliases

for file in ~/dotfiles/zsh/*.zsh; do
  source "$file"
done

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(fzf --zsh)
eval "$(starship init zsh)"

########################################################
# Chore Functions
########################################################

# create a new directory and cd into it
function take {
  mkdir -p $1
  cd $1
}

# use eza for ls, but real ls when output is captured
# (eza prints nothing given no path argument when stdout is not a TTY)
function ls {
  if [[ -t 1 ]]; then
    eza --icons "$@"
  else
    command ls "$@"
  fi
}

