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
cp zshrc $HOME/.zshrc
tar xvzf zsh/oh-my-zsh.tar.gz
cp -r oh-my-zsh/.oh-my-zsh $HOME/.oh-my-zsh
cp tmux.conf $HOME/.tmux.conf
cp vim/vimrc $HOME/.vimrc
cp git/gitconfig $HOME/.gitconfig
cp git/gitignore_global $HOME/.gitignore_global

# Install ncurses
install_ncurse() {
    # set paths
    mkdir -p $HOME/pkgs
    mkdir -p $HOME/tools
    pushd $HOME/pkgs

    wget ftp://ftp.invisible-island.net/ncurses/ncurses-6.2.tar.gz
    tar -zxvf ncurses-6.2.tar.gz

    cd ncurses-6.2
    export CXXFLAGS=' -fPIC'
    export CFLAGS=' -fPIC'
    ./configure --prefix=$HOME/tools --enable-shared

    make -j
    make install

    popd
}

# install zsh
install_zsh() {
    # set paths
    mkdir -p $HOME/pkgs
    mkdir -p $HOME/tools
    pushd $HOME/pkgs

    # Clone zsh repository from git
    git clone git://github.com/zsh-users/zsh.git
    cd zsh
    autoheader
    autoconf
    ./configure --prefix=$HOME/tools --enable-shared
    make -j
    make install

    popd
}

