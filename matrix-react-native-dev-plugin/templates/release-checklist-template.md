# Release Checklist

<!-- Version being released, platforms (iOS/Android), target date, release engineer (rn-release-engineer). -->
## Scope

<!-- Confirm the version bump (package.json, native version/build numbers) and a matching changelog entry exist for this release. -->
## Version Bump & Changelog

<!-- Diff of Info.plist / AndroidManifest.xml / build.gradle / entitlements against the last release, with each change explicitly reviewed — not just "no diff shown". -->
## Native Config Diff

<!-- Confirm required env vars are set per environment (dev/staging/prod) and that none are real secrets committed to the repo (see standards/mobile-security-standards.md, SEC-SECRETS-*). -->
## Env Vars Per Environment

<!-- App store / Play store listing metadata that changed: screenshots, description, release notes, permissions declarations. -->
## Store Metadata

<!-- Populated by rn-performance-reviewer: bundle size delta, re-render/virtualization/JS-thread/image findings, verdict. -->
## Perf Sign-off

<!-- Populated from a completed qa-handoff-template.md for every feature going into this release. -->
## QA Sign-off

<!-- Concrete rollback steps if this release needs to be pulled: revert commit/tag, store rollback/staged-rollout halt, any required backend/migration reversal. -->
## Rollback Plan

<!-- Overall verdict: Go / No-Go, with the specific blocking gaps listed if No-Go. -->
## Sign-off
