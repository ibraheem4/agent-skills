# Agent Skills — Claude Code

This repository contains reusable agent skills. Each skill in `skills/` encodes a senior engineering workflow with clear activation conditions, step-by-step processes, and verifiable exit criteria.

## How to Use

When a task matches a skill's "When to Use" conditions, load and follow the skill's process. Skills are in `skills/<skill-name>/SKILL.md`.

## Available Skills

- `/plan` — Break work into small, shippable increments
- `/spec` — Expand an idea into a concrete specification
- `/build` — Implement features in tested increments
- `/test` — Write tests first (TDD workflow)
- `/review` — Multi-axis code review
- `/ship` — Pre-launch checklist and release
- `/debug` — Systematic error diagnosis
- `/secure` — Security review and hardening
