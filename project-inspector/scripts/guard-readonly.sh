#!/bin/bash
# PreToolUse guard for the project-inspector plugin.
#
# Active only while ~/.claude/project-inspector.active exists (the inspector
# skills create it on start and remove it on finish). While active, blocks
# destructive shell commands so inspection runs are mechanically read-only.
# Exit 0 = allow, exit 2 = block (stderr is shown to Claude).

MARKER="$HOME/.claude/project-inspector.active"

# Inspection not active — allow everything, stay out of normal dev work.
[ ! -f "$MARKER" ] && exit 0

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')
else
  echo "project-inspector guard: jq not found; command allowed unchecked" >&2
  exit 0
fi

[ -z "$CMD" ] && exit 0

# The skills manage the marker themselves — let those commands through.
case "$CMD" in
  *project-inspector.active*) exit 0 ;;
esac

deny() {
  echo "project-inspector guard: BLOCKED ($1). Inspection skills are read-only; use the Write/Edit tools for the skill's declared output files. Command: $CMD" >&2
  exit 2
}

# File-mutating commands.
if printf '%s' "$CMD" | grep -qE '(^|[;&|[:space:]])(rm|mv|cp|touch|tee|dd|chmod|chown|ln|mkdir|rmdir|truncate|install)([[:space:]]|$)'; then
  deny "file mutation command"
fi

# In-place edits.
if printf '%s' "$CMD" | grep -qE '(^|[;&|[:space:]])(sed|perl)[[:space:]][^|;]*-i'; then
  deny "in-place edit"
fi

# State-changing git.
if printf '%s' "$CMD" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+(add|commit|checkout|switch|restore|clean|reset|revert|rm|mv|stash|push|pull|fetch|merge|rebase|apply|am|tag|branch[[:space:]]+-[dDmM])([[:space:]]|$)'; then
  deny "state-changing git command"
fi

# Output redirection — allow only /dev/null and fd duplication (2>&1).
STRIPPED=$(printf '%s' "$CMD" | sed -E 's@[0-9]*>{1,2}[[:space:]]*/dev/null@@g; s@[0-9]*>&[0-9]+@@g')
if printf '%s' "$STRIPPED" | grep -q '>'; then
  deny "output redirection"
fi

exit 0
