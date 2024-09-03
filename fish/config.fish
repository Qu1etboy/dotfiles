if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path $PATH

source ~/dotfiles/.aliases

alias s='source ~/.config/fish/config.fish'

starship init fish | source