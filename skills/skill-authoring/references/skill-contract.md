# Skill contract

Complete this contract before implementing or materially changing a skill.

## Identity

- **Name:** lowercase, hyphenated, action-oriented.
- **Owner:** agent role or company function responsible for the result.
- **Outcome:** one independently valuable result.
- **Triggers:** 2–4 representative user requests.
- **Non-triggers:** neighboring requests owned elsewhere.

## Authority and scope

- **Authority sources:** canonical repository instructions, product contracts, schemas, or current external documentation.
- **Inputs:** artifacts and facts required to start.
- **Allowed reads:** repositories, systems, or datasets the workflow may inspect.
- **Allowed writes:** exact files, records, or systems the workflow may mutate.
- **Consequential actions:** external publishing, production deployment, money movement, binding commitments, destructive provider changes, or similarly irreversible effects.
- **Approval payload:** the exact target, operation, material parameters, risk, and rollback a human must approve.

## Execution

- **Procedure:** shortest sequence that produces the outcome.
- **Decision points:** ambiguous cases that require rules or escalation.
- **Idempotency:** what happens when the workflow is repeated.
- **Recovery:** how partial state is detected and safely resumed.
- **Resources:** references, scripts, or assets that prevent repeated rediscovery.

## Evidence and handoff

- **Checks:** objective verification required before success.
- **Evidence:** sources, commands, receipts, screenshots, or identifiers to retain.
- **Output:** structured artifact for the next owner.
- **Failure states:** blocked, unverified, denied, approval-required, or partial.
- **Next owner:** agent or skill that consumes the output.

## Maturity gate

- **L1:** procedure is sufficient.
- **L2:** domain references are necessary.
- **L3:** deterministic scripts or templates are necessary and tested.
- **L4:** external mutation requires state, authorization, recovery, independent verification, and tests.

Do not claim a level whose required controls are absent.
