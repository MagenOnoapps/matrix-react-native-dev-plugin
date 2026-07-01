---
name: rn-code-review
description: Methodology for reviewing React Native code changes against org standards. Used by /review-code via the rn-code-reviewer and rn-performance-reviewer agents and the code-review template.
---

## Methodology

1. **Resolve scope.** Use the file list/diff handed in by the caller. If this is a whole-repo audit rather than a diff review, state that mode explicitly at the top of the output.

2. **Triage changed files into standards-relevant buckets.** Map each changed file to zero or more of: `RN-*` (any component/hook/TS file), `API-*` (endpoint/service files), `STATE-*` (slices/selectors), `I18N-*` (files with user-facing copy), `A11Y-*` (screens/interactive components), `ARCH-*` (folder placement, layering), `NAV-*` (navigator/route files). Files matching no bucket are marked out of scope and skipped — keep the review free of manufactured noise, mirroring `rn-security-review`'s triage-and-skip step.

3. **`rn-code-reviewer` walks each bucketed file** against its standards section's checklist, recording pass / fail / not-applicable per bullet, noting the standard ID for anything that fails.

4. **`rn-performance-reviewer` independently audits the same scope** for the five performance concerns in its own process (re-renders, virtualization, JS-thread blocking, images, bundle size) — this step runs separately from step 3, not as a sub-step of it, so a perf-only change doesn't get miscategorized as a correctness finding.

5. **Merge both agents' findings into a single `templates/code-review-template.md`.** Do not produce two separate documents.

6. **Assign severity** using this rubric, consistent with the security lane:
   - **Blocking** — breaks functionality or violates a hard rule (e.g. a class component in new code, an untyped exported function, a missing `keyExtractor` causing incorrect list behavior).
   - **Major** — likely to cause a real bug or meaningfully hurts maintainability (e.g. business logic inside a component instead of a hook/service, a non-normalized error shape leaking to the UI).
   - **Minor** — a standards deviation without immediate functional risk (e.g. hardcoded copy instead of an i18n key, a missing memoized selector).
   - **Nit** — style/hygiene suggestion (e.g. inconsistent naming, a missing prop-typing default).

7. **Write concrete remediation per finding** — a specific fix pointer, not just a restatement that something is wrong.

8. **Cite the standard ID** for every finding so it traces back to the specific standards doc.

9. **Populate `templates/code-review-template.md` in full**, including explicit "None found" for sections with no issues, and an overall verdict (Approved / Approved with follow-ups / Blocked).

10. **Exclude security and out-of-scope performance findings.** Security issues defer to `rn-security-review`'s methodology; anything outside the five performance concerns above stays with `rn-code-reviewer`, not `rn-performance-reviewer`.
