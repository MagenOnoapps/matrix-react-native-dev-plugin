---
description: Turn a feature analysis into a dev plan and task breakdown.
argument-hint: [feature-name]
---

Turn a feature analysis into an approved-ready dev plan.

1. Take `$ARGUMENTS` as the feature name, following on from a prior `/analyze-feature` run for the same feature.
2. Apply the `rn-dev-planning` skill methodology via the `rn-architect` agent to turn that analysis into a technical approach.
3. Populate `templates/dev-plan-template.md` in full, including its frontmatter (`feature`, `dd_link`, `author`, `status: draft`, `date`).
4. Decompose the approach into `templates/task-breakdown-template.md` rows — each task small enough for a single `/implement-task` run, each with explicit acceptance criteria.
5. Leave `status: draft` in the dev plan's frontmatter — do not mark it `approved`. A human reviews and flips that status before `/implement-task` work begins.
