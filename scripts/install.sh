#!/usr/bin/env bash

# Install dependencies on rhel/centos 7

# What do we want?
libeventversion=2.1.11
ncursesversion=6.2
tmuxversion=3.1
zshversion=5.8

PKGS=$HOME/pkgs
TOOLS=$HOME/tools

OS_DISTRO=$( awk -F= '/^NAME/{print $2}' /etc/os-release | sed -e 's/^"//' -e 's/"$//' )
echo "Installing on $OS_DISTRO..."

# install deps
install_deps() {
    if [[ $OS_DISTRO == "CentOS Linux" ]]; then
        INSTALL_LIST="gcc kernel-devel make git"
        sudo yum install -y $INSTALL_LIST
    elif [[ $OS_DISTRO == "Ubuntu" ]]; then
        INSTALL_LIST="build-essential make git"
        sudo apt install -y $INSTALL_LIST
    fi
}

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
install_libevent() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -OL "https://github.com/libevent/libevent/releases/download/release-$libeventversion-stable/libevent-$libeventversion-stable.tar.gz"
    tar -xzf "libevent-$libeventversion-stable.tar.gz"
    cd "libevent-$libeventversion-stable"
    ./configure --prefix=$TOOLS
    make -j
    make install
    popd
}

# Install ncurses
install_ncurse() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -OL "ftp://ftp.invisible-island.net/ncurses/ncurses-$ncursesversion.tar.gz"
    tar -xzf "ncurses-$ncursesversion.tar.gz"
    cd "ncurses-$ncursesversion"
    export CXXFLAGS=" -fPIC"
    export CFLAGS=" -fPIC"
    ./configure --prefix=$TOOLS --enable-shared
    make -j
    make install
    popd
}

# DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
install_tmux() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -OL "https://github.com/tmux/tmux/releases/download/$tmuxversion/tmux-$tmuxversion.tar.gz"
    tar -xzf "tmux-$tmuxversion.tar.gz"
    cd "tmux-$tmuxversion"
    ./configure --prefix=$TOOLS
    make -j
    make install
    popd
}

# install zsh
install_zsh() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -OL "https://sourceforge.net/projects/zsh/files/zsh/$zshversion/zsh-$zshversion.tar.xz"
    tar -xf "zsh-$zshversion.tar.xz"
    cd "zsh-$zshversion"
    autoheader
    autoconf
    export CXXFLAGS=" -fPIC"
    export CFLAGS=" -fPIC"
    ./configure --prefix=$TOOLS --enable-shared
    make -j
    make install
    popd
}

if [[ -z `ldconfig -p | grep libevent` ]]; then
    install_libevent
fi


if [[ -z `ldconfig -p | grep libncurse` ]]; then
    install_ncurse
fi

if [[ $# == 0 ]]; then
    install_tmux
    install_zsh
else
    for var in "${@}"; do
        if [[ $var == "deps" ]]; then
            install_deps
        elif [[ $var == "tmux" ]]; then
            install_tmux
        elif [[ $var == "zsh" ]]; then
            install_zsh
        elif [[ $var == "all" ]]; then
            install_tmux
            install_zsh
        else
            echo "Not support installing $var yet"
        fi
    done
fi
