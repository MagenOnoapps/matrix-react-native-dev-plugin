#!/usr/bin/env bash
# PreToolUse hook: blocks Write/Edit/MultiEdit while checked out on main or
# master, to force feature-branch workflow. Fails open (allows) if the
# project isn't a git repo or the branch can't be determined.
set -uo pipefail

payload="$(cat)"

tool_name="$(jq -r '.tool_name // empty' <<<"$payload")"
case "$tool_name" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

project_dir="${CLAUDE_PROJECT_DIR:-.}"
branch="$(cd "$project_dir" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null)"

if [ -z "$branch" ]; then
  exit 0
fi

case "$branch" in
  main|master)
    echo "Blocked: direct changes on '${branch}' are not allowed. Create a feature branch before making code changes." >&2
    exit 2
    ;;
  *)
    exit 0
    ;;
esac
