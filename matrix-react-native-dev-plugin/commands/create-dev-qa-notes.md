---
description: Write QA handoff notes for a completed feature.
argument-hint: [feature-name]
---

Write QA handoff notes for the completed feature named in `$ARGUMENTS`.

1. Resolve `$ARGUMENTS` as the feature name; gather what was implemented for it (task breakdown, implementation summary, standard IDs applied) from the Implement stage's output.
2. Apply the `rn-testing-and-qa-handoff` skill methodology via the `rn-feature-developer` agent.
3. Have the agent populate `templates/qa-handoff-template.md` in full — including the i18n/RTL and accessibility check sections, citing the actual `I18N-*`/`A11Y-*` standard IDs that were applied during implementation rather than a generic checkbox.
4. Output the completed QA handoff document.

If no record of what was implemented for this feature can be found, say so explicitly rather than guessing at test steps.
