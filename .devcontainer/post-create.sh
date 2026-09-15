#!/usr/bin/env bash
# Sets up Lean 4 (via elan) and Dafny for this Codespace.
# Safe to re-run: skips work that is already done.
set -euo pipefail

DAFNY_VERSION="${DAFNY_VERSION:-4.11.0}"
DAFNY_ASSET="dafny-${DAFNY_VERSION}-x64-ubuntu-22.04.zip"
OPT_DIR="$HOME/.local/opt"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$OPT_DIR" "$BIN_DIR"

# ---------- Lean 4 (elan + stable toolchain) ----------
if [ ! -x "$HOME/.elan/bin/elan" ]; then
  echo "==> Installing elan (Lean toolchain manager)"
  curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain stable
else
  echo "==> elan already installed"
fi
export PATH="$HOME/.elan/bin:$PATH"
lean --version
lake --version

# ---------- Dafny (self-contained release zip, bundles .NET 8 runtime + Z3) ----------
if [ ! -x "$OPT_DIR/dafny/dafny" ] || ! "$OPT_DIR/dafny/dafny" --version | grep -q "^${DAFNY_VERSION}"; then
  echo "==> Installing Dafny ${DAFNY_VERSION}"
  rm -rf "$OPT_DIR/dafny"
  curl -sSL -o "/tmp/${DAFNY_ASSET}" \
    "https://github.com/dafny-lang/dafny/releases/download/v${DAFNY_VERSION}/${DAFNY_ASSET}"
  unzip -q -o "/tmp/${DAFNY_ASSET}" -d "$OPT_DIR"
  rm -f "/tmp/${DAFNY_ASSET}"
else
  echo "==> Dafny ${DAFNY_VERSION} already installed"
fi
ln -sf "$OPT_DIR/dafny/dafny" "$BIN_DIR/dafny"
"$BIN_DIR/dafny" --version

# ---------- Build the sample Lean project so the editor is warm ----------
if [ -f "$(dirname "$0")/../lean_trial/lakefile.toml" ]; then
  echo "==> Building lean_trial"
  (cd "$(dirname "$0")/../lean_trial" && lake build)
fi

echo "==> Done. Open a new terminal (or 'source ~/.profile') so PATH picks up lean/lake/dafny."
