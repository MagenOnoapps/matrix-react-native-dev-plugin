---
name: rn-dev-planning
description: Methodology for turning a feature analysis into a dev plan and task breakdown. Used by /create-dev-plan via the rn-architect agent and dev-plan/task-breakdown templates.
---

## Methodology

1. **Start from the Analyze-stage output.** Use `rn-architect`'s technical approach and `repo-analyst`'s detected conventions (nav library, state mgmt, folder structure) as the basis for the plan — don't re-derive them from scratch.

2. **Populate `templates/dev-plan-template.md`'s frontmatter** (`feature`, `dd_link`, `author`, `status: draft`, `date`) and its Overview, Impacted Areas, and Technical Approach sections, citing the relevant standard IDs (`ARCH-*`, `API-*`, `STATE-*`, `NAV-*`) the approach follows.

3. **Decompose the technical approach into discrete tasks** in `templates/task-breakdown-template.md`. Each task must be small enough for a single `/implement-task` run and carry concrete, checkable acceptance criteria — avoid vague criteria like "works correctly."

4. **Record dependencies between tasks** in the `depends-on` column so `/implement-task` can be run in a valid order.

5. **Flag risks and open questions explicitly** in the dev plan's Risks & Open Questions section rather than silently picking an assumption — anything that would change the technical approach if answered differently belongs here.

6. **Write a Rollback Plan** before task breakdown is considered final — how this change gets reverted if it ships broken (feature flag, revert commit, migration reversal).

7. **Leave `status: draft`** until a human explicitly approves the plan — `/implement-task` should not run against a plan still in draft.
