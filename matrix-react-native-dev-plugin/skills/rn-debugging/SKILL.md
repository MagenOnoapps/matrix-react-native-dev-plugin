---
name: rn-debugging
description: Methodology for root-causing bugs and reviewer feedback and applying a minimal fix. Used by /fix-review-comments via the rn-debugger and rn-feature-developer agents.
---

## Methodology

1. **Parse the review notes file** (`[review-notes-path]`) — identify which template produced it (code review, security review, or a plain bug report) so findings are read in their original structure.

2. **Group findings by severity** and address Blocking first, then Major. Minor/Nit are handled after, and explicitly deferred (not silently skipped) if scope/time doesn't allow.

3. **Reproduce and root-cause each finding before touching code.** Understand why the issue happened, not just where.

4. **Delegate the actual code change to `rn-feature-developer`**, passing along the standard ID the finding cited so the fix is written consistent with that standard rather than as an ad hoc patch.

5. **Re-verify the fix against the originating finding** — confirm the specific condition the reviewer flagged no longer holds, not just that the code compiles/runs.

6. **Note anything that couldn't be fixed as-is** (e.g. it needs a larger refactor than this pass allows) instead of forcing a fix that technically resolves the finding but violates another standard.
