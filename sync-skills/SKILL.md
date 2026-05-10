---
name: sync-skills
description: When a new skill is created by /skill-create, sync it to the claude-skills GitHub repository
---

# Sync Skills

Automatically sync newly created skills from `~/.claude/skills/` to the `wt2017/claude-skills` GitHub repository.

## Trigger

This skill activates when a new skill directory is created at `~/.claude/skills/<name>/SKILL.md` (e.g. by `/skill-create`).

## Prerequisites

- Write access to `git@github.com:wt2017/claude-skills.git`
- Repo cloned at `/home/wyou/data/partition1/projects/claude-skills`
- `gh` CLI authenticated with GitHub

## Workflow

When a new skill `~/.claude/skills/<name>/SKILL.md` is detected:

### Step 1: Copy into repo

```bash
cp -r ~/.claude/skills/<name> /home/wyou/data/partition1/projects/claude-skills/<name>
```

### Step 2: Commit

```bash
cd /home/wyou/data/partition1/projects/claude-skills
git add <name>/SKILL.md
git commit -m "feat: add <name> skill"
```

### Step 3: Push

```bash
git push origin main
```

## Automated Hook (Recommended)

For fully automatic syncing, install this PostToolUse hook in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "glob": "{/home/{wyou,wt2017}/.claude/skills/*/SKILL.md,/**/.claude/skills/*/SKILL.md}",
        "command": "bash /home/wyou/data/partition1/projects/claude-skills/sync-skills/sync.sh \"$FILE_PATH\"",
        "description": "Auto-sync new skills to claude-skills GitHub repo"
      }
    ]
  }
}
```

### Sync Script

Create `/home/wyou/data/partition1/projects/claude-skills/sync-skills/sync.sh`:

```bash
#!/bin/bash
# Auto-sync a newly created skill to the claude-skills GitHub repo
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
```

Make it executable: `chmod +x /home/wyou/data/partition1/projects/claude-skills/sync-skills/sync.sh`

## Verification

After syncing:

```bash
cd /home/wyou/data/partition1/projects/claude-skills
git log --oneline -1
ls <name>/SKILL.md
```

## Installing This Skill

Make this skill available at runtime:

```bash
# Symlink (updates automatically when repo pulls)
ln -sf /home/wyou/data/partition1/projects/claude-skills/sync-skills /home/wyou/.claude/skills/sync-skills
```
