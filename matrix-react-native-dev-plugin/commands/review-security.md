---
description: Review the current changes for mobile security risks against the org's security standards.
argument-hint: [scope]
---

Review the current React Native changes for mobile security risk.

1. Resolve the review scope: if `$ARGUMENTS` is given, treat it as a path, branch, or PR reference to diff against; otherwise default to the current diff against the repo's base branch.
2. Load `standards/mobile-security-standards.md` as the authoritative checklist.
3. Apply the `rn-security-review` skill methodology to the resolved scope, via the `rn-security-reviewer` agent.
4. Have the agent populate `templates/security-review-template.md` in full and output the completed document.

This command is complementary to `/review-code`, not a replacement for it — a full Review-stage pass runs both. Do not duplicate style, correctness, or performance commentary here; those belong to `/review-code`'s reviewers. Findings here are strictly security-related, cited against `mobile-security-standards.md`.
