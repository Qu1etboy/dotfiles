if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path $PATH

source ~/dotfiles/.aliases

alias s='source ~/.config/fish/config.fish'

set -g -x JAVA_HOME (/usr/libexec/java_home -v 21)

starship init fish | source