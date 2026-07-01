# State Management Standards

## Purpose & Scope

These standards apply to Redux Toolkit usage in React Native app code reviewed by `rn-code-reviewer` via `/review-code`. Each bullet below carries a stable ID so review findings can cite the exact rule they violate. This list is a baseline, not exhaustive — reviewers should use judgment for app-specific structure.

## Slice Conventions

- `STATE-SLICE-1` Each feature/domain owns exactly one slice, created with `createSlice`; slices are not shared across unrelated features.
- `STATE-SLICE-2` Slice initial state is fully typed (no implicit `any`); the slice's state shape is exported for use in selectors and components.
- `STATE-SLICE-3` State is only ever mutated inside a slice's own reducers (Redux Toolkit's Immer draft) — never mutated directly from a component, thunk, or another slice.
- `STATE-SLICE-4` Async flows use `createAsyncThunk` (or RTK Query, per `standards/api-service-layer-standards.md`) rather than hand-rolled action-dispatching side effects.

## Memoized Selectors

- `STATE-SELECT-1` Derived/computed state (filtering, sorting, aggregating) is read through a `createSelector`-based memoized selector, not recomputed inline in a component's render body.
- `STATE-SELECT-2` Selectors live alongside their slice and are the only sanctioned way other code reads that slice's state — components do not reach into `state.feature.field` directly.
- `STATE-SELECT-3` Selector inputs are kept stable (avoid passing new object/array literals as selector args on every render) so memoization actually holds.

## Normalized Entities

- `STATE-ENTITY-1` Collections of records (lists of items with an id) are stored normalized via `createEntityAdapter`, keyed by id — not as a plain array requiring linear scans to find/update an item.
- `STATE-ENTITY-2` Relationships between entities are stored by id reference, not by nesting full copies of related records (avoids duplicated, divergent state).
- `STATE-ENTITY-3` Entity adapter selectors (`selectAll`, `selectById`, etc.) are used instead of re-implementing lookup/sort logic ad hoc.

## Local vs. Global State Boundary

- `STATE-BOUNDARY-1` State read/written by exactly one component or screen stays in local `useState`/`useReducer` — it does not default into the global store.
- `STATE-BOUNDARY-2` State goes into the global store only when it's shared across screens, must survive navigation/unmount, or is needed by multiple independent features.
- `STATE-BOUNDARY-3` Purely presentational/UI state (open/closed toggles, input focus, in-progress form values) stays local even if the containing feature has a slice for its domain data.

## References

- This document is a living baseline; reviewers should flag standards gaps found during review rather than working around them silently.
- See `standards/api-service-layer-standards.md` for server-state/cache conventions (RTK Query), which are handled separately from the client-state conventions above.
