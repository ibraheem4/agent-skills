# agent-skills - Codex Instructions

Behavioral guardrails for AI coding agents. Each skill in `skills/` targets a specific agent failure mode with a step-by-step process grounded in industry practices (Microsoft, Google, Stripe, Netflix).

## Critical Skills (apply always)

- **scope-discipline** — Do exactly what was asked. No extra features, no unsolicited refactors
- **incremental-implementation** — Never write more than 50 lines without running tests

## Available Skills

- `/build` — Implement in small, tested increments
- `/scope` — Check your diff against the request — remove anything unsolicited
- `/test` — Write the failing test first (TDD, Beyonce Rule)
- `/debug` — Read the error. Hypothesize. Test one thing. Don't retry blindly
- `/review` — Two-pass review: design pass, then code quality
- `/secure` — Security checklist: inputs, auth, secrets, dependencies
- `/ship` — Pre-flight: tests pass, no secrets, no debug logs, no naked TODOs
- `/resilience` — Timeouts, circuit breakers, fallbacks for external calls
- `/cleanup-repo` — Prove commits are recoverable before deleting a repo (five checks, manifest, bundle)
- `/find-services` — Enumerate every spawner: launchd, native-messaging hosts, MCP configs
- `/triage-fleet` — Distinct-line collapse, then walk the dependency chain to the upstream cause
- `/reclaim-disk` — Caches before working trees; check for tracked files before deleting `dist/`
- `/work-summary` — Summarize a workspace's activity for any period and post it (profile-driven)

## Codex Operating Notes

- Treat this repository as independent from the surrounding `acme-dev` workspace unless a task explicitly spans multiple repos.
- Check `git status --short` before editing and do not revert user changes.
- Prefer the repo's documented commands and existing patterns over introducing new tooling.
- Run the smallest useful verification for the files changed and report anything that could not be run.
- Never commit secrets, environment files, tokens, or generated credentials.
