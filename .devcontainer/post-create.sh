#!/usr/bin/env bash
set -euo pipefail

# Install elan (Lean toolchain manager)
if [ ! -x "$HOME/.elan/bin/elan" ]; then
  curl -sSf https://elan.lean-lang.org/elan-init.sh \
    | sh -s -- -y --default-toolchain stable
fi

export PATH="$HOME/.elan/bin:$PATH"

# Make lean/lake available in non-login shells (VS Code terminals read ~/.bashrc)
grep -q '.elan/bin' "$HOME/.bashrc" || echo 'export PATH="$HOME/.elan/bin:$PATH"' >> "$HOME/.bashrc"

# Verify installation
lean --version
lake --version
