---
description: Analyze a feature request against the current repo's conventions before planning it.
argument-hint: [feature-description-or-dd-link]
---

Analyze the feature described in `$ARGUMENTS` (a description or a DD link) against this repo's actual conventions.

1. Apply the `rn-repo-analysis` skill methodology.
2. Invoke the `repo-analyst` agent first to detect the repo's actual stack and conventions (navigation library, state-management library, monorepo tooling, folder structure, testing setup, lint/format config).
3. Invoke the `rn-architect` agent with those findings to propose a technical approach for the feature (screens, RTK slices/endpoints, navigation changes, folder placement) grounded in what was actually detected — not assumed defaults.
4. Output the proposed approach for the human to review. This is a proposal, not a plan — `/create-dev-plan` turns an approved approach into a formal dev plan and task breakdown.
