---
description: Mark developer-approved audit topics as Approved and sync findings into CLAUDE.md (audit-sync skill)
argument-hint: "[topic names]"
---

Invoke the `audit-sync` skill from the project-inspector plugin.

If the developer provided arguments, treat them as the topics being approved in this run: $ARGUMENTS

Follow the skill's workflow exactly: only approve topics the developer explicitly names, confirm before writing, and modify only the AUDIT.md status column and the audit-sync managed blocks in CLAUDE.md.
