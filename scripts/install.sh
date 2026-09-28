#!/usr/bin/env bash
# Build tmux/zsh (and libevent/ncurses if missing) from source into ~/tools.
# Building tmux needs yacc (bison). Use `./install.sh deps` first when you have
# sudo; it installs bison and the libraries from the package manager.
set -euo pipefail

# What do we want?
libeventversion=2.1.12
ncursesversion=6.5
tmuxversion=3.5a
zshversion=5.9.2

PKGS=$HOME/pkgs
TOOLS=$HOME/tools

# Find libraries built into $TOOLS, at build and run time
export CPPFLAGS="-I$TOOLS/include -I$TOOLS/include/ncursesw"
export LDFLAGS="-L$TOOLS/lib -Wl,-rpath,$TOOLS/lib"
export PKG_CONFIG_PATH="$TOOLS/lib/pkgconfig"

. /etc/os-release
echo "Installing on $NAME..."

# install deps
install_deps() {
    case "$ID ${ID_LIKE:-}" in
        *rhel*|*fedora*|*centos*)
            sudo yum install -y gcc make git bison libevent-devel ncurses-devel
            ;;
        *debian*|*ubuntu*)
            sudo apt install -y build-essential git bison libevent-dev libncurses-dev
            ;;
    esac
}

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
install_libevent() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -OL "https://github.com/libevent/libevent/releases/download/release-$libeventversion-stable/libevent-$libeventversion-stable.tar.gz"
    tar -xzf "libevent-$libeventversion-stable.tar.gz"
    cd "libevent-$libeventversion-stable"
    ./configure --prefix=$TOOLS --disable-openssl
    make -j"$(nproc)"
    make install
    popd
}

# Install ncurses
install_ncurse() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -OL "https://invisible-island.net/archives/ncurses/ncurses-$ncursesversion.tar.gz"
    tar -xzf "ncurses-$ncursesversion.tar.gz"
    cd "ncurses-$ncursesversion"
    CFLAGS="-fPIC" CXXFLAGS="-fPIC" ./configure --prefix=$TOOLS --enable-shared --enable-pc-files --with-pkg-config-libdir=$TOOLS/lib/pkgconfig
    make -j"$(nproc)"
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
    make -j"$(nproc)"
    make install
    popd
}

# install zsh
install_zsh() {
    mkdir -p $PKGS
    mkdir -p $TOOLS
    pushd $PKGS

    curl -L -o "zsh-$zshversion.tar.xz" "https://sourceforge.net/projects/zsh/files/zsh/$zshversion/zsh-$zshversion.tar.xz/download"
    tar -xf "zsh-$zshversion.tar.xz"
    cd "zsh-$zshversion"
    CFLAGS="-fPIC" CXXFLAGS="-fPIC" ./configure --prefix=$TOOLS --enable-shared
    make -j"$(nproc)"
    make install
    popd
}

# Build the libraries only when their headers are missing
has_header() {
    [ -f "/usr/include/$1" ] || [ -f "$TOOLS/include/$1" ]
}

if [[ " $* " == *" deps "* ]]; then
    install_deps
fi

if ! has_header event2/event.h; then
    install_libevent
fi

if ! has_header ncurses.h && ! has_header ncursesw/ncurses.h; then
    install_ncurse
fi

if [[ $# == 0 ]]; then
    install_tmux
    install_zsh
else
    for var in "${@}"; do
        if [[ $var == "deps" ]]; then
            :
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
