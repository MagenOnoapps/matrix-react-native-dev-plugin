---
name: project-docs
description: >-
  Generates a docs/project/ knowledge base for an already-analyzed repository:
  overview.md (SPAC-team-friendly project overview), components.md (reusable
  component and screen inventory), patterns.md (state management, API,
  navigation, and styling conventions), and integrations.md (SDKs, APIs,
  external services — names only, no secrets). Requires CLAUDE.md to exist
  (run project-analysis first). Read by the dev-design-start skill and useful
  to the SPAC team before writing specs. Never modifies source code. Part of
  the project-inspector workflow.
---

# Project Docs Skill

## Purpose

Generate a `docs/project/` knowledge base that serves two audiences:

- **The SPAC team** — a plain-language overview and an inventory of existing screens/components, so specs reuse what exists instead of re-inventing it.
- **Claude in the dev cycle** — `dev-design-start` reads `docs/` when generating a DD; these files give it component, pattern, and integration facts without a fresh scan.

This skill is step 2 of the project-inspector workflow:

1. `project-analysis` creates `CLAUDE.md` and `AUDIT.md`.
2. `project-docs` creates the `docs/project/` knowledge base.
3. `audit-breakdown` expands one audit topic at a time.
4. `audit-sync` syncs approved audit findings into `CLAUDE.md`.

## Precondition: CLAUDE.md Must Exist

Before doing anything else, check the repository root for `CLAUDE.md`.

If it is missing, output:

> ❌ **CLAUDE.md not found.** This skill builds on the project context created by `project-analysis`.
> Please run `/inspect` (the project-analysis skill) first, then return here.

And stop. Do not continue.

## Output Contract

This skill generates only:

```text
<repository-root>/docs/project/overview.md
<repository-root>/docs/project/components.md
<repository-root>/docs/project/patterns.md
<repository-root>/docs/project/integrations.md
```

It must not create any other file under `docs/`, must not modify `CLAUDE.md` or `AUDIT.md`, and must never modify source code.

## Read-Only Enforcement

At the start of this skill, activate the plugin's read-only guard:

```bash
touch ~/.claude/project-inspector.active
```

At the end of this skill (including on abort or error), deactivate it:

```bash
rm -f ~/.claude/project-inspector.active
```

While the marker exists, the plugin's PreToolUse hook mechanically blocks destructive shell commands. As defense-in-depth: read-only inspection commands only; write files only through the Write/Edit tools, and only the four files in the Output Contract.

## Step 1: Ask the Developer

```text
I'll need a few details before generating the project docs:

1. Repository folder: What is the full path to the local repository?

2. Stack focus: Is this React Native, Native iOS/Android, or another stack?
   (This shapes what I inventory — screens, components, hooks, navigators, etc.)

3. Existing docs/project/ files: If any already exist, should I:
   - Overwrite — replace them entirely
   - Update — preserve useful existing structure and refresh content
   - Preserve — skip existing files
   - Version — save old copies as .bak before writing new ones

4. Source code safety: Should all source code remain completely unchanged?
   Default: Yes — I will only read files and only write the four docs/project/ files.
```

Wait for the developer's answers before proceeding.

## Step 2: Confirmation Summary

```text
Here's what I'm about to do:

- Repository: <path>
- Stack focus: <react-native / native / other>
- Existing docs handling: <overwrite / update / preserve / version>
- Source code: Read-only — no source files will be modified
- Read-only guard: The plugin hook will block destructive commands during this run

I will generate or update:
  ✓ docs/project/overview.md      — plain-language project overview for the SPAC team
  ✓ docs/project/components.md    — screen & reusable component inventory
  ✓ docs/project/patterns.md      — coding patterns and conventions
  ✓ docs/project/integrations.md  — SDKs, APIs, services (names only)

I will not modify:
  ✗ CLAUDE.md
  ✗ AUDIT.md
  ✗ any source code

Shall I proceed?
```

Only begin after explicit approval.

## Step 3: Read Existing Context First

Before scanning source, read what already exists — do not rediscover known facts:

1. `CLAUDE.md` — stack, structure, key modules, conventions.
2. `AUDIT.md` (if present) — architecture summary, module table, cross-cutting observations.
3. `audits/**/*.md` (if present) — verified findings about specific areas.

Use source inspection to fill the gaps these files leave, not to repeat them.

## Step 4: Targeted Inspection

**Delegate broad scans to the `repo-scanner` agent** with one focused brief per output file, for example:

- For `components.md`: "Inventory all screens, reusable UI components, and shared hooks in <repo>: name, path, one-line purpose. Note duplicates and deprecated-looking components."
- For `patterns.md`: "Identify the state management, data fetching, navigation, styling, error handling, and i18n patterns actually used in <repo>, with representative file paths."
- For `integrations.md`: "List third-party SDKs, backend APIs, auth, analytics, push, and payment integrations in <repo> from dependency manifests and imports. Names and purposes only — no keys or secret values."
- For `overview.md`: "Describe <repo> in plain language: what the app does, main features/screens, user roles, high-level architecture."

Rules:

- Do not fabricate. Mark unverifiable items as `Unknown`.
- Variable names only from env/sample files — never values.
- Prefer file paths and symbol names over vague descriptions.

## Step 5: Existing File Handling

| Developer choice | Action |
|------------------|--------|
| Overwrite | Replace the target files directly |
| Update | Preserve useful existing structure and refresh content |
| Preserve | Skip files that already exist |
| Version | Save `<file>.bak`, then write new files |

## Step 6: Generate the Four Files

Read each template (relative to this skill) before writing the corresponding file:

| Output | Template |
|--------|----------|
| `docs/project/overview.md` | `templates/overview.template.md` |
| `docs/project/components.md` | `templates/components.template.md` |
| `docs/project/patterns.md` | `templates/patterns.template.md` |
| `docs/project/integrations.md` | `templates/integrations.template.md` |

Writing rules:

- `overview.md` is written for non-developers: plain language, no code jargon, explain acronyms.
- `components.md` and `patterns.md` are written for developers and Claude: concrete paths and symbols.
- Adapt terminology to the stack (screens/navigators for RN, ViewControllers/Activities for native).
- Keep each file focused and scannable; tables over prose where the template uses tables.
- If a template section does not apply, write `Not applicable — <reason>` rather than deleting it.

## Step 7: Completion Report

After writing the files and removing the guard marker, report:

```text
Project docs complete.

Files written:
  ✓ <target-path>/docs/project/overview.md
  ✓ <target-path>/docs/project/components.md
  ✓ <target-path>/docs/project/patterns.md
  ✓ <target-path>/docs/project/integrations.md

These files are read by:
- dev-design-start (Step 3 reads docs/ when generating a DD)
- The SPAC team (overview.md and components.md before writing a spec)

Next steps:
1. Review the four files, especially components.md accuracy.
2. Run /inspect-breakdown to expand the first audit topic from AUDIT.md.
3. Re-run /inspect-docs after major refactors to keep the inventory fresh.
```

## Hard Constraints

- Never run without `CLAUDE.md` present — stop and point to `project-analysis`.
- Never modify source code.
- Only write the four files in the Output Contract.
- Never modify `CLAUDE.md`, `AUDIT.md`, or `audits/`.
- Never clone remote repositories.
- Never read or reproduce actual secret values; variable names only.
- Never reproduce credentials, tokens, private keys, or secrets from any file.
- Never proceed without explicit developer confirmation after the Step 2 summary.
- Never assume the current working directory is the target repository.
- Always remove `~/.claude/project-inspector.active` before finishing, even on abort.
