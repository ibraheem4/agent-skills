# Agent Skills — Claude Code

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
