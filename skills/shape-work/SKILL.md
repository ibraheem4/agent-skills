---
name: shape-work
description: Turn a product, engineering, research, or operations request into a bounded work order with outcome, acceptance criteria, non-goals, authority, risks, execution slices, verification, approvals, and handoffs. Use for ambiguous requests, feature intake, implementation planning, issue shaping, or refining a plan after repository orientation; do not implement the work.
---

# Shape work

Translate a request into an implementation-ready contract. Preserve unresolved product, architecture, safety, and acceptance decisions for the human owner.

## Modes

- **Intake:** use when repository evidence is not yet available. Define the outcome, user-visible acceptance, constraints, and reconnaissance questions. Mark the work order `draft`.
- **Finalize:** use after orienting in the repository — the active code path read, not assumed. Add modification points, bounded slices, checks, and owners. Mark the work order `ready` only when implementation can proceed without guessing a material decision.

## Workflow

1. Read the governing product and repository instructions. Do not turn stale wiki pages into requirements when a current authority conflicts.
2. State the user or business outcome in one sentence. Separate the requested result from a proposed implementation.
3. Define observable acceptance criteria, including relevant loading, empty, error, permission, responsive, recovery, and audit states.
4. State non-goals and preserved behavior. Prevent a small request from silently becoming a redesign, migration, or platform change.
5. List inputs, dependencies, affected systems, and the authority for each material constraint.
6. Identify side effects. Mark live money, external publishing, binding commitments, production deployment, and destructive provider changes as `human_approval_required` with an exact approval payload.
7. Use orientation evidence to split work by ownership. Each slice must have a result, allowed files or system scope, dependencies, and checks.
8. Route work to the smallest appropriate owner. Keep product decisions with the CEO/human owner, implementation with the Eng Lead, QA evidence with QA, and shipping with the Release Manager.
9. Stop and ask one focused question only when the answer changes outcome, safety, architecture, or acceptance. Otherwise choose the smallest reversible assumption and label it.

## Work-order contract

```yaml
status: draft | ready | blocked
outcome: observable result
owner: accountable role
authority: [source paths or records]
acceptance: [verifiable behaviors]
non_goals: [explicit exclusions]
assumptions: [labeled assumptions]
risks: [risk and mitigation]
approval:
 required: true | false
 payload: exact target, operation, parameters, risk, rollback
slices:
 - owner: role
 result: independently verifiable result
 scope: allowed files or systems
 depends_on: []
 checks: []
handoff:
 next_skill: implement | human-decision
 missing_evidence: []
```

Do not include speculative files in a ready work order. If the active code path is not known, orient in the repository first rather than guessing at files.
