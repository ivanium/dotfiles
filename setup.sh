#!/usr/bin/env bash
# Symlink dotfiles into $HOME and fetch zsh plugins. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Move $2 aside unless it is already a link to $1, then link $2 -> $1.
link() {
    local src="$DOTFILES/$1" dst="$2"
    if [ "$(readlink "$dst")" = "$src" ]; then
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bk.$(date +%Y%m%d%H%M%S)"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
}

# Clone $1 into $2, or fast-forward an existing clone.
clone() {
    if [ ! -d "$2" ]; then
        git clone --depth 1 "$1" "$2"
    elif [ ! -d "$2/.git" ]; then
        echo "Warning: $2 is not a git clone, not updating" >&2
    elif ! git -C "$2" pull --ff-only --quiet; then
        echo "Warning: could not update $2, skipping" >&2
    fi
}

# Keep the existing git identity, which no longer lives in the repo.
if [ ! -f "$HOME/.gitconfig_local" ] && email=$(git config --global user.email); then
    git config -f "$HOME/.gitconfig_local" user.name "$(git config --global user.name)"
    git config -f "$HOME/.gitconfig_local" user.email "$email"
fi

clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

link zsh/zshrc            "$HOME/.zshrc"
link zsh/p10k.zsh         "$HOME/.p10k.zsh"
link tmux/tmux.conf       "$HOME/.tmux.conf"
link vim/vimrc            "$HOME/.vimrc"
link vim/autoload/plug.vim "$HOME/.vim/autoload/plug.vim"
link vim/ftplugin         "$HOME/.vim/ftplugin"
link git/gitconfig        "$HOME/.gitconfig"
link git/gitignore_global "$HOME/.gitignore_global"

if [ ! -f "$HOME/.gitconfig_local" ]; then
    echo "Note: set your git identity in ~/.gitconfig_local, e.g."
    echo "  git config -f ~/.gitconfig_local user.email you@example.com"
fi
