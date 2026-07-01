# Architecture Principles

## Purpose & Scope

These principles apply to how React Native app code is organized and layered — reviewed by `rn-code-reviewer` via `/review-code` and used by `rn-architect` when proposing a technical approach via `/analyze-feature` and `/create-dev-plan`. Each bullet below carries a stable ID so review findings and design proposals can cite the exact rule they apply. This is a baseline, not exhaustive — reviewers should use judgment for app-specific structure inherited from `repo-analyst`'s detection.

## Layered Architecture

- `ARCH-LAYERS-1` The app is organized into three layers: screens → features → services/store.
- `ARCH-LAYERS-2` Screens are thin — they compose feature components, wire navigation params, and render layout. They do not contain business logic or direct data-fetching calls.
- `ARCH-LAYERS-3` Features hold the business logic for a unit of product functionality — hooks, selectors, and orchestration that decide what happens and when.
- `ARCH-LAYERS-4` Services/store hold data access and app-wide state — API clients, RTK Query endpoints, Redux slices, and persistence. They know nothing about which screen or feature is calling them.

## Feature-Folder Structure

- `ARCH-FOLDERS-1` A feature's screens, components, slice, API endpoints, and hooks are colocated under one feature folder rather than split across type-based folders (e.g. a global `components/`, `slices/`, `hooks/` at the top level).
- `ARCH-FOLDERS-2` Only genuinely cross-feature code (design-system primitives, shared utilities, app-wide store setup) lives outside a feature folder.
- `ARCH-FOLDERS-3` A feature folder's internal structure is consistent across features so navigating any feature follows the same pattern.

## Dependency Direction

- `ARCH-DEPS-1` Dependencies point downward only: screens may depend on features, features may depend on services/store — never the reverse.
- `ARCH-DEPS-2` A service/store module never imports from a feature or screen module.
- `ARCH-DEPS-3` Cross-feature imports (one feature depending directly on another feature's internals) are avoided — shared logic is pulled up into services/store or a shared module instead.

## Business Logic Out of Components

- `ARCH-LOGIC-1` Components render and dispatch — they do not contain business rules (validation logic, derived calculations, conditional flows tied to domain rules).
- `ARCH-LOGIC-2` Business rules live in hooks, selectors, or service functions that a component calls, so the logic is testable independent of rendering.
- `ARCH-LOGIC-3` Derived/computed values are produced by memoized selectors or hooks, not recomputed inline inside JSX or effects scattered across components.

## References

- This document is a living baseline; reviewers should flag structural gaps found during review rather than working around them silently.
- Where a repo's existing structure predates these principles, `repo-analyst`'s detected conventions take precedence for that repo until a migration is planned — see `standards/navigation-standards.md` for the same repo-detection-first approach applied to navigation.
