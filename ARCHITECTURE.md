# Solution Architecture

This document contains the principles shared by every solution shape. The
copied `SHAPE.md` contains the responsibilities and delivery gate for the
selected application, service, automation, integration, or system. Read
`LIFECYCLE.md` first for the template's entry, Adoption responsibility, and
exit.

## Start with sufficient context

Code and frameworks come after business understanding and architecture. Before
implementation, find the answers to:

1. Why is a maintained technical intervention justified?
2. Which outcome should change, and what is the current baseline?
3. Which users, workflow, or system are affected?
4. Who owns data, identity, process, deployment, and operations?
5. Which rules, examples, and exceptions matter to the first slice?
6. What is the smallest independently valuable slice?
7. What will prove technical acceptance and early adoption?
8. What is explicitly deferred?

The answers may live in an AIOS task, board issue, README, decision record,
architecture map, customer conversation, or another useful artifact. Do not
create a mandatory brief or duplicate context only to satisfy this template.
When a material answer is missing, ask one precise question and continue from
the existing source of truth.

## What AI-native means

AI-native does not mean AI-only or maximally autonomous. It means:

- context and intent are explicit
- people and coding agents can understand the system
- architecture and ownership precede implementation
- boundaries, trust decisions, and acceptance are inspectable
- deterministic code owns critical rules and side effects
- tests and operational evidence replace confidence theatre
- humans can operate, recover, change, and hand over the result
- runtime AI, models, databases, and vendors remain deliberate choices

Every repository should be coding-agent-ready. Runtime agent capability is
optional and requires a separate product need.

## Choose one solution shape

| Shape       | Primary responsibility                                      |
| ----------- | ----------------------------------------------------------- |
| Application | A human-facing product surface or routed experience         |
| Service     | Bounded domain behavior exposed through a stable interface  |
| Automation  | Triggered or scheduled orchestration of an explicit process |
| Integration | A connection and translation boundary between system owners |
| System      | Cross-repository architecture, ownership, and operations    |

Use the smallest shape that owns the outcome. A business may need several
repositories with different shapes. Do not collapse them into one codebase
when their owners, deployment lifecycle, trust boundary, or failure modes
differ.

Application solutions additionally choose one runtime profile:

- static Pages
- Cloudflare native
- Convex
- external backend

The profile is an implementation decision inside the Application shape. Other
shapes do not inherit frontend assumptions.

## Common architecture principles

### One owner per responsibility

Name the authoritative owner of:

- identity and authorization
- durable data and schemas
- workflows and schedules
- domain rules
- external delivery
- deployment and secrets
- incidents and recovery

A consumer must not become the implicit owner of a responsibility merely
because it reads the data. Prefer an explicit contract to a second database,
auth system, conversation store, or workflow engine.

### Capabilities appear only when needed

Do not install persistence, auth, billing, queues, analytics, AI, search,
storage, or an agent runtime before a slice needs them. A missing folder or
dependency is correct when the solution has no responsibility for it.

### Stable boundaries, replaceable infrastructure

- Runtime-validate every external input.
- Return stable solution-owned output shapes.
- Keep vendor and storage document types inside their adapters.
- Put deterministic business rules outside framework code.
- Isolate external SDKs and network calls.
- Use interfaces only when they protect a real boundary.
- Preserve useful platform semantics instead of abstracting them away.

### Explicit trust

For every externally reachable operation, document:

- actor and caller
- authorization and tenant scope
- accepted input and returned output
- secret and credential owner
- rate, timeout, and retry behavior
- idempotency and concurrency where side effects exist
- audit requirements

Fail closed when identity, policy, signature, or scope cannot be proven.

### Lowest useful autonomy

Separate deterministic steps from model-driven judgment. Use the lowest
autonomy that delivers the outcome:

1. human-operated
2. AI-assisted
3. agent-operated
4. automation-first

Consequential, costly, privileged, or difficult-to-undo actions need
target-specific approval, recovery, and audit. Never let a model improvise
financial, access, or destructive policy.

## Repository responsibility

Every repository needs a short statement of:

- what it owns
- what it consumes
- what it explicitly does not own
- its public contracts
- its runtime and deployment owner
- where incidents are triaged

Documentation-only and workflow repositories are valid. Do not add application
code to make a repository look substantial.

## Delivery and operations

The minimum evidence depends on the selected shape, but every shipped solution
must have:

- a testable done-state
- validation appropriate to its contracts
- a repeatable release or change procedure
- health or freshness evidence appropriate to its runtime
- observable failures
- a recovery, rollback, replay, or disable path
- a named operational owner
- no committed secrets

Use test-driven development for domain rules, contracts, authorization,
side-effecting behavior, migrations, incident fixes, and other deterministic
logic. Supplement automated tests with real-runtime or end-to-end evidence
where mocks cannot prove behavior.

## Existing solutions

Do not rebuild a working system for architectural symmetry. Establish current
owners, user journeys, contracts, deployment, and evidence first. Add one
boundary or outcome at a time, keep old owners available during verification,
and replace a subsystem only when a measured requirement justifies migration
and rollback work.

## Completion gate

Before declaring a slice complete:

- the intended outcome and acceptance criteria are met
- the selected shape still matches the responsibility
- existing owners were reused rather than duplicated
- external inputs and outputs are validated
- trust and side effects are explicit
- relevant checks pass
- the runtime behavior was verified where practical
- failures and skipped evidence are stated
- operations and handover remain understandable
