# API Service Layer Standards

## Purpose & Scope

These standards apply to how React Native app code talks to backend APIs, assuming Redux Toolkit Query (RTK Query) as the org's chosen data-fetching layer; see [References](#references). Each bullet below carries a stable ID so review findings can cite the exact rule they violate. This list is a baseline, not exhaustive — reviewers should use judgment for endpoints with unusual requirements.

## Endpoint Organization

- `API-ORG-1` One `createApi` slice per feature/domain (e.g. `ordersApi`, `usersApi`) — no single monolithic API slice covering the whole app.
- `API-ORG-2` Endpoints live alongside the feature they belong to (co-located with that feature's screens/components/store slice), not in a separate top-level `api/` dump.
- `API-ORG-3` Endpoint names describe the resource/action (`getOrderById`, `updateOrderStatus`), not the HTTP verb or URL shape.
- `API-ORG-4` Shared cross-feature concerns (auth headers, base URL, retry policy) live in one common `baseQuery`, not duplicated per feature slice.

## Tag-Based Cache Invalidation

- `API-CACHE-1` Every query that returns a list or entity declares `providesTags` scoped to that resource type (e.g. `{ type: 'Order', id }` plus a `{ type: 'Order', id: 'LIST' }` for the collection).
- `API-CACHE-2` Every mutation that changes a resource declares `invalidatesTags` matching the exact tags its change affects — avoid blanket-invalidating unrelated tag types just to be safe.
- `API-CACHE-3` Tag type names are declared centrally (the `tagTypes` array on the API slice) and reused consistently — no ad hoc string tags scattered across endpoint definitions.
- `API-CACHE-4` Optimistic updates (`onQueryStarted` cache patches) roll back on failure rather than leaving stale optimistic data in the cache.

## Base Query, Auth & Error Interceptor

- `API-BASEQ-1` A single shared `baseQuery` (typically `fetchBaseQuery` wrapped in a custom function) attaches the auth token to every request — individual endpoints never manually set the auth header.
- `API-BASEQ-2` The base query centrally handles `401`/token-expiry by triggering a refresh-and-retry flow once, not by having each endpoint's caller handle auth failure independently.
- `API-BASEQ-3` Non-auth error responses are normalized (see below) inside the base query, so every endpoint's `error` field has the same shape regardless of which backend service it hit.
- `API-BASEQ-4` Request/response logging in the base query never logs auth headers or tokens (ties to `SEC-LOG-1` in `mobile-security-standards.md`).

## Normalized Error Shapes

- `API-ERR-1` All endpoints surface errors in a single normalized shape (e.g. `{ status, code, message }`), not the raw `FetchBaseQueryError`/`SerializedError` union leaking into UI code.
- `API-ERR-2` UI components branch on the normalized `code`/`status`, never on parsing a raw error message string.
- `API-ERR-3` Network-level failures (no connectivity, timeout) are distinguished from server-returned error responses in the normalized shape, so the UI can show a retry affordance for the former and a message for the latter.

## References

- This document assumes RTK Query as the data-fetching layer; if a project uses a different library, `repo-analyst` should flag the mismatch before this standard is applied.
- This document is a living baseline; reviewers should flag standards gaps found during review rather than working around them silently.
