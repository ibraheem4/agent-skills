---
name: implement-story
description: Implement an approved, bounded software-delivery work order in the correct repository and isolated worktree, preserving unrelated changes and producing verification evidence for review. Use when acceptance criteria, modification points, scope, and authority are sufficiently clear; do not use for open-ended exploration, product decisions, release publication, merge, deployment, or other consequential external actions.
---

# Implement story

Implement the smallest complete change that satisfies a ready work order. Treat the work order as the scope contract and current repository evidence as the source of implementation truth.

## Entry gate

Require:

- an observable outcome and acceptance criteria;
- a resolved target repository and applicable instructions;
- known modification points or a completed orientation map;
- explicit ownership of files and mutable systems;
- resolved material product, architecture, and safety decisions.

If these are missing, use `$shape-work` or `$repo-orient` instead of guessing.

## Workflow

1. Read applicable `AGENTS.md`, authority documents, the work order, and the orientation map. Confirm current branch and worktree state.
2. Preserve unrelated user changes. Use the Harness-provided isolated worktree when running under the Agent Harness; otherwise follow the repository's worktree and branch rules.
3. Reconfirm the active implementation path and affected consumers before editing. Do not rebuild a capability recorded in `registries/code-assets.yaml` without verifying and deliberately replacing the existing path.
4. Implement by responsibility: fix the authoritative data flow, shared contract, parent layout, component, service, or policy instead of adding repeated consumer patches.
5. Delete superseded local code only when all current consumers have migrated and the work order permits removal. Do not mix opportunistic cleanup into the story.
6. Add or update the smallest durable automated check for repeatable behavior. For UI changes, consume the shared component library and its semantic tokens rather than one-off styles.
7. Run targeted checks first, then the repository-required typecheck, lint, tests, or build in proportion to risk. Run `git diff --check` and inspect the complete scoped diff.
8. Do not commit, push, open a PR, merge, deploy, publish, or mutate production unless the user separately authorizes that action and the governing workflow permits it. Consequential actions always require an attributable human approval over the exact payload.
9. Hand the completed change to `$delivery-review`; do not self-certify it as release-ready.

## Implementation record

Return:

```yaml
status: complete | partial | blocked
work_order: identifier or summary
changed_files: []
behavior_delivered: []
checks:
 passed: []
 failed: []
 not_run: []
assumptions: []
remaining_risks: []
external_actions: []
handoff:
 next_skill: delivery-review
 review_focus: []
```

Never describe an unrun check or visually uninspected state as verified.
