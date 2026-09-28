# Yifan's Dotfiles

Simple custom configurations for:
* `zsh`
* `vim`
* `tmux`
* `git`

## Usage

`./setup.sh` symlinks the configs into `$HOME` (existing files are moved to
`*.bk.<timestamp>`) and clones oh-my-zsh, powerlevel10k and the zsh plugins.
It is safe to re-run.

Per-machine settings go in files that are not tracked here:
* `~/.gitconfig_local` — git `[user]` name/email (setup.sh migrates your existing identity)
* `~/.zshrc_local`
* `~/.tmux_local.conf`

`./scripts/install.sh` builds tmux/zsh from source into `~/tools` for machines without sudo.
