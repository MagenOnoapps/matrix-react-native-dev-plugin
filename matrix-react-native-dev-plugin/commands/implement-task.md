---
description: Implement a single task from an approved dev plan.
argument-hint: [task-id]
---

Implement a single task from an approved dev plan.

1. Resolve `$ARGUMENTS` as a task id and look it up in the current feature's `templates/task-breakdown-template.md` row.
2. Confirm every task listed in that row's "depends-on" column is already done — do not start if a dependency is still outstanding.
3. Apply the `rn-feature-implementation` skill methodology via the `rn-feature-developer` agent to implement the task against all applicable standards. If the task touches UI and the dev plan has no `figma_link`, the agent asks for one before implementing.
4. Self-check the implementation against the task's acceptance criteria before reporting done.
5. Report which standard IDs were applied (e.g. `RN-*`, `API-*`, `STATE-*`, `I18N-*`, `A11Y-*`) so `/review-code` and `/create-dev-qa-notes` can trace them later.

Do not expand scope beyond this one task's acceptance criteria — a task that turns out to need more work should be flagged, not silently absorbed.
