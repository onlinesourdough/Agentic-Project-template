# Agent Guide

This is the operational entry point for coding agents. The repository uses the
AI-native Solution Template: architecture and ownership come before code and
framework choices.

## Start with context

Before implementation, find:

1. evidence that a maintained technical intervention is justified
2. the intended outcome and current baseline
3. the users, workflow, or system being changed
4. the owners of data, identity, process, deployment, and operations
5. the rules, examples, and exceptions relevant to the first slice
6. the smallest independently valuable slice
7. the evidence that will prove technical acceptance and early adoption
8. the capabilities explicitly deferred

Context may live in a README, issue, decision record, architecture map, AIOS
task, optional `DESIGN.md`, or conversation. Do not impose a new brief format.
If a material answer is missing, ask one precise question.

## Read in this order

In an applied repository:

1. existing project context
2. `docs/solution-template/LIFECYCLE.md`
3. `docs/solution-template/ARCHITECTURE.md`
4. `docs/solution-template/SHAPE.md`
5. `docs/solution-template/PROFILE.md` for an Application
6. `docs/solution-template/APPLICATION_ARCHITECTURE.md` when its detail is needed
7. `docs/solution-template/DELIVERY.md`

In the source template repository, read `README.md`, `LIFECYCLE.md`,
`ARCHITECTURE.md`, `delivery/README.md`, the selected file under `shapes/`, and
an Application profile only when relevant.

## Working order

1. Confirm the entry gate and one solution shape.
2. Inspect existing owners, boundaries, baseline, and adoption evidence.
3. Choose the smallest valuable slice and explicit non-goals.
4. Write or update tests before testable behavior.
5. Add only capabilities required by the slice.
6. Keep product or domain rules outside framework entrypoints.
7. Run the checks appropriate to the runtime and shape.
8. Launch into the real workflow and observe the agreed evidence.
9. Verify failure paths, recovery, documentation, and handover.
10. Return learning to the relevant business or project context.

Do not create every possible folder. A missing layer is correct when the
solution has no responsibility for it.

## Solution shapes

- **Application:** a human-facing routed product surface.
- **Service:** a bounded API, worker, calculation, or domain capability.
- **Automation:** triggered or scheduled process orchestration.
- **Integration:** translation and delivery between authoritative systems.
- **System:** cross-repository architecture, ownership, and operations.

Only Applications select a runtime profile: static Pages, Cloudflare native,
Convex, or external backend.

## Core rules

- Reuse existing sources of truth.
- Give each responsibility one explicit owner.
- Runtime-validate every external input.
- Keep contracts stable and infrastructure details at the edge.
- Keep deterministic rules outside model and framework code.
- Add persistence, auth, billing, queues, analytics, and AI only when required.
- Keep secrets in runtime secret stores, never code or committed exports.
- Make side effects idempotent where retries or duplicate delivery are possible.
- Prefer bounded reads, explicit indexes, and checked-in migrations.
- Preserve export, recovery, rollback, and handover paths.
- Use the lowest autonomy that delivers the outcome.

## Shape boundaries

For Applications, keep routes thin, presentational components free of server
types, workflows in services or backend functions, and vendor calls in
adapters or integrations.

For Services, keep one domain responsibility, validate the public contract, and
make health, dependency failure, deployment, and rollback observable.

For Automations, document trigger, steps, owners, retries, duplicate handling,
replay, error channel, human control, and kill switch. Keep reusable domain
logic outside the workflow engine when it becomes complex.

For Integrations, preserve upstream and downstream ownership. Test auth,
mapping, timeouts, retries, acknowledgement, and reconciliation. Do not create
a new system of record.

For Systems, maintain architecture, ownership, decisions, topology, incidents,
and runbooks. Do not add fake runtime code to a documentation repository.

## Agent-capable behavior

Coding-agent-ready is the default. A runtime agent is a separate product
choice. When an operation is agent-callable:

- reuse the same application-owned operation as other callers
- validate input and structured output
- resolve actor, caller, authorization, and tenant scope outside model text
- project only necessary context
- require specific approval for consequential actions
- define idempotency, retry, recovery, audit, and evaluation

Critical policy, access, calculations, and irreversible effects remain in
deterministic code.

## Existing solutions

Do not rebuild a working system for symmetry. Establish its user journeys,
owners, contracts, deployment, tests, and incidents first. Add one outcome or
boundary at a time and replace a subsystem only when measured requirements
justify migration and rollback work.

## Evidence before completion

Run the repository's configured formatting, lint, type, test, build, contract,
workflow, or link checks. Use real-runtime, browser, replay, or end-to-end
evidence where mocks cannot prove behavior.

Before declaring completion:

- verify the intended artifact and outcome exist
- confirm the selected shape still fits
- confirm no existing owner was duplicated
- exercise relevant success and failure paths
- verify acceptance and adoption evidence in the real workflow
- confirm documentation, operations, recovery, and handover are sufficient
- document skipped or unavailable evidence
- keep feature branches targeted at `dev`; release changes move `dev` to `main`

Never claim a deploy, migration, test, scan, or release succeeded without
reading its result.
