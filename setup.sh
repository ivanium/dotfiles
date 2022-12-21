#!/usr/bin/env bash

# set -e          # Exit on error
# set -o pipefail # Exit on pipe error
# set -x          # Enable verbosity

# Dont link DS_Store files
find . -name ".DS_Store" -exec rm {} \;

function backup_if_exists() {
    if [ -f $1 ];
    then
      mv $1 "$1.bk"
    fi
    if [ -d $1 ];
    then
      mv $1 "$1.bk"
    fi
}

# Backup files
backup_if_exists $HOME/.zshrc
backup_if_exists $HOME/.oh-my-zsh
backup_if_exists $HOME/.tmux.conf
backup_if_exists $HOME/.vimrc
backup_if_exists $HOME/.gitconfig
backup_if_exists $HOME/.gitignore_global

# Copy files
cp zsh/zshrc $HOME/.zshrc
tar xzf zsh/oh-my-zsh.tar.gz
cp -r oh-my-zsh/.oh-my-zsh $HOME/.oh-my-zsh
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cp zsh/p10k.zsh $HOME/.p10k.zsh

cp tmux/tmux.conf $HOME/.tmux.conf

cp vim/vimrc $HOME/.vimrc
mkdir -p $HOME/.vim
cp -r vim/* $HOME/.vim/

cp git/gitconfig $HOME/.gitconfig
cp git/gitignore_global $HOME/.gitignore_global

