source ~/dotfiles/.aliases

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias s='source ~/.zshrc'

eval "$(starship init zsh)"

# export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

export PATH="/Users/qu1etboy/Library/Python/3.9/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -s "/Users/qu1etboy/.gvm/scripts/gvm" ]] && source "/Users/qu1etboy/.gvm/scripts/gvm"
