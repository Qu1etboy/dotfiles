# Qu1etboy's Dotfiles

Qu1etboy basic dotfiles to used across different machines

## Installation

1. Run the following command to bootstrap the new machine it will install the necessary tools and apps

```sh
curl -s https://raw.githubusercontent.com/qu1etboy/dotfiles/main/bootstrap.sh | bash
```

2. Clone the repo or download as zip file and run the links.sh script to symlink the dotfiles into the right place on your machine

```sh
git clone git@github.com:Qu1etboy/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./links.sh
```

## Setup Git

1. Copy `template.gitconfig` and rename to `work.gitconfig` to setup your work git configuration

```sh
cp ~/.dotfiles/template.gitconfig ~/.dotfiles/work.gitconfig
```

## Scripts

- `bootstrap.sh` - Install the necessary tools and apps
  - `brew/install.sh` - Install Homebrew
  - `install-deps.sh` - Install the necessary dependencies using brew
- `links.sh` - Symlink the dotfiles into the right place on your machine
