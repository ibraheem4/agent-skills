---
name: repo-orient
description: Perform read-only reconnaissance of a repository before planning, implementation, migration, refactoring, or architecture work. Use when the active code path, ownership, maturity, relevant files, existing capabilities, tests, or repository instructions are not already known; return a key-files map and do not edit the target.
---

# Repository orientation

Map the smallest reliable path from a requested outcome to the code and contracts that govern it. Do not implement, format, generate, commit, or change external state.

## Workflow

1. Resolve the exact repository, branch, and requested outcome. Record whether the worktree is clean without modifying it.
2. Read every applicable `AGENTS.md` and repository authority file before interpreting code. For organization-wide decisions read wherever they are recorded; for product questions read the product's own docs (and `AGENTS.md`, the same file under two names — edit both). `~/Projects/lucitra-core` is frozen reference and does not govern.
3. For an existing capability, search `{{code_asset_registry}}` before proposing anything new. Treat the registry as discovery memory, then verify its dated claims against the current checkout.
4. Trace the requested behavior vertically: entry point, UI or API, domain/service layer, persistence, integration, configuration, and tests. Skip irrelevant layers.
5. Classify similar implementations as:
 - `active`: reached by current routes, imports, configuration, or tests;
 - `partial`: executable pieces exist but the workflow is incomplete;
 - `specified`: documentation or types exist without a working path;
 - `legacy`: superseded but still present;
 - `generated`: derived output, not an editing authority;
 - `archive`: retained only for history;
 - `unclear`: evidence is insufficient.
6. Identify the canonical modification point and all consumers that could regress. Prefer shared contracts over page-level patches.
7. Identify commands that would verify a later implementation. Do not run expensive suites unless the user also requested diagnostics.
8. Stop when the main path, authoritative files, consumers, checks, and remaining unknowns are bounded. Ask only if an unresolved repository or authority choice would materially change the result.

## Output

Return:

1. **Repository facts:** path, branch, worktree state, applicable instructions.
2. **Findings:** current behavior and architecture, with evidence.
3. **Key files:**

 | File | Role | Relevant symbols or sections | Classification | Confidence |
 | --- | --- | --- | --- | --- |

4. **Change map:**

 | Change concern | Primary files | Consumers | Verification |
 | --- | --- | --- | --- |

5. **Risks and unknowns:** include stale registry claims, duplicate paths, migrations, secrets, generated files, and consequential-action boundaries.
6. **Handoff:** state whether the evidence is sufficient for `$shape-work` to finalize a work order.

Report only inspected facts and clearly labeled inference. Never claim a path is primary solely because its name looks current.
