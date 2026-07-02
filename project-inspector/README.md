# project-inspector

A [Claude Code](https://claude.com/claude-code) plugin that turns an existing repository into an AI-ready, audit-tracked project. It generates `CLAUDE.md`, a topic-indexed `AUDIT.md`, a `docs/project/` knowledge base, and detailed per-topic audit files — one approval-gated step at a time, **without ever touching source code**.

Use it to onboard Claude (and new teammates) to an unfamiliar codebase: every Claude Code session sees the approved findings via `CLAUDE.md`, downstream tooling can read `AUDIT.md` + `docs/`, and product/spec teams can rely on `docs/project/overview.md` and `components.md` before writing specs.

## Install

From the marketplace:

```
/plugin marketplace add MagenOnoapps/onoapps-claude-plugins
/plugin install project-inspector@onoapps-claude-plugins
```

Local (for development of the plugin itself):

```bash
claude --plugin-dir /path/to/onoapps-claude-plugins/project-inspector
```

> After installing the plugin, remove any loose copies of `project-analysis` and `audit-breakdown` from `~/.claude/skills/` to avoid double-triggering.

## Quick start

Run these from the root of the repository you want to analyze:

```
# 1. Scan the repo and generate CLAUDE.md + an audit topic index (AUDIT.md)
/inspect

# 2. Build the docs/project/ knowledge base
/inspect-docs

# 3. Expand one audit topic into a detailed Draft — one topic per run
/inspect-breakdown networking-layer

# 4. Review the Draft yourself, then approve it and sync its findings into CLAUDE.md
/inspect-sync networking-layer

# Check progress at any time — topic table, counts, docs freshness
/inspect-status
```

Steps 3–4 repeat per topic: `/inspect-breakdown` never processes more than one topic per run, and `/inspect-sync` only acts on topics you explicitly name — the developer stays in the approval loop at every step.

## Commands

| Command | What it does |
|---|---|
| `/inspect` | Analyzes the repository and writes `CLAUDE.md` + a topic-indexed `AUDIT.md` |
| `/inspect-docs` | Generates the `docs/project/` knowledge base (overview, components, patterns, integrations); requires `CLAUDE.md` |
| `/inspect-breakdown [topic]` | Expands exactly one Pending Breakdown topic from `AUDIT.md` into a detailed Draft audit file |
| `/inspect-sync [topics]` | Marks the named developer-approved topics as Approved and syncs their HIGH/MEDIUM findings into `CLAUDE.md`'s managed blocks |
| `/inspect-status` | Prints the audit topic table, counts, and `docs/project/` freshness |

## Workflow

```
/inspect ──────────────► CLAUDE.md + AUDIT.md          (project-analysis)
     │
/inspect-docs ─────────► docs/project/                 (project-docs)
     │                     ├── overview.md      ← product/spec teams read this
     │                     ├── components.md    ← spec writing + design work
     │                     ├── patterns.md      ← Claude dev sessions
     │                     └── integrations.md
     │
/inspect-breakdown ────► audits/<topic>/<topic>-audit.md   (audit-breakdown)
     │                   one topic per run, Status: Draft
     │
  developer reviews the Draft
     │
/inspect-sync ─────────► AUDIT.md row → Approved            (audit-sync)
                         CLAUDE.md managed blocks updated
                         (Caution Areas + Important Files)

Downstream consumers:
  every Claude Code session → sees approved findings via CLAUDE.md
  any spec/design workflow  → can read docs/project/overview.md + components.md
```

## What lands in the target repo

```
<repo-root>/
├── CLAUDE.md              # compact AI context, updated as audits are approved
├── AUDIT.md               # audit topic index (| # | Status | Topic | Priority | File | Notes |)
├── audits/
│   └── <topic-slug>/<topic-slug>-audit.md
└── docs/project/
    ├── overview.md
    ├── components.md
    ├── patterns.md
    └── integrations.md
```

## Safety model

Three layers keep inspection runs strictly read-only:

1. **Prose constraints** — each SKILL.md declares allowed/forbidden commands and output contracts.
2. **Agent tool scoping** — the `repo-scanner` subagent is instructed read-only and returns digests, not mutations.
3. **Mechanical enforcement** — each skill creates `~/.claude/project-inspector.active` on start and removes it on finish. While that marker exists, a PreToolUse hook blocks `rm`, `mv`, `cp`, `touch`, `tee`, `sed -i`, state-changing `git` commands, and output redirection (except `/dev/null`). When no inspector skill is running, the hook allows everything — it never interferes with normal dev work.

On top of that, approval gates keep the developer in control: `audit-breakdown` processes one topic per run and stops; only the developer approves Drafts; `audit-sync` acts only on explicitly named topics.

## Plugin internals

| Piece | What it does |
|-------|--------------|
| `skills/project-analysis` | Step 1 — scans the repo (read-only), writes `CLAUDE.md` + `AUDIT.md` |
| `skills/project-docs` | Step 2 — writes the `docs/project/` knowledge base; requires `CLAUDE.md` |
| `skills/audit-breakdown` | Step 3 — expands exactly one Pending Breakdown topic into a Draft audit |
| `skills/audit-sync` | Step 4 — on explicit developer approval, marks topics Approved and syncs HIGH/MEDIUM findings into `CLAUDE.md`'s managed blocks |
| `agents/repo-scanner` | Read-only investigation subagent the skills delegate broad scans to |
| `hooks/` + `scripts/guard-readonly.sh` | PreToolUse hook that mechanically blocks destructive shell commands while an inspector skill is running |
| `commands/` | `/inspect`, `/inspect-docs`, `/inspect-breakdown [topic]`, `/inspect-sync [topics]`, `/inspect-status` |
