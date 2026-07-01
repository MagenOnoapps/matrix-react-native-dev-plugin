# matrix-react-native-dev-plugin

Claude Code plugin encoding Ono Apps' React Native SDLC workflow.

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

Each stage after Analyze reads its input from the previous stage's approved template output: `/analyze-feature` → `feature-analysis-template.md` (status: proposed → approved) → `/create-dev-plan` → `dev-plan-template.md` + `task-breakdown-template.md` → `/implement-task` → ... → `/prepare-mobile-release`.

## Status

Complete. All standards, templates, agents, skills, commands, and hooks have real content.
