---
description: Show the audit topic table and docs/project/ freshness for the current repository
---

Report the project-inspector status for the repository (ask for the repo path if it isn't clear from context). This is read-only — do not invoke any skill and do not write any file.

1. Read `AUDIT.md`. If missing, say so and suggest running /inspect.
2. Print the Audit Topics table, followed by counts: how many topics are Pending Breakdown, Draft, and Approved.
3. List which files exist under `docs/project/` with their last-modified dates (`ls -l`), or note that the knowledge base hasn't been generated (suggest /inspect-docs).
4. Note the last-modified dates of CLAUDE.md and AUDIT.md.
5. Suggest the next step: /inspect-docs if docs are missing, /inspect-breakdown if Pending topics remain, /inspect-sync if Drafts await approval.
