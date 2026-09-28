#!/usr/bin/env bash
# Install Claude Code, Codex and Kimi Code with their official installers,
# skipping any that are already installed (each CLI updates itself).
set -euo pipefail

# Where the installers put the binaries, so re-runs find them. Having
# ~/.local/bin on PATH also stops the Codex installer from editing ~/.zshrc.
export PATH="$HOME/.local/bin:$HOME/.kimi-code/bin:$PATH"

if ! command -v claude >/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

if ! command -v codex >/dev/null; then
    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
fi

# zsh/zshrc already puts ~/.kimi-code/bin on PATH
if ! command -v kimi >/dev/null; then
    curl -fsSL https://code.kimi.com/kimi-code/install.sh | KIMI_NO_MODIFY_PATH=1 bash
fi
