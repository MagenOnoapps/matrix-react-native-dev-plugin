# Mobile Security Standards

## Purpose & Scope

These standards apply to all React Native app code reviewed by `rn-security-reviewer` via `/review-security` — JS/TS application code, native bridge modules, and build/manifest configuration. Categories loosely follow the OWASP Mobile Application Security Verification Standard (MASVS); see [References](#references). Each bullet below carries a stable ID so review findings can cite the exact rule they violate. This list is a baseline, not exhaustive — reviewers should use judgment for app-specific risk.

## Secrets & Credentials Management

- `SEC-SECRETS-1` No hardcoded API keys, tokens, passwords, or signing credentials in source files.
- `SEC-SECRETS-2` No secrets embedded in the bundled JS — the bundle is trivially reverse-engineerable, so anything baked in at build time (e.g. via `react-native-config`) must still be treated as public.
- `SEC-SECRETS-3` `.env` files (and any file holding real credentials) are `.gitignore`d; only `.env.example` with placeholder values is committed.
- `SEC-SECRETS-4` Any secret that reaches source control or a public branch is rotated immediately, not just removed from the diff.

## Secure Local Storage

- `SEC-STORAGE-1` Tokens, credentials, and PII are stored via Keychain (iOS) / Keystore-backed storage (Android) — e.g. `react-native-keychain` — never in plain `AsyncStorage`.
- `SEC-STORAGE-2` If `MMKV` or similar fast key-value storage is used for sensitive data, encryption is enabled explicitly (it is not on by default).
- `SEC-STORAGE-3` Redux/Zustand/etc. persisted state does not include tokens or PII unless the persistence layer itself is encrypted.
- `SEC-STORAGE-4` Temp files/caches created from sensitive downloads (documents, images with PII) are cleaned up after use.

## Network & Transport Security

- `SEC-NET-1` All network calls use HTTPS/TLS; no cleartext traffic exceptions (`android:usesCleartextTraffic`, `NSAppTransportSecurity` ATS exceptions) except for a documented, reviewed reason.
- `SEC-NET-2` Certificate/public-key pinning is applied on endpoints handling auth or sensitive financial/health data.
- `SEC-NET-3` No disabling of TLS certificate validation anywhere reachable from a production build path, including code gated by `__DEV__` or an env flag that could be misconfigured in prod.

## Authentication & Session/Token Handling

- `SEC-AUTH-1` Access/refresh tokens are stored per `SEC-STORAGE-1`, never in plain storage, logs, or URLs/query params.
- `SEC-AUTH-2` Token refresh handles expiry and failure without silently retrying indefinitely or falling back to an unauthenticated state that looks authenticated.
- `SEC-AUTH-3` Biometric auth (Face ID / Touch ID / BiometricPrompt) gates local access to an already-issued credential — it is not used as a substitute for server-side authentication.
- `SEC-AUTH-4` Logout clears all cached credentials, tokens, and sensitive in-memory/persisted state, not just navigation to a login screen.

## Deep Link & URL Scheme Validation

- `SEC-DEEPLINK-1` Deep link and universal link targets are validated/allowlisted before navigation — no navigating to an arbitrary URL taken directly from link params.
- `SEC-DEEPLINK-2` Deep link params are not trusted for auth or state changes without independent validation (e.g. a link should not be able to log a user in as someone else).
- `SEC-DEEPLINK-3` Android App Links / iOS Associated Domains are used (verified ownership) rather than unverified custom URL schemes where feasible, to reduce link hijacking risk.

## WebView Hardening

- `SEC-WEBVIEW-1` `originWhitelist` is restricted to known domains; it is not left as `*` for WebViews loading remote or user-influenced content.
- `SEC-WEBVIEW-2` `allowFileAccess` / `allowUniversalAccessFromFileURLs` (Android) are disabled unless there's a specific, documented need.
- `SEC-WEBVIEW-3` `injectedJavaScript` never concatenates unsanitized data (user input, deep link params, API responses) into the injected script string.
- `SEC-WEBVIEW-4` The JS-to-native bridge exposed to a WebView is minimized to only what that page needs.

## Input Validation at the Native Bridge

- `SEC-BRIDGE-1` Data crossing from JS into native modules (file paths, shell/DB queries, deep link params, clipboard/share-extension content) is validated/sanitized on the native side — native code must not implicitly trust JS input.
- `SEC-BRIDGE-2` User- or link-supplied strings are never interpolated directly into native SQL queries or file system paths.

## Third-Party SDK & Dependency Vetting

- `SEC-DEPS-1` New dependencies are checked for known CVEs (`npm audit`, or the CocoaPods/Gradle equivalent) before being added.
- `SEC-DEPS-2` SDKs requesting broad device permissions or with known data-collection behavior (ad/analytics SDKs) are scrutinized for what data they access and where it's sent.
- `SEC-DEPS-3` Security-sensitive libraries (auth, crypto, storage) are version-pinned rather than left on a floating range.

## Permissions (Least Privilege)

- `SEC-PERMS-1` Any new native permission (camera, location, contacts, microphone, etc.) is justified by an actual feature need in the same change.
- `SEC-PERMS-2` Permissions are scoped as narrowly as the platform allows (e.g. "when in use" location over "always").
- `SEC-PERMS-3` Runtime permission prompts include a clear rationale string explaining why the permission is needed.

## Anti-Tampering & Release Hardening (nice-to-have)

- `SEC-HARDEN-1` Release Android builds have ProGuard/R8 minification/obfuscation enabled.
- `SEC-HARDEN-2` Hermes is used as the JS engine baseline (bytecode is harder to reverse-engineer than raw JS).
- `SEC-HARDEN-3` Remote JS debugging is disabled in production builds.
- `SEC-HARDEN-4` Root/jailbreak detection is applied where the app's risk tier warrants it (e.g. handles payments or regulated data) — not required for all apps.

## Logging & Crash-Reporting Hygiene

- `SEC-LOG-1` No PII, secrets, or tokens are written to `console.log`, Flipper, or similar dev-time logging.
- `SEC-LOG-2` Crash reporter (Sentry/Crashlytics) breadcrumbs and payloads are checked for sensitive fields, which are redacted before being sent.

## References

- OWASP Mobile Application Security Verification Standard (MASVS) and the Mobile Application Security Testing Guide (MASTG) — the category groupings above map loosely to MASVS's storage, network, auth, and platform-interaction domains.
- This document is a living baseline; reviewers should flag standards gaps found during review rather than working around them silently.
