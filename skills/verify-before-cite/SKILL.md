---
name: verify-before-cite
description: Use before following, citing, or handing on a plan, runbook, handoff or research doc — and before repeating a resource name, file path, role, ARN or command from one. Checks that what the document claims exists actually exists, so nobody debugs the wrong thing.
---

# Verify before you cite

## Overview

A document is a claim about the world, not evidence of it. Plans, runbooks and handoffs
routinely name files, roles and resources that are wrong or do not exist, and the citation
reads exactly like the truth. Two such documents each sent work in the wrong direction for
hours. Verify against the live thing before you follow it or repeat it.

## When to Use

- Before executing a runbook, migration plan or handoff someone else wrote
- Before repeating a path, role name, ARN, account id, port or command from a doc
- When asked to "review" a plan doc
- When a doc cites another doc as authoritative

## Core Process

### The two real cases

**The phantom playbook.** A task file, `tasks/32-aws-migration.md`, was named as
"the team's full playbook" and cited in five places — a handoff doc §5.6 plus `README.md`,
`CONTRIBUTING.md`, `SECURITY.md` and `docs/security-posture.md`, the last two as the
*definition of the pre-PHI gate*. It **has never existed** in any commit on any branch.
`git log --all -S'32-aws-migration'` returns only the commit that introduced the citation.

**The inverted correction.** A research doc "corrected" the OIDC deploy role name to
`gha-<scope>-deploy-<env>`. Live IAM says the convention is `gha-deploy-<scope>-<env>` — the original handoff
was right and the correction was the error. Copying it into a workflow gives an
`AssumeRoleWithWebIdentity` failure that reads like a trust-policy problem, so the
debugging goes somewhere else entirely.

**The pattern:** a confident correction is not evidence. A citation repeated five times is
not evidence. Only the live resource is.

### How to check

| Claim | Check |
|---|---|
| a file path | `git log --all -S'<basename>' -- .` and `git ls-files`. Absent from all history means it never existed — say so plainly |
| an IAM role / policy | `aws iam list-roles --profile <p>` filtered on the prefix |
| any AWS resource | a `describe`/`list`/`get` call. Never infer from a doc |
| a DNS record or zone | `dig`, and the actual Route53 hosted zone |
| a command | run it, or read the script it lives in |
| "X is documented in Y" | open Y |
| a port / service | `docker ps`, `lsof` — and remember the sandbox reports localhost closed |
| a green test or CI run | that it actually ran. A turbo summary must say `Cached: 0 cached`, and the log paths must name *this* checkout — otherwise it is a replay |
| a row count | the tenant scope. `FORCE ROW LEVEL SECURITY` returns 0 rows to the table owner, and a shared local DB's global counts are test fixtures |

Prefer read-only verification. When a task is explicitly read-only, every call must be a
`describe`/`list`/`get`: no commits, no pushes, no `terraform apply`, no edits.

### Reporting

- State plainly which claims you **verified** and which you are **inferring**. Unprompted.
- When unsure, flag **that specific line** rather than hedging everything around it.
- Name any check you skipped. Don't let silence imply green.
- When a doc is wrong, give the correction *and* the evidence — the command and its output.
- Do not make corrections the focus of a rewrite. A short §0 listing them, then the plan.
- If a cited artifact does not exist, say it never existed. Do not soften it into "I could
  not locate" — that sends the next person hunting.
- Record a verified correction as a memory so it is not re-derived.

## Common Rationalizations

| Excuse | Why It's Wrong |
|---|---|
| "It's cited in five places, it must exist" | All five can cite the same wrong source. Repetition is not corroboration |
| "The newer doc corrects the older one" | A confident correction is just as likely to be the error. Check the resource |
| "I couldn't locate it" | If it never existed, say that. Softening it sends the next person hunting |
| "The handoff says it's already deployed" | Then a `describe` call will agree. It takes seconds |

## Verification

- [ ] Every path, role, ARN, account id and port repeated from a document was checked live
- [ ] Claims are labelled verified or inferred, unprompted
- [ ] Any check skipped is named, not silently omitted
- [ ] A corrected claim ships with the command and its output
- [ ] An artifact that never existed is described that way, plainly
