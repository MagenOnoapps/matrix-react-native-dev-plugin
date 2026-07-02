# Ono Apps Claude Marketplace

A [Claude Code](https://claude.com/claude-code) plugin marketplace maintained by [Ono Apps](https://onoapps.com). It bundles the workflows we use to develop, review, and ship software with Claude Code — packaged as installable plugins with slash commands, skills, subagents, and safety hooks.

## Getting started

Add the marketplace once, then install any plugin from it:

```
/plugin marketplace add MagenOnoapps/onoapps-claude-plugins
/plugin install matrix-react-native-dev-plugin@onoapps-claude-plugins
/plugin install project-inspector@onoapps-claude-plugins
```

## Plugins

| Plugin | What it does |
|---|---|
| [`matrix-react-native-dev-plugin`](./matrix-react-native-dev-plugin/README.md) | Full React Native SDLC pipeline: analyze a feature, plan it, implement, review (code + security), fix, hand off to QA, and prepare the release. |
| [`project-inspector`](./project-inspector/README.md) | Read-only repository analysis that generates AI-ready project context: `CLAUDE.md`, a topic-indexed `AUDIT.md`, a `docs/project/` knowledge base, and approval-gated per-topic audits. |

---

### matrix-react-native-dev-plugin

Encodes a seven-stage React Native development lifecycle. Each stage is a slash command backed by a dedicated skill and specialized subagents (architect, developer, code/performance/security reviewers, debugger, release engineer). Every stage reads the approved output of the previous one, so the whole pipeline stays traceable from feature analysis to release.

**Pipeline at a glance:**

```
/analyze-feature ──► /create-dev-plan ──► /implement-task ──► /review-code
                                                                   │
/prepare-mobile-release ◄── /create-dev-qa-notes ◄── /fix-review-comments
```

**Example — taking a feature from idea to QA:**

```
# 1. Analyze the feature against the codebase (optionally with a Figma link)
/analyze-feature Add biometric login to the auth flow — design: https://figma.com/file/...

# 2. Once the analysis is approved, generate the dev plan and task breakdown
/create-dev-plan

# 3. Implement tasks from the plan, one at a time
/implement-task Task 1

# 4. Review the result
/review-code
/review-security

# 5. Address review findings, then hand off to QA
/fix-review-comments
/create-dev-qa-notes
```

The plugin also bundles the hosted **Figma MCP server**, so `/analyze-feature` and `/implement-task` can pull design context, screenshots, and variables straight from a Figma file (each developer authenticates once via OAuth — run `/mcp` to check connection status).

---

### project-inspector

Turns an existing repository into an AI-ready, audit-tracked project — **without ever touching source code**. A three-layer safety model (skill constraints, a read-only scanner subagent, and a PreToolUse hook that mechanically blocks destructive commands during inspection runs) keeps every run strictly read-only.

**Example — onboarding Claude to an unfamiliar repo:**

```
# 1. Scan the repo and generate CLAUDE.md + an audit topic index
/inspect

# 2. Build the docs/project/ knowledge base (overview, components, patterns, integrations)
/inspect-docs

# 3. Expand one audit topic into a detailed draft — one topic per run, developer-approved
/inspect-breakdown networking-layer

# 4. After reviewing the draft, approve it and sync findings into CLAUDE.md
/inspect-sync networking-layer

# Check progress at any time
/inspect-status
```

What lands in the target repo:

```
<repo-root>/
├── CLAUDE.md              # compact AI context, updated as audits are approved
├── AUDIT.md               # audit topic index with per-topic status
├── audits/<topic>/        # detailed per-topic audit files (Draft → Approved)
└── docs/project/          # overview, components, patterns, integrations
```

## Repository layout

Each plugin lives in its own directory with a `.claude-plugin/plugin.json` manifest; the marketplace itself is defined in [`.claude-plugin/marketplace.json`](./.claude-plugin/marketplace.json).

## License

[MIT](./LICENSE)
