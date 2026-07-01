---
description: Analyze a feature request against the current repo's conventions before planning it.
argument-hint: [feature-description-or-dd-link]
---

Analyze the feature described in `$ARGUMENTS` (a description or a DD link, optionally including a Figma link) against this repo's actual conventions.

1. Apply the `rn-repo-analysis` skill methodology.
2. Invoke the `repo-analyst` agent first to detect the repo's actual stack and conventions (navigation library, state-management library, monorepo tooling, folder structure, testing setup, lint/format config).
3. Invoke the `rn-architect` agent with those findings to propose a technical approach for the feature (screens, RTK slices/endpoints, navigation changes, folder placement) grounded in what was actually detected — not assumed defaults. If the feature involves new or changed UI and `$ARGUMENTS` didn't include a Figma link, `rn-architect` asks for one before proposing screens.
4. Populate `templates/feature-analysis-template.md` in full: the feature request, `repo-analyst`'s findings verbatim, `rn-architect`'s proposed approach, the `figma_link` used (if any), and any open questions/risks. Leave `status: proposed` in the frontmatter — do not mark it `approved`.
5. This is a proposal, not a plan. A human reviews the populated feature analysis and flips its status to `approved` before `/create-dev-plan` turns it into a formal dev plan and task breakdown.
