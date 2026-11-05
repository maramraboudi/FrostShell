#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for TARGET in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [[ -f "$TARGET" ]]; then
    TMP="$(mktemp)"
    grep -v -F "$ROOT/linux/frostshell.sh" "$TARGET" | grep -v -F '# FrostShell Christmas terminal theme' > "$TMP" || true
    cat "$TMP" > "$TARGET"
    rm -f "$TMP"
    echo "Removed FrostShell loader from $TARGET (if present)."
  fi
done
echo 'Backups were kept.'
