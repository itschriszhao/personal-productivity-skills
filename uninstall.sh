#!/usr/bin/env bash
# uninstall.sh — remove symlinks created by install.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${REPO_DIR}/skills"
SKILLS_DST="${SKILLS_DST:-${HOME}/.comate/skills}"

removed=0
for dir in "$SKILLS_SRC"/*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  src="$(cd "$dir" && pwd)"
  dst="$SKILLS_DST/$name"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    rm "$dst"
    echo "[rm   ] $dst"
    removed=$((removed+1))
  fi
done

echo "[done ] removed=$removed"
