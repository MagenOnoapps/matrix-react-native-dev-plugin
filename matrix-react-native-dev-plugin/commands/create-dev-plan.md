---
description: Turn a feature analysis into a dev plan and task breakdown.
argument-hint: [feature-name]
---

Turn a feature analysis into an approved-ready dev plan.

1. Take `$ARGUMENTS` as the feature name and locate its `templates/feature-analysis-template.md` from a prior `/analyze-feature` run. Confirm its frontmatter `status` is `approved` — if it's still `proposed`, stop and ask a human to review it first.
2. Apply the `rn-dev-planning` skill methodology via the `rn-architect` agent to turn that approved analysis into a technical approach.
3. Populate `templates/dev-plan-template.md` in full, including its frontmatter (`feature`, `dd_link`, `figma_link` carried over from the feature analysis, `author`, `status: draft`, `date`).
4. Decompose the approach into `templates/task-breakdown-template.md` rows — each task small enough for a single `/implement-task` run, each with explicit acceptance criteria.
5. Leave `status: draft` in the dev plan's frontmatter — do not mark it `approved`. A human reviews and flips that status before `/implement-task` work begins.
