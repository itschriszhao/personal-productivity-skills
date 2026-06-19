#!/usr/bin/env bash
# install.sh — link skills/* into your AI agent's skills directory
# Usage:
#   ./install.sh                              # install (idempotent)
#   ./install.sh --dry-run                    # preview only
#   SKILLS_DST=~/.claude/skills ./install.sh  # override target dir

set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${REPO_DIR}/skills"
SKILLS_DST="${SKILLS_DST:-${HOME}/.skills}"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "[install] no skills/ directory found at $SKILLS_SRC, nothing to do."
  exit 0
fi

mkdir -p "$SKILLS_DST"

linked=0
skipped=0
for dir in "$SKILLS_SRC"/*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  src="$(cd "$dir" && pwd)"
  dst="$SKILLS_DST/$name"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "[skip ] $name (already linked)"
    skipped=$((skipped+1))
    continue
  fi

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    echo "[warn ] $dst exists and is not a symlink — skip to avoid overwrite"
    continue
  fi

  if (( DRY_RUN )); then
    echo "[dry  ] would link $dst -> $src"
  else
    ln -sfn "$src" "$dst"
    echo "[link ] $name -> $src"
    linked=$((linked+1))
  fi
done

echo "[done ] linked=$linked skipped=$skipped target=$SKILLS_DST"
