# Contributing

## Adding a New Skill

1. Create a directory under `skills/` with kebab-case naming
2. Add a `SKILL.md` following the [skill anatomy template](docs/skill-anatomy.md)
3. Ensure all required sections are present:
   - Frontmatter with `name` and `description` (must start with "Use when")
   - Overview, When to Use, Core Process, Common Rationalizations, Verification
4. Update the skill list in `README.md`, `CLAUDE.md`, `AGENTS.md`, and `GEMINI.md`
5. Open a PR

## Quality Standards

- **Actionable** — Steps, not advice. "Do X" not "Consider X"
- **Verifiable** — Every exit criterion is testable
- **Concise** — SKILL.md under 200 lines. Use supporting files for reference material
- **Tool-agnostic** — Skills work across Claude Code, Codex, and Gemini CLI

## What to Avoid

- Duplicating content across skills (cross-reference instead)
- Vague guidance without concrete procedures
- Tool-specific instructions in skill files (put those in CLAUDE.md/AGENTS.md/GEMINI.md)
