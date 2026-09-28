# Yifan's Dotfiles

Simple custom configurations for:
* `zsh`
* `vim`
* `tmux`
* `git`

## Usage

`./setup.sh` symlinks the configs into `$HOME` (existing files are moved to
`*.bk.<timestamp>`) and clones oh-my-zsh, powerlevel10k and the zsh plugins.
Re-running it updates those clones (fast-forward only) and is otherwise a no-op.

Per-machine settings go in files that are not tracked here:
* `~/.gitconfig_local` — git `[user]` name/email (setup.sh migrates your existing identity)
* `~/.zshrc_local`
* `~/.tmux_local.conf`

`./setup_agents.sh` installs Claude Code, Codex and Kimi Code if missing
(`scripts/install_agents.sh`), then clones or updates the private
[`ivanium/agent-skills`](https://github.com/ivanium/agent-skills) into
`~/code/agent-skills` and runs its `install.sh`, which installs the skills and
agent config (instructions, Claude settings, Codex/Kimi config templates).
Also safe to re-run.

`./scripts/install.sh` builds tmux/zsh from source into `~/tools` for machines without sudo.
