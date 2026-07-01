---
description: Address outstanding code review comments.
argument-hint: [review-notes-path]
---

Address outstanding review comments from a completed review notes file.

1. Read `$ARGUMENTS` as the path to a completed review notes file — typically a filled-in `templates/code-review-template.md` or `templates/security-review-template.md`, but any similarly structured findings document is acceptable.
2. Apply the `rn-debugging` skill methodology via the `rn-debugger` agent: group findings by severity, and for each Blocking or Major finding, reproduce and root-cause it before touching any code.
3. Hand each root-caused fix to the `rn-feature-developer` agent to implement — a minimal fix addressing the root cause, not a workaround or an unrelated rewrite.
4. Re-verify each fix against the standard ID the originating finding cited, confirming the violation is actually resolved.
5. If a finding can't be fixed as-is (e.g. it needs a larger refactor than this pass allows), say so explicitly rather than forcing a partial or incorrect fix.
