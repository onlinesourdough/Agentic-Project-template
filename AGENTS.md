# Solution-template

Build the smallest independent technical solution that creates the intended
outcome and can be understood, operated, recovered, and handed over by its
owner.

## Start

1. Read the request, README, and relevant canonical context.
2. Confirm that this repository should own an independent lifecycle.
3. Preserve resolved upstream intent. Run `spec-solution` to resolve only the
   project-local technical contract.
4. For a new or materially changed technology decision, run
   `.agents/skills/choose-technology/SKILL.md` after the contract. A working
   stack bypasses it when the change does not materially alter technology.
5. Build, verify, review, and ship only within the granted authority.

Ask one question only when a missing decision would materially change the
solution. Inspect repository truth before asking for facts it already contains.

## Route

| Work | Skill |
| --- | --- |
| Technical scope, boundaries, proof, or contracts | `.agents/skills/spec-solution/SKILL.md` |
| New or materially changed technology decision | `.agents/skills/choose-technology/SKILL.md` |
| Implementation | `.agents/skills/build-solution/SKILL.md` |
| Correctness, security, simplicity, and proof review | `.agents/skills/review-solution/SKILL.md` |
| Authorized delivery, deployment, activation, or recovery | `.agents/skills/ship-solution/SKILL.md` |
| Periodic repository health | `.agents/skills/audit-solution/SKILL.md` |
| A concrete specialist capability gap | `.agents/skills/manage-skills/SKILL.md` |

Keep one persistent goal across Spec, Build, Review, revisions, and authorized
Ship. Do not create lifecycle ceremony for a small mechanical change.

The public path is `spec-solution` → materially unchanged existing stack directly to
`build-solution`; or, for a new or materially changed technology decision,
`choose-technology` → optional `manage-skills` for a proven specialist gap →
`build-solution`.

## Inputs

- AIOS may provide resolved business context, outcome, proof, and authority.
- Design-template may provide an approved visual handoff.
- Existing code, a brief, conversation, issue, or README may provide standalone
  context.

Copy only the context the project needs. The solution repository becomes
canonical for its technical truth and never depends on AIOS or Design-template
at runtime.

## Engineering rules

- Give every responsibility and source of truth one owner.
- Prefer one deployable unit before adding a network boundary.
- Keep framework and vendor details at the edges of stable capability logic.
- Validate external input and enforce authorization and irreversible policy on
  a trusted server or worker boundary.
- Make retried effects idempotent; bound reads, timeouts, retries, concurrency,
  and cost.
- Keep secrets and private data out of code, logs, exports, and client builds.
- Add dependencies, databases, queues, containers, observability, and runtime AI
  only for demonstrated responsibilities.
- Preserve rollback, replay, disable, restore, reconciliation, or export as the
  risk requires.
- Keep README and operational truth current with behavior.

## Before completion

- Verify intended behavior through its real interface.
- Run affected format, lint, type, test, build, contract, and security checks.
- Check relevant failure, denial, duplicate, and recovery behavior.
- Review the diff for accidental complexity and stale truth.
- State unavailable evidence and remaining risk.

Never claim a test, deployment, migration, or runtime path passed without
reading its result.
