# Agent Skills

Reusable, tool-agnostic skills that encode senior engineering workflows for AI coding agents. Each skill is a structured process — not vague guidance — with clear activation conditions, step-by-step procedures, and verifiable exit criteria.

## Supported Tools

| Tool | Config File | Status |
|------|------------|--------|
| [Claude Code](https://claude.ai/code) | `CLAUDE.md` | Supported |
| [Codex](https://github.com/openai/codex) | `codex.md` / `AGENTS.md` | Supported |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `GEMINI.md` | Supported |
| [OpenCode](https://github.com/nicholasgriffintn/opencode) | — | Planned |

## Skills

Skills are organized by development phase:

### Define
- **[idea-refine](skills/idea-refine/)** — Expand, evaluate, and sharpen a raw idea into a concrete spec

### Plan
- **[planning-and-task-breakdown](skills/planning-and-task-breakdown/)** — Break work into small, shippable increments

### Build
- **[incremental-implementation](skills/incremental-implementation/)** — Build features in small, tested steps
- **[api-and-interface-design](skills/api-and-interface-design/)** — Design APIs and module interfaces

### Verify
- **[test-driven-development](skills/test-driven-development/)** — Write tests first, then make them pass
- **[debugging-and-error-recovery](skills/debugging-and-error-recovery/)** — Systematic diagnosis over guessing

### Review
- **[code-review-and-quality](skills/code-review-and-quality/)** — Multi-axis review with severity labeling
- **[security-and-hardening](skills/security-and-hardening/)** — OWASP-aligned security review
- **[code-health-and-maintainability](skills/code-health-and-maintainability/)** — Reduce complexity, remove dead code, improve names

### Ship
- **[git-workflow-and-versioning](skills/git-workflow-and-versioning/)** — Conventional commits, branching, and release
- **[shipping-and-launch](skills/shipping-and-launch/)** — Pre-launch checklist and go/no-go gates
- **[experimentation-and-feature-flags](skills/experimentation-and-feature-flags/)** — Controlled rollouts, A/B testing, kill switches

### Operate
- **[operational-excellence](skills/operational-excellence/)** — SLOs, alerting, runbooks, and postmortems
- **[observability-and-monitoring](skills/observability-and-monitoring/)** — Structured logging, RED metrics, distributed tracing
- **[graceful-degradation](skills/graceful-degradation/)** — Timeouts, circuit breakers, fallbacks for partial failure

### Document
- **[design-docs-and-adrs](skills/design-docs-and-adrs/)** — Architectural decisions documented before implementation

## Design Philosophy

1. **Process over prose** — Every skill is a step-by-step workflow, not a knowledge dump
2. **Anti-rationalization** — Each skill includes common excuses for skipping steps and why they're wrong
3. **Verifiable outcomes** — Exit criteria are observable and testable, not subjective
4. **Tool-agnostic core** — Skills work across any agent; tool-specific config is separate

## Quick Start

### Claude Code
```bash
# Add as a subtree or copy skills/ into your project
cp -r skills/ your-project/.claude/skills/
```

Skills referenced in `CLAUDE.md` are automatically available as slash commands.

### Codex
```bash
cp -r skills/ your-project/.codex/skills/
```

Reference skills in your `codex.md` or `AGENTS.md` instructions.

### Gemini CLI
```bash
cp -r skills/ your-project/.gemini/skills/
```

Reference skills in your `GEMINI.md` instructions.

## Skill Anatomy

Every skill follows this structure:

```
skills/skill-name/
  SKILL.md          # Main skill definition (required)
  frameworks.md     # Supporting frameworks (optional)
  references/       # Reference materials (optional)
```

Each `SKILL.md` contains:

1. **Frontmatter** — Name, description, activation trigger
2. **Overview** — What the skill does and why
3. **When to Use** — Triggering conditions and exclusions
4. **Core Process** — Sequential numbered workflow
5. **Common Rationalizations** — Excuses and rebuttals (table)
6. **Red Flags** — Observable anti-patterns
7. **Verification** — Testable exit criteria (checkboxes)

See [docs/skill-anatomy.md](docs/skill-anatomy.md) for the full template.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding new skills.

## License

MIT
