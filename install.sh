#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${SHELL##*/}" == 'zsh' ]]; then TARGET="$HOME/.zshrc"; else TARGET="$HOME/.bashrc"; fi
touch "$TARGET"
STAMP="$(date +%Y%m%d-%H%M%S)"
cp "$TARGET" "$TARGET.frostshell-backup-$STAMP"
if ! grep -Fq "$ROOT/linux/frostshell.sh" "$TARGET"; then
  printf '\n# FrostShell Christmas terminal theme\nsource "%s/linux/frostshell.sh"\n' "$ROOT" >> "$TARGET"
fi
echo "FrostShell installed in $TARGET"
echo "Backup: $TARGET.frostshell-backup-$STAMP"
echo "Restart your terminal or run: source \"$TARGET\""
