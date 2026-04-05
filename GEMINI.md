# Agent Skills — Gemini CLI

This repository contains reusable agent skills. Each skill in `skills/` encodes a senior engineering workflow with clear activation conditions, step-by-step processes, and verifiable exit criteria.

## How to Use

When a task matches a skill's "When to Use" conditions, load and follow the skill's process from `skills/<skill-name>/SKILL.md`.

## Available Skills

| Skill | Trigger |
|-------|---------|
| planning-and-task-breakdown | Breaking work into increments |
| idea-refine | Sharpening a raw idea |
| incremental-implementation | Building features step by step |
| test-driven-development | Writing tests first |
| code-review-and-quality | Reviewing code changes |
| shipping-and-launch | Pre-launch checks |
| debugging-and-error-recovery | Diagnosing errors |
| security-and-hardening | Security review |
