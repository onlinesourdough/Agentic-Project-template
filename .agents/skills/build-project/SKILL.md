---
name: build-project
description: Implement and verify a project-local technical change once scope, boundaries, and acceptance are clear. Continue through in-scope review fixes and keep affected documentation current.
---

# Project Build

Build the smallest complete artifact or behavior that can be verified through
its real interface, validator, plan, health check, or rehearsal.

If the intended behavior, boundary, or independent lifecycle is still
consequentially unclear, use `spec-project` first.

Work inside the existing lifecycle goal. Use the harness's matching persistent
goal/task state or explicit outcome contract. For an AIOS-originated worker,
keep its one bounded goal active across Build, Review feedback, permitted
revisions, and requested authorized Ship. Never open or complete a goal merely
because the lifecycle phase changed.

## Initialize without inventing a stack

Consume the Spec's resolved technology decision. A working stack goes directly
to Build when the change does not materially alter it. For a new or materially
changed decision, use the result from
[choose-technology](../choose-technology/SKILL.md); do not reopen selection.

For a fresh repository:

1. Make README project-specific before implementation.
2. Create an official framework scaffold in the repository root only when the
   selected shape and stack require one.
3. Preserve repository instructions and use one package manager and lockfile
   per ecosystem.
4. Do not create fake runtime code when an Automation, Integration, or System
   only needs a workflow export, configuration, contract, infrastructure,
   architecture decision, or runbook.

Adopt existing repositories in place without overwriting working structure or
technical truth.

## Keep documentation current

Documentation is part of every implementation result. Identify the README,
runbooks, instructions, skills, contracts, commands, configuration, operation,
recovery, and proof affected by the change. Update the canonical local source
in the same result when its truth changes; do not defer it to `audit-project`.
Verify local links and skill routes, and verify documented commands,
configuration, and interfaces against the repository and the checks that prove
them. For a mechanical change, a focused diff and affected check suffice; do
not produce a documentation inventory when no documented behavior changes.

## Work through complete results

Choose evidence for the behavior and risk. Reproduce a bug before fixing it;
keep a regression test when it protects meaningful behavior. Use a validator,
build, real interface, or rehearsal when a unit test would be artificial.
Run affected checks and the repository's required checks; inspect their actual
results. Do not require a failing test or new tests for mechanical edits.

A complete result may be code, a workflow, configuration, infrastructure,
a contract, or a runbook. Prove it through its actual interface; do not invent
runtime code or deployment for a documentation or operational artifact.

Continue through the required results until the whole requested outcome is
implemented and verified. Review each risky result at the useful checkpoint and
run the final repository-wide review. When an authorized implementation review
fails, fix the finding and repeat the affected checks instead of returning
routine repair work to the user.

## Preserve responsibility boundaries

Reuse existing owners and sources of truth. Keep deterministic domain rules
and irreversible policy separate from framework and vendor clients. Add a
layer or deployment boundary only for a demonstrated responsibility, such as
independent ownership, isolation, scaling, or recovery; do not manufacture
interfaces or pass-through repositories. Make retried side effects idempotent
and bound timeouts, retries, reads, and concurrency.

## Implement the proportional security contract

Implement only the protection resolved by Spec. Public and local-only Projects
do not gain authentication by default. For a protected boundary, prefer
maintained framework, identity-provider, or protocol primitives over custom
authentication or cryptography, and enforce authorization on the trusted
server or worker per action and resource.

- Fail closed in production when required security configuration is missing or
  invalid; startup or deployment validation must not silently disable the
  protection.
- Keep credentials, signing material, tokens, and session data out of source,
  client builds, logs, and unsafe exports.
- Validate external input and bound payload size, resource use, reads, retries,
  concurrency, and cost according to the interface's abuse risk.
- Make security-relevant failures visible through redacted, safe telemetry
  without disclosing credentials or unnecessary private data.
- If JWT was selected, use a maintained library and the Spec's configured
  algorithms, issuer, audience, time claims, key rotation, expiry, revocation,
  and replay controls. Do not create an ad-hoc token format.

Prove the relevant real boundary with a permitted request plus missing,
invalid, expired or replayed, and authenticated-but-forbidden cases as
applicable. Include a production-misconfiguration case when protection depends
on runtime configuration. Run relevant dependency, configuration, and static
checks that the selected stack supports.
Do not invent a universal scanner command.

For infrastructure and VPS work, document desired state, access and secret
ownership, health, patching, drift, and a reproducible rebuild or tested restore
path. When a step cannot be automated safely, provide an exact, reviewable
runbook.

Finish Build with a working repository, updated local truth, and exact evidence
for both behavior and affected documentation. Do not stop because one result
passed if more work remains. Keep the lifecycle goal active or paused for
Review; complete it only after the full requested outcome, including
authorized Ship when requested, has passed.
