#!/usr/bin/env bash
# Install the agent CLIs if missing, then clone or update ivanium/agent-skills
# and run its install.sh (skills, tools and agent config). Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS="$HOME/code/agent-skills"

"$DOTFILES/scripts/install_agents.sh"

if [ ! -d "$SKILLS" ]; then
    git clone git@github.com:ivanium/agent-skills.git "$SKILLS"
elif ! git -C "$SKILLS" pull --ff-only --quiet; then
    echo "Warning: could not update $SKILLS, installing from the current checkout" >&2
fi

"$SKILLS/install.sh"
