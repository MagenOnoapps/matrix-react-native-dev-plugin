---
name: project-analysis
description: >-
  Understands an existing local software repository and generates exactly two
  AI-ready project context artifacts: CLAUDE.md and AUDIT.md. AUDIT.md must be
  a concise audit topic index, not a detailed audit report. This is the first
  step in the project-inspector workflow. It identifies audit topics that can
  later be expanded one-by-one by the audit-breakdown skill. It does not create
  an audits/ directory, does not create detailed audit files, and does not
  create the docs/ knowledge base (that is the project-docs skill).
---

# Project Analysis Skill

## Purpose

Understand a local repository well enough to produce two AI-ready artifacts:

- `CLAUDE.md` — compact project context for Claude Code sessions.
- `AUDIT.md` — concise repository overview and audit topic index.

This skill is a reading and mapping skill. It is not a full audit, implementation review, refactor plan, task generator, or feature documentation generator.

This skill is step 1 of the project-inspector workflow:

1. `project-analysis` creates `CLAUDE.md` and `AUDIT.md`.
2. `project-docs` creates the `docs/project/` knowledge base.
3. `audit-breakdown` expands one audit topic at a time into `audits/<topic-slug>/`.
4. `audit-sync` syncs developer-approved audit findings back into `CLAUDE.md`.

## Output Contract

This skill generates only:

```text
<repository-root>/CLAUDE.md
<repository-root>/AUDIT.md
```

This skill must not create:

```text
<repository-root>/audits/
<repository-root>/audits/*.md
<repository-root>/docs/
```

Detailed audit files are created later by `audit-breakdown`, one topic at a time, only after developer approval. The `docs/project/` knowledge base is created only by the `project-docs` skill.

## Read-Only Enforcement

At the start of this skill, activate the plugin's read-only guard:

```bash
touch ~/.claude/project-inspector.active
```

At the end of this skill (including on abort or error), deactivate it:

```bash
rm -f ~/.claude/project-inspector.active
```

While the marker exists, the plugin's PreToolUse hook mechanically blocks destructive shell commands (`rm`, `mv`, `cp`, `sed -i`, `git commit`, output redirection, etc.). As defense-in-depth, still follow these rules yourself:

- Repository inspection must be strictly read-only: `ls`, `find`, `tree`, `cat`, `head`, `tail`, `grep`, `rg`, `wc`, `file`, `pwd`, and read-only `git` commands only.
- Prefer one command per action; avoid chaining unrelated commands with `&&`.
- Write files only through the Write/Edit tools, and only the two artifacts in the Output Contract.

## Core Workflow

1. Ask the developer for repository details.
2. Show a confirmation summary.
3. Wait for explicit approval.
4. Activate the read-only guard marker.
5. Inspect the repository using read-only commands only.
6. Generate `CLAUDE.md` from `templates/claude-md.template.md`.
7. Generate `AUDIT.md` from `templates/audit-md.template.md`.
8. Deactivate the read-only guard marker.
9. Report completion and recommend the next steps (`project-docs`, then `audit-breakdown`).

---

## Step 1: Ask the Developer

Before scanning, ask these questions exactly enough to resolve execution:

```text
I'll need a few details before starting the analysis:

1. Repository folder: What is the full path to the local repository you want analyzed?

2. Scope: Should I analyze the entire repository, or focus on a specific folder or module?

3. Existing artifacts: If CLAUDE.md or AUDIT.md already exist, should I:
   - Overwrite — replace them entirely
   - Update — preserve useful existing structure and refresh content
   - Preserve — skip existing files
   - Version — save old copies as .bak before writing new ones

4. Source code safety: Should all source code remain completely unchanged?
   Default: Yes — I will only read files and only write CLAUDE.md / AUDIT.md.
```

Wait for the developer's answers before proceeding.

---

## Step 2: Confirmation Summary

After the developer answers, show:

```text
Here's what I'm about to do:

- Repository: <path>
- Scope: <entire repo / specific folder>
- Existing artifacts: <overwrite / update / preserve / version>
- Source code: Read-only — no source files will be modified
- Read-only guard: The plugin hook will block destructive commands during this run

I will generate or update:
  ✓ CLAUDE.md — project context for AI-assisted development
  ✓ AUDIT.md  — repository overview and audit topic index

I will not create:
  ✗ audits/
  ✗ audits/*.md
  ✗ docs/ (created later by the project-docs skill)

Shall I proceed?
```

Only begin scanning after explicit approval.

---

## Step 3: Repository Inspection

Inspect the repository systematically and incrementally. Prefer small commands over long chained commands.

**For broad scans, delegate to the `repo-scanner` agent** (this plugin's read-only investigation subagent) instead of running dozens of inspection commands inline. Give it a focused brief (e.g., "map the top-level structure, entry points, and build commands of <repo>") and use its structured digest. This keeps the main conversation small and the inspection strictly read-only.

Collect only the information needed to populate the two templates:

- Project identity: README, package/build files, license.
- Tech stack: languages, frameworks, package managers, platforms.
- Build/run/test commands: scripts, Makefile, CI config, README instructions.
- Repository structure: top-level tree, key modules, entry points.
- Configuration: sample env files, config folders, feature flags; variable names only.
- Conventions: linters, formatters, code style, contribution docs.
- External integrations: SDKs, APIs, analytics, crash reporting, auth, payment, media, DRM, push, cloud providers.
- High-level risk signals: large files/classes, singletons/global state, cross-layer coupling, old dependencies, missing tests, missing CI, sensitive areas.

Do not write detailed findings during this step. Convert observations into audit topics for `AUDIT.md`.

---

## Step 4: Existing Artifact Handling

Before writing, check whether `CLAUDE.md` or `AUDIT.md` already exist.

| Developer choice | Action |
|------------------|--------|
| Overwrite | Replace generated artifacts directly |
| Update | Preserve useful existing structure and refresh content |
| Preserve | Skip existing files |
| Version | Save `CLAUDE.md.bak` / `AUDIT.md.bak`, then write new files |

When updating an existing `CLAUDE.md`, never delete or rewrite content inside `<!-- audit-sync:...:start -->` / `<!-- audit-sync:...:end -->` blocks — those are managed by the `audit-sync` skill.

Never modify source code.

---

## Step 5: Generate CLAUDE.md

Read `templates/claude-md.template.md` (relative to this skill) and generate `CLAUDE.md` from it.

Rules:

- Target 600–1000 words.
- Write for Claude Code as the reader.
- Prefer concise bullets and tables.
- Include practical commands when confidently detected.
- Mark uncertain items as `Unknown` rather than guessing.
- Keep the file useful as compact working context, not a long documentation report.
- Keep the `audit-sync` managed-block markers from the template in place, even when empty.

---

## Step 6: Generate AUDIT.md

Read `templates/audit-md.template.md` (relative to this skill) and generate `AUDIT.md` from it.

`AUDIT.md` must be small and must contain only audit topics, not detailed issue lists.

Audit topic rules:

- Each row represents one future detailed audit file to be created by `audit-breakdown`.
- Do not link to a future file before it exists.
- The `File` column must be `Not created yet` for every new topic.
- The `Status` column must be `Pending Breakdown` for every new topic.
- Include only topics that are meaningful for the inspected repository.
- Recommended length: 400–900 words excluding tables.

Use clear topic names, for example:

```text
Architecture
Managers and Singletons
Networking
Security
State Management
Player / Media
CI / Build
Dependencies
Testing
Dead Code / Legacy
Configuration
Data / Persistence
UI / Navigation
Analytics / Observability
```

Example topic row:

```markdown
| 1 | Pending Breakdown | Managers and Singletons | High | Not created yet | Large manager/singleton surface detected; should be broken down into a focused audit. |
```

---

## Step 7: Completion Report

After writing artifacts and removing the guard marker, report:

```text
Analysis complete.

Files written:
  ✓ <target-path>/CLAUDE.md
  ✓ <target-path>/AUDIT.md

Files intentionally not created:
  ✗ <target-path>/audits/        (audit-breakdown creates these)
  ✗ <target-path>/docs/project/  (project-docs creates these)

Summary:
- Tech stack: <brief>
- Architecture: <one sentence>
- Audit topics identified: <count>
- Recommended first breakdown topic: <topic>

Next steps:
1. Review CLAUDE.md and AUDIT.md.
2. Run /inspect-docs to generate the docs/project/ knowledge base.
3. Run /inspect-breakdown to expand the first audit topic.
```

---

## Hard Constraints

- Never modify source code.
- Only write `CLAUDE.md` and `AUDIT.md`.
- Never create `audits/` or `audits/*.md`.
- Never create `docs/` — that is owned by the `project-docs` skill.
- Never clone remote repositories.
- Never create feature docs, story docs, Jira tasks, implementation plans, or source-code patches.
- Never read or reproduce actual secret values from `.env` files; variable names only.
- Never reproduce credentials, tokens, private keys, or secrets from any file.
- Never proceed without explicit developer confirmation after the summary.
- Never assume the current working directory is the target repository.
- Never produce long detailed issue lists in `AUDIT.md`.
- Never link to audit files that do not exist yet.
- Never edit inside `audit-sync` managed blocks in an existing `CLAUDE.md`.
- Always remove `~/.claude/project-inspector.active` before finishing, even on abort.
