#!/usr/bin/env bash
# PreToolUse hook: forces a human-approval prompt before any code file is
# written/edited, even in auto-approve/bypass-permissions modes. Non-code
# files (docs/config) pass through untouched. Reads the tool-call JSON
# payload from stdin.
set -euo pipefail

payload="$(cat)"

tool_name="$(jq -r '.tool_name // empty' <<<"$payload")"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$payload")"

case "$tool_name" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

[ -z "$file_path" ] && exit 0

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.swift|*.kt|*.java|*.m|*.mm|*.cpp|*.h)
    jq -n --arg reason "Code file change to ${file_path} requires explicit approval before writing (org policy: require-approval-before-code)." \
      '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $reason}}'
    exit 0
    ;;
  *)
    exit 0
    ;;
esac
