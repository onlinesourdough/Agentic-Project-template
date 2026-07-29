# Architecture Principles

Apply these as decision tests, not as layers to generate.

## Core

- Understand the outcome and constraint before choosing technology.
- Give every responsibility and source of truth one explicit owner.
- Keep high cohesion inside a boundary and low coupling across boundaries.
- Start with one deployable unit unless independent ownership, scaling,
  security, failure isolation, or release cadence justifies another.
- Prefer a direct function call before a network boundary.
- Keep domain policy and irreversible decisions deterministic.
- Keep frameworks, vendors, storage engines, and transport at the edge.
- Introduce an interface only for a real ownership, volatility, or test seam.
- Build or buy based on strategic ownership and total operating cost, not
  novelty.
- Measure before optimizing or scaling.
- Preserve human understanding, replacement, export, and recovery.

## Dependency direction

Use the smallest variation of:

```text
entrypoint or interface
  → application workflow
    → domain rules and contracts
      → adapters and runtime infrastructure
```

Simple solutions may collapse adjacent levels. Do not create empty folders or
one-method wrappers to imitate the diagram.

## Boundaries

Add a boundary when at least one is true:

- another owner or trust level controls the other side
- callers need a stable contract
- the capability deploys, scales, or fails independently
- data authority must remain separate
- a vendor is likely to change and the boundary contains that change

Do not add a boundary solely for “clean architecture,” future reuse, or a
framework convention.

## Data

- Name the authoritative source and schema owner.
- Keep temporary UI or process state close to its consumer.
- Use transactions for invariants inside one owner.
- Across owners, expect partial failure and use idempotency, acknowledgement,
  reconciliation, and observable state.
- Add persistence, caching, queues, and search only for measured needs.
- Define migration, retention, backup, restore, and export when durable state
  exists.

## Services and workflows

- A Service owns one reusable technical capability, not an arbitrary slice of a
  business noun.
- An Automation owns trigger, step order, credentials, retry, replay, error
  channel, activation, and kill switch.
- Let n8n orchestrate systems; keep substantial deterministic logic in code
  when it needs stronger tests, reuse, performance, or independent deployment.
- Never let a new Service silently become a system of record or workflow
  orchestrator.

## Diagrams

Use no diagram when prose is clearer. When relationships are hard to understand,
start with a C4-style system context and container view. Add a component,
dynamic, data, or deployment view only when it answers a real question.

Primary reference: [C4 model](https://c4model.com/diagrams).
