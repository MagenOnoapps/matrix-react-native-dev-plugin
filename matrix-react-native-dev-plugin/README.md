# matrix-react-native-dev-plugin

A [Claude Code](https://claude.com/claude-code) plugin encoding Ono Apps' React Native SDLC workflow: a seven-stage pipeline that takes a feature from analysis to release, with a human approval gate between every stage.

Each stage is a slash command backed by a dedicated skill and specialized subagents (architect, developer, code/performance/security reviewers, debugger, release engineer). Every stage reads the approved template output of the previous one, so the whole pipeline stays traceable from feature request to shipped release.

## Install

From the marketplace:

```
/plugin marketplace add MagenOnoapps/onoapps-claude-plugins
/plugin install matrix-react-native-dev-plugin@onoapps-claude-plugins
```

Local (for development of the plugin itself):

```bash
claude --plugin-dir /path/to/onoapps-claude-plugins/matrix-react-native-dev-plugin
```

## Quick start

Taking a feature from idea to release:

```
# 1. Analyze the feature against the repo's actual conventions
#    (optionally include a Figma link — required if the feature has new UI)
/analyze-feature Add biometric login to the auth flow — design: https://figma.com/file/...

#    → produces a feature analysis with status: proposed
#    → a human reviews it and flips status to approved

# 2. Turn the approved analysis into a dev plan + task breakdown
/create-dev-plan biometric-login

# 3. Implement tasks from the breakdown, one at a time
/implement-task T1

# 4. Review the changes (defaults to the current diff against the base branch)
/review-code
/review-security

# 5. Address the review findings from the filled-in review notes
/fix-review-comments docs/reviews/biometric-login-code-review.md

# 6. Hand off to QA
/create-dev-qa-notes biometric-login

# 7. When the release train is ready, validate shippability
/prepare-mobile-release 2.14.0
```

The pipeline is deliberately gated: `/create-dev-plan` refuses to run on a feature analysis still marked `proposed`, and `/implement-task` only works from an approved plan — a human signs off between every stage.

## Commands

| Command | Arguments | What it does |
|---|---|---|
| `/analyze-feature` | feature description or DD link (± Figma link) | Detects the repo's actual stack and conventions, then proposes a technical approach; output starts as `status: proposed` |
| `/create-dev-plan` | feature name | Turns an **approved** feature analysis into a dev plan + task breakdown |
| `/implement-task` | task id | Implements a single task from the approved breakdown |
| `/review-code` | scope (optional) | Reviews changes for correctness, style, standards-adherence, and performance; defaults to the current diff against the base branch |
| `/review-security` | scope (optional) | Reviews changes for mobile security risk against the org's security standards |
| `/fix-review-comments` | review-notes path | Addresses outstanding findings from a completed review notes file |
| `/create-dev-qa-notes` | feature name | Writes QA handoff notes for the completed feature |
| `/prepare-mobile-release` | version | Validates that the mobile app is ready to ship the given version |

## Pipeline

| Stage | Command | Skill | Agent(s) |
|---|---|---|---|
| 1. Analyze | `/analyze-feature` | `rn-repo-analysis` | `repo-analyst`, `rn-architect` |
| 2. Plan | `/create-dev-plan` | `rn-dev-planning` | `rn-architect` |
| 3. Implement | `/implement-task` | `rn-feature-implementation` | `rn-feature-developer` |
| 4. Review | `/review-code`, `/review-security` | `rn-code-review`, `rn-security-review` | `rn-code-reviewer`, `rn-performance-reviewer`, `rn-security-reviewer` |
| 5. Fix | `/fix-review-comments` | `rn-debugging` | `rn-debugger`, `rn-feature-developer` |
| 6. QA handoff | `/create-dev-qa-notes` | `rn-testing-and-qa-handoff` | `rn-feature-developer` |
| 7. Release | `/prepare-mobile-release` | `rn-release-readiness` | `rn-release-engineer`, `rn-performance-reviewer` |

`repo-analyst` has no dedicated command — it's invoked by other agents/skills as a first step.

Each stage after Analyze reads its input from the previous stage's approved template output: `/analyze-feature` → `feature-analysis-template.md` → `/create-dev-plan` → `dev-plan-template.md` + `task-breakdown-template.md` → `/implement-task` → … → `/prepare-mobile-release`.

## Standards and templates

Every agent works against the org's written standards rather than assumed defaults:

- **`standards/`** — architecture principles, React Native coding standards, state management, navigation, API service layer, mobile security, accessibility, and i18n/RTL standards. Reviews cite standard IDs in their findings.
- **`templates/`** — one structured template per pipeline artifact: feature analysis, dev plan, task breakdown, code review, security review, QA handoff, and release checklist. Stages communicate exclusively through these filled-in templates.

## Safety hooks

Three hooks are always active while the plugin is installed:

| Hook | What it does |
|---|---|
| `protect-secrets` | Blocks any file write/edit that would introduce a hardcoded secret (API keys, tokens, private keys) |
| `require-approval-before-code` | Forces a human-approval prompt before any code file is written or edited — even in auto-approve modes; docs and config pass through untouched |
| `block-main-branch-changes` | Blocks file changes while checked out on `main`/`master`, enforcing a feature-branch workflow |

## MCP servers

- **`figma`** (`https://mcp.figma.com/mcp`) — the hosted Figma MCP server, used by `/analyze-feature` and `/implement-task` to pull design context, screenshots, and variables from a Figma file. Each developer authenticates once via OAuth on first use (`/mcp` to check connection status).

## Plugin internals

| Piece | Contents |
|---|---|
| `commands/` | The eight pipeline slash commands listed above |
| `skills/` | One skill per stage: `rn-repo-analysis`, `rn-dev-planning`, `rn-feature-implementation`, `rn-code-review`, `rn-security-review`, `rn-debugging`, `rn-testing-and-qa-handoff`, `rn-release-readiness` |
| `agents/` | `repo-analyst`, `rn-architect`, `rn-feature-developer`, `rn-code-reviewer`, `rn-performance-reviewer`, `rn-security-reviewer`, `rn-debugger`, `rn-release-engineer` |
| `standards/` | Eight org standards documents cited by reviews |
| `templates/` | Seven structured templates the stages communicate through |
| `hooks/` | The three safety hooks listed above |
