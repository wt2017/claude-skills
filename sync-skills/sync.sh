#!/bin/bash
# Auto-sync a newly created skill to the claude-skills GitHub repo
# Called by PostToolUse hook when a SKILL.md is written to ~/.claude/skills/<name>/
SKILL_PATH="$1"
SKILL_DIR=$(basename "$(dirname "$SKILL_PATH")")
REPO_DIR="/home/wyou/data/partition1/projects/claude-skills"

cd "$REPO_DIR" || exit 1

# Only sync if this is a new skill directory (not an update to an existing one)
if [ ! -d "$REPO_DIR/$SKILL_DIR" ]; then
  cp -r "$(dirname "$SKILL_PATH")" "$REPO_DIR/$SKILL_DIR"
  git add "$SKILL_DIR/"
  git commit -m "feat: add $SKILL_DIR skill"
  git push origin main
fi
