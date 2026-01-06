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

# set the java home to the specified version
function java-use {
  export JAVA_HOME=`/usr/libexec/java_home -v $1`
}

# create a new directory and cd into it
function take {
  mkdir -p $1
  cd $1
}
