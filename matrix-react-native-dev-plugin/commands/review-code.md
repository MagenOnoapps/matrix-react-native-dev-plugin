---
description: Review the current changes against the org's React Native standards.
argument-hint: [scope]
---

Review the current React Native changes for correctness, style, standards-adherence, and performance.

1. Resolve the review scope: if `$ARGUMENTS` is given, treat it as a path, branch, or PR reference to diff against; otherwise default to the current diff against the repo's base branch.
2. Load the relevant standards as the authoritative checklist: `standards/react-native-coding-standards.md`, `standards/api-service-layer-standards.md`, `standards/state-management-standards.md`, `standards/i18n-rtl-standards.md`, `standards/accessibility-standards.md`, `standards/architecture-principles.md`, and `standards/navigation-standards.md`.
3. Apply the `rn-code-review` skill methodology to the resolved scope, via the `rn-code-reviewer` agent (correctness/style/standards) and the `rn-performance-reviewer` agent (bundle size, re-renders, list virtualization, JS-thread blocking, image handling).
4. Have the agents populate `templates/code-review-template.md` in full and output the completed document.

This command is complementary to `/review-security`, not a replacement for it — a full Review-stage pass runs both. Do not duplicate security commentary here; that belongs to `/review-security`'s reviewer. Findings here are strictly correctness/style/standards/performance, cited against the standards listed above.
