---
name: rn-feature-implementation
description: Methodology for implementing a planned task in a React Native codebase per org standards. Used by /implement-task via the rn-feature-developer agent.
---

## Methodology

1. **Resolve the task.** Look up `[task-id]` in the current `templates/task-breakdown-template.md` output — description, files touched, depends-on, size, acceptance criteria.

2. **Check dependencies.** Confirm every task listed in `depends-on` is already implemented; if not, stop and surface that instead of guessing at missing context.

3. **Identify applicable standards** for the files/surfaces the task touches:
   - Coding conventions: `standards/react-native-coding-standards.md`.
   - Data fetching: `standards/api-service-layer-standards.md`.
   - Shared state: `standards/state-management-standards.md`.
   - UI text/layout direction: `standards/i18n-rtl-standards.md`.
   - UI accessibility: `standards/accessibility-standards.md`.
   - Folder placement/dependency direction: `standards/architecture-principles.md`.
   - Screen/route changes: `standards/navigation-standards.md`.

4. **Implement the change**, applying each identified standard's checklist as you go rather than as an afterthought.

5. **Self-check against the task's acceptance criteria** line by line before reporting the task done.

6. **Record which standard IDs were applied** (e.g. `RN-TS-1`, `API-CACHE-2`) in the output summary — this is the trace `rn-code-reviewer`, `rn-performance-reviewer`, and the QA handoff skill rely on to know what to check without re-deriving it from scratch.
