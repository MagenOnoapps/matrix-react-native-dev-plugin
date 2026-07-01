---
name: rn-repo-analysis
description: Methodology for analyzing a React Native repo's stack and conventions before proposing feature work. Used by /analyze-feature via the repo-analyst and rn-architect agents.
---

## Methodology

1. **Enumerate `package.json` dependencies** to identify the navigation library, state-management library, data-fetching layer, and test runner in use.
2. **Detect monorepo/workspace tooling** if present, and note package boundaries.
3. **Scan the folder structure** against `standards/architecture-principles.md`'s expected layering (`ARCH-LAYERS-*`, `ARCH-FOLDERS-*`). Note deviations as context, not violations — the repo may predate these standards.
4. **Note lint/format tooling** and any custom rule configuration.
5. **Hand the structured findings summary to `rn-architect`** — Navigation, State Management, Data Fetching, Testing, Monorepo/Workspace, Folder Structure, Lint/Format.
6. **`rn-architect` proposes an approach** (screens, state/data, navigation, folder placement) citing the relevant `ARCH-*`/`NAV-*` standard IDs, grounded strictly in what was detected in steps 1–4.
7. **Populate `templates/feature-analysis-template.md`** with the feature request, the findings summary, and the proposed approach, leaving `status: proposed` for a human to review and approve.
