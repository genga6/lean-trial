#!/usr/bin/env bash
# Installs the Lean and Dafny toolchains. Idempotent: safe to re-run by hand.
set -euo pipefail

DAFNY_VERSION="${DAFNY_VERSION:-4.11.0}"
INSTALL_MATHLIB="${INSTALL_MATHLIB:-true}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFIX="$HOME/.local"
BIN="$PREFIX/bin"
mkdir -p "$BIN"
export PATH="$HOME/.elan/bin:$BIN:$PATH"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

install_elan() {
  if command -v elan >/dev/null; then
    log "elan already installed ($(elan --version))"
    return
  fi
  log "Installing elan (Lean toolchain manager)"
  curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
    | sh -s -- -y --default-toolchain none
}

install_dafny() {
  if [ -x "$PREFIX/dafny/dafny" ] && "$PREFIX/dafny/dafny" --version 2>/dev/null | grep -q "^${DAFNY_VERSION}"; then
    log "Dafny ${DAFNY_VERSION} already installed"
    return
  fi

  if [ "$(uname -m)" != "x86_64" ]; then
    # No Linux arm64 build is published; the NuGet tool works everywhere .NET does.
    log "Non-x86_64 host: installing Dafny ${DAFNY_VERSION} as a dotnet global tool"
    dotnet tool update --global Dafny --version "${DAFNY_VERSION}"
    return
  fi

  log "Installing Dafny ${DAFNY_VERSION}"
  local url="https://github.com/dafny-lang/dafny/releases/download/v${DAFNY_VERSION}/dafny-${DAFNY_VERSION}-x64-ubuntu-22.04.zip"
  local tmp
  tmp="$(mktemp -d)"
  curl -sSfL -o "$tmp/dafny.zip" "$url"
  rm -rf "$PREFIX/dafny"
  unzip -q "$tmp/dafny.zip" -d "$PREFIX"      # the archive already contains a dafny/ directory
  rm -rf "$tmp"
  chmod +x "$PREFIX/dafny/dafny" "$PREFIX/dafny/DafnyDriver" "$PREFIX/dafny/DafnyServer" 2>/dev/null || true
  ln -sf "$PREFIX/dafny/dafny" "$BIN/dafny"
}

setup_lean_project() {
  log "Fetching the Lean toolchain pinned in lean/lean-toolchain"
  cd "$REPO_ROOT/lean"
  elan toolchain install "$(cat lean-toolchain)"
  # so that `lake`/`lean` also work outside lean/
  elan default "$(cat lean-toolchain)"

  if [ "$INSTALL_MATHLIB" = "true" ]; then
    log "Downloading prebuilt Mathlib oleans (this takes a few minutes)"
    lake exe cache get
  else
    log "INSTALL_MATHLIB=false: skipping the Mathlib cache (run 'make lean-cache' later)"
    return
  fi

  log "Building the Lean playground"
  lake build
}

add_path_to_bashrc() {
  local marker="# >>> lean-dafny-trial path >>>"
  grep -qF "$marker" "$HOME/.bashrc" 2>/dev/null && return
  cat >> "$HOME/.bashrc" <<'EOF'

# >>> lean-dafny-trial path >>>
export PATH="$HOME/.elan/bin:$HOME/.local/bin:$PATH"
# <<< lean-dafny-trial path <<<
EOF
}

install_elan
install_dafny
add_path_to_bashrc
setup_lean_project

log "Done"
printf '  lean : %s\n' "$(cd "$REPO_ROOT/lean" && lean --version)"
printf '  dafny: %s\n' "$(dafny --version)"
