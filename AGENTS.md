# Agent Skills — Codex

Behavioral guardrails for AI coding agents. Each skill in `skills/` targets a specific agent failure mode with a step-by-step process grounded in industry practices (Microsoft, Google, Stripe, Netflix).

## Critical Skills (apply always)

- **scope-discipline** — Do exactly what was asked. No extra features, no unsolicited refactors
- **incremental-implementation** — Never write more than 50 lines without running tests

## Available Skills

| Skill | Agent Failure Mode It Fixes |
|-------|----------------------------|
| scope-discipline | Adding features nobody asked for |
| incremental-implementation | Writing 500 lines without testing |
| test-driven-development | Shipping code without tests |
| debugging-and-error-recovery | Retrying the same failing approach |
| code-review-and-quality | Missing subtle bugs in generated code |
| security-and-hardening | Introducing injection vectors, hardcoded secrets |
| shipping-and-launch | Leaving debug logs and TODOs in code |
| graceful-degradation | Not handling dependency failures |
| code-health-and-maintainability | Over-engineering with premature abstractions |
| api-and-interface-design | Inconsistent interfaces, poor error design |
