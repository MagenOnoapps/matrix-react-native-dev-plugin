---
name: rn-testing-and-qa-handoff
description: Methodology for writing QA handoff notes for a completed feature. Used by /create-dev-qa-notes via the rn-feature-developer agent and the qa-handoff template.
---

## Methodology

1. **Gather the source material.** Pull the feature summary from `rn-feature-developer`'s report for `[feature-name]`: what was built, which screens/flows it touches, and which standard IDs were applied (per `agents/rn-feature-developer.md`'s process — it reports applied IDs, not just "reviewed").

2. **Write test steps for a non-engineer.** Convert the implementation into numbered, step-by-step instructions someone with no codebase context can follow exactly — name the actual screen/button/label text, not component names.

3. **Call out edge cases explicitly.** List boundary/error conditions that were exercised (empty states, offline, slow network, permission-denied, validation errors) — don't assume QA will think to try them.

4. **State known limitations plainly.** Anything intentionally out of scope for this change gets a one-line reason and, if there's a follow-up task, a reference to it. Never omit this section to make the handoff look more complete than it is.

5. **Confirm i18n/RTL and accessibility were actually checked**, not just implemented. Cite the specific `I18N-*` and `A11Y-*` standard IDs `rn-feature-developer` applied, and whether the required manual walkthroughs (`I18N-TEST-1` bidirectional check, `A11Y-SR-1` screen reader check) were performed — a generic "looks fine" checkbox is not sufficient.

6. **Populate `templates/qa-handoff-template.md` in full**, including every section even when the answer is "None" (e.g. Known Limitations), so QA has a complete, unambiguous handoff.
