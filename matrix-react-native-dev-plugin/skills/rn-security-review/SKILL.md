---
name: rn-security-review
description: Methodology for reviewing React Native code changes against mobile security standards. Used by /review-security via the rn-security-reviewer agent and the security-review template.
---

## Methodology

1. **Resolve scope.** Use the file list/diff handed in by the caller. If this is a whole-repo audit rather than a diff review, state that mode explicitly at the top of the output.

2. **Triage changed files into sensitive-surface buckets.** Map each changed file to zero or more categories from `standards/mobile-security-standards.md`: secrets, storage, network, auth/session, deep links, WebView, native bridge, third-party dependencies/manifest, permissions, logging. Files matching no bucket are marked out of scope for security and skipped — this keeps the review free of manufactured noise.

3. **Walk each bucketed file against its standards section's checklist**, recording pass / fail / not-applicable per bullet, and noting the standard ID (e.g. `SEC-STORAGE-1`) for anything that fails.

4. **Run a secrets pass as defense-in-depth.** The `protect-secrets.json` hook only blocks content Claude itself writes/edits during the session — it doesn't scan pre-existing diff content. Re-check the diff for the same secret patterns (hardcoded keys, tokens, private key blocks, `.env` value leakage) independently of whether the hook fired.

5. **Assign severity** using this rubric:
   - **Blocking** — exploitable right now (e.g. a hardcoded production secret, disabled TLS validation).
   - **Major** — exploitable under plausible conditions (e.g. unencrypted token storage, unvalidated deep link driving navigation).
   - **Minor** — a defense-in-depth gap (e.g. missing cert pinning on a non-critical endpoint).
   - **Nit** — hygiene/hardening suggestion (e.g. missing ProGuard rule, verbose non-sensitive logging).

6. **Write concrete remediation per finding** — a specific fix pointer (e.g. "use `react-native-keychain` instead of `AsyncStorage` for this token"), not just a restatement that something is insecure.

7. **Cite the standard ID** for every finding so it traces back to `mobile-security-standards.md`.

8. **Populate `templates/security-review-template.md` in full**, including explicit "None found" for sections with no issues rather than omitting them, so the sign-off has a complete audit trail.

9. **Exclude non-security findings.** Anything about style, correctness, or performance is out of scope for this skill — defer to `rn-code-review`'s methodology instead, per `rn-security-reviewer`'s boundary rules.
