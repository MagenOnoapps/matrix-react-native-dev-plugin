---
name: rn-release-readiness
description: Methodology for validating a mobile release is ready to ship. Used by /prepare-mobile-release via the rn-release-engineer and rn-performance-reviewer agents and the release-checklist template.
---

## Methodology

1. **Resolve the version.** Use the `[version]` given to `/prepare-mobile-release`.

2. **Verify version bump & changelog.** Confirm `package.json`/native version and build numbers were bumped for this release, and a matching changelog entry exists describing what's shipping.

3. **Diff native config.** Compare `Info.plist`, `AndroidManifest.xml`, `build.gradle`, and entitlements against the last release. Every change must be attributable to a reviewed PR — an unexplained native config diff is a blocker, not a note.

4. **Confirm env vars per environment.** Check that dev/staging/prod env vars are set for anything the release needs, and that none of them are real secrets committed to the repo — cross-reference `standards/mobile-security-standards.md`'s `SEC-SECRETS-*` rules.

5. **Check store metadata.** Note any app/Play store listing changes (screenshots, description, release notes, permission declarations) that ship with this version.

6. **Get perf sign-off.** Pull `rn-performance-reviewer`'s findings (bundle size delta, re-renders, virtualization, JS-thread, images) for changes going into this release.

7. **Get QA sign-off.** Pull the completed `qa-handoff-template.md` for every feature going into this release; a feature without QA handoff notes is a blocker.

8. **Write a rollback plan.** Concrete steps to pull this release if needed — revert commit/tag, halt a staged store rollout, reverse any backend/migration dependency.

9. **Populate `templates/release-checklist-template.md` in full** and render a final Go / No-Go verdict, listing every blocking gap by name if No-Go.
