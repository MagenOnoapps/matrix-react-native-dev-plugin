# React Native Coding Standards

## Purpose & Scope

These standards apply to all React Native application code reviewed by `rn-code-reviewer` via `/review-code` — components, hooks, utilities, and TypeScript types across the app. They cover general code shape and hygiene; API service layer, state management, i18n/RTL, and accessibility have their own dedicated standards documents. Each bullet below carries a stable ID so review findings can cite the exact rule they violate. This list is a baseline, not exhaustive — reviewers should use judgment for cases not covered here.

## TypeScript Strictness

- `RN-TS-1` `strict` mode is enabled in `tsconfig.json` and not locally weakened per-file.
- `RN-TS-2` No `any` without an inline comment justifying why a more specific type isn't feasible; prefer `unknown` plus a narrowing check when the type genuinely can't be known upfront.
- `RN-TS-3` Exported functions and hooks have explicit return types — don't rely on inference across a module boundary.
- `RN-TS-4` No `as` type assertions to force a mismatched shape past the compiler; fix the underlying type instead, or narrow with a type guard.

## Functional Components & Hooks

- `RN-FC-1` No class components in new or modified code — functional components with hooks only.
- `RN-FC-2` Reusable stateful logic is extracted into a custom hook rather than duplicated across components.
- `RN-FC-3` Hooks follow the Rules of Hooks (no conditional/looped hook calls); the `eslint-plugin-react-hooks` rules are not disabled to work around a violation — the code is restructured instead.
- `RN-FC-4` Side effects live in `useEffect`/`useLayoutEffect` (or an equivalent data-fetching hook) with a complete, accurate dependency array — not in the render body.

## Naming & File Conventions

- `RN-NAME-1` Components are PascalCase and the file name matches the component name (`UserAvatar.tsx` exports `UserAvatar`).
- `RN-NAME-2` Hooks are camelCase and prefixed `use` (`useUserProfile`), matching the Rules of Hooks lint requirement.
- `RN-NAME-3` One component per file; helper sub-components that aren't reused elsewhere may be co-located but are not separately exported from the module's public surface.
- `RN-NAME-4` Non-component utility/helper files are camelCase and named for what they export, not generically (`formatCurrency.ts`, not `utils.ts`, unless the file is a genuine barrel/index).

## Prop Typing

- `RN-PROPS-1` Component props are typed via a named `interface` or `type`, not inline object literals or untyped destructuring.
- `RN-PROPS-2` Default prop values are supplied via default parameters in the function signature, not the legacy `defaultProps` static.
- `RN-PROPS-3` Optional props are marked `?` rather than typed as `T | undefined` and required everywhere they're passed.
- `RN-PROPS-4` Callback props are typed with explicit parameter and return types (`onSelect: (id: string) => void`), not `Function` or untyped arrow types.

## Lint & Format

- `RN-LINT-1` ESLint and Prettier both pass with zero warnings before a change is sent for review.
- `RN-LINT-2` Inline lint-rule disables (`eslint-disable-next-line`) carry a comment explaining why the rule doesn't apply here — a bare disable is not acceptable.
- `RN-LINT-3` Formatting is applied via the project's configured formatter, not manual spacing — no diffs that are pure reformatting mixed into a functional change.

## References

- This document is a living baseline; reviewers should flag standards gaps found during review rather than working around them silently.
- See `standards/api-service-layer-standards.md`, `standards/state-management-standards.md`, `standards/i18n-rtl-standards.md`, and `standards/accessibility-standards.md` for domain-specific rules that sit alongside these general coding standards.
