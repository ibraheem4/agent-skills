---
name: skill-authoring
description: Create, revise, and govern reusable skills for an agent Harness, company operations, software-delivery teams, and vertical teams. Use when adding a  skill, changing a skill contract, splitting a large skill into references or scripts, assigning a maturity level, defining side-effect or approval boundaries, or validating the  skill library.
---

# Skill authoring

Build a skill as a versioned operating contract, not a persona or a long prompt. Preserve one clear capability, one ownership boundary, and one verifiable output.

## Workflow

1. Read the applicable repository instructions and the workspace's own authority files — whose **invariants** are the real constraints and say so. Treat those and the uniform human gate as constraints, not background material. Note which authority files are frozen reference rather than live.
2. Inspect adjacent skills and `skills/catalog.yaml`. Extend an existing capability when the trigger, owner, and output are substantially the same; create a new skill when any of those boundaries differ.
3. Write 2–4 concrete trigger examples and at least two non-triggers. Use them to define the frontmatter description.
4. Complete `references/skill-contract.md` before scaffolding. Resolve side effects, authority sources, evidence, and handoff ownership before writing workflow prose.
5. Initialize new skills with the current Codex `skill-creator` script. Keep frontmatter to `name` and `description`; generate `agents/openai.yaml` with the supported generator.
6. Keep `SKILL.md` procedural and under 500 lines. Put detailed domain rules in directly linked `references/`, deterministic repeated work in tested `scripts/`, and output material in `assets/`.
7. State exactly what the skill may change. Require an attributable human approval over the exact payload before live money movement, external publishing, binding commitments, production deployment, destructive provider changes, or another consequential external action.
8. Define a structured output that the next agent can consume without reconstructing the conversation. Include verified, unverified, blocked, and approval-required states.
9. Update `skills/catalog.yaml`, run the upstream quick validator, then run `scripts/validate-library.py`.
10. Forward-test complex or operational skills on a realistic task before treating them as stable. Do not allow the test to perform live consequential actions.

## Maturity

- **L1 procedure:** concise instructions; appropriate for judgment-heavy, read-only work.
- **L2 domain-backed:** conditional references hold substantial contracts or knowledge.
- **L3 deterministic:** tested scripts or templates handle repeatable fragile work.
- **L4 operational:** authorization, persisted state, recovery, independent verification, and tests protect external mutation.

Use the lowest level that safely solves the task. Do not add scripts or state merely to make a skill look complete.

## Composition rules

- Keep agents and skills separate: the agent owns a role; the skill supplies a capability.
- Keep orchestration in team templates or the Harness. Do not encode an entire fixed agent pipeline inside each capability.
- Make handoffs explicit through artifacts such as a work order, orientation map, implementation record, review report, readiness verdict, or decision record.
- Refer to living authority at its canonical path instead of copying company decisions into multiple skills.
- Keep review skills read-only. Use an implementation skill for approved fixes.
- Keep discovery free of mutation. A repository orientation must not quietly become implementation.

## Output

Report the skill name, owner, triggers, non-triggers, maturity, allowed side effects, approval boundary, resources, output contract, validation, and catalog entry.

## Resources

- Read `references/skill-contract.md` whenever creating or materially changing a skill.
- Run `scripts/validate-library.py [skills-directory]` after the upstream validator.
