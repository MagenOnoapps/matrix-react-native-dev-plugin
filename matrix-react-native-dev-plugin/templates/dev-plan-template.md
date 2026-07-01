# Dev Plan Template

```yaml
feature: # feature name
dd_link: # link to the Detailed Design doc, if one exists
author: # rn-architect / human author
status: draft # draft | approved
date: # YYYY-MM-DD
```

<!-- 2-4 sentences: what is being built and why, in plain language. Carried over from the approved templates/feature-analysis-template.md this plan was built from. -->
## Overview

<!-- Screens, features, services/store slices, navigation, and native config this change touches. List by path/name, not prose. -->
## Impacted Areas

<!-- The chosen technical approach: architecture decisions, new/changed RTK slices or endpoints, navigation changes, folder placement. Cite standard IDs (ARCH-*, API-*, STATE-*, NAV-*) this approach follows. -->
## Technical Approach

<!-- Populated from templates/task-breakdown-template.md — embed the table here or link to it. -->
## Task Breakdown

<!-- Anything uncertain, any assumption that needs a human decision before /implement-task starts. Do not silently resolve these. -->
## Risks & Open Questions

<!-- How to revert this change if it ships broken: feature flag, revert commit, migration reversal, etc. -->
## Rollback Plan
