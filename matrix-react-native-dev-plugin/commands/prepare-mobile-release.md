---
description: Validate that a mobile release is ready to ship.
argument-hint: [version]
---

Validate that the mobile app is ready to ship version `$ARGUMENTS`.

1. Apply the `rn-release-readiness` skill methodology via the `rn-release-engineer` and `rn-performance-reviewer` agents.
2. Walk and populate `templates/release-checklist-template.md` in full: version bump, changelog, native config diff, env vars per environment, store metadata, perf sign-off, QA sign-off, rollback plan.
3. Have `rn-performance-reviewer` provide the perf sign-off.
4. Produce a final go/no-go verdict.

An incomplete or unverifiable checklist item is a no-go by default — surface it to the human for a decision rather than waiving it yourself.
