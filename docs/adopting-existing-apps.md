# Adopting Existing Applications

Do not rebuild a working application merely to make it look more AI-native or
agent-capable. Preserve proven behavior, identify the smallest missing
boundary, and migrate one user outcome at a time.

## Start with evidence

Before changing architecture, record:

- the user journeys that work today
- current owners of identity, data, workflows, and side effects
- deployment, rollback, health checks, and monitoring
- contracts with external systems
- test and browser coverage
- known incidents, bottlenecks, and expensive manual work

This baseline separates a real constraint from a stylistic preference. A
system with clear ownership, stable adapters, passing tests, and a reliable
release path already has valuable AI-native qualities even if it has no product
agent.

## Keep one owner for each responsibility

Do not create a second database, conversation store, auth system, or automation
engine solely for an agent. Reuse the authoritative owner through a stable
contract:

```text
human or agent surface
        |
        v
application-owned operation
        |
        v
existing service, adapter, or backend owner
```

The new surface may change. The ownership boundary should remain explicit.

## Incremental adoption path

### 1. Establish a read-only context handoff

Let the user carry current route, selected resource, filters, and stable
identifiers into the assistant or agent. The receiving system reloads
authoritative data and applies its own authorization.

This often delivers more value than embedding a new autonomous runtime because
the agent can understand the current job without duplicating the application.

### 2. Expose one safe read operation

Choose a read model that already has a clear owner and bounded result. Add
runtime validation, actor scope, freshness information, and an audit event when
the read is sensitive.

Do not start with raw database access or a general-purpose “run query” tool.

### 3. Add recommendations before writes

Have the agent produce a proposal, comparison, draft, or change plan. Let the
human execute the existing application action. Measure quality and failure
modes before giving the agent write authority.

### 4. Add one reversible write

Reuse the same application operation as the human surface. Add:

- explicit authorization
- target-specific approval when appropriate
- idempotency and concurrency rules
- an audit record
- a recovery or undo path
- deterministic tests and agent evaluations

### 5. Automate only proven repetition

Move from agent-operated to automation-first only after the bounded operation
is reliable, the exceptions are understood, and a human can supervise or stop
the workflow.

## Replacement gate

Replace an existing subsystem only when evidence shows that incremental
integration cannot meet a material requirement. Document:

- the unmet requirement
- the measured cost or risk of the current owner
- alternatives considered
- migration and rollback paths
- data export and compatibility needs

“A newer agent framework exists” is not by itself a replacement reason.

## Completion check

An existing application has adopted the template successfully when:

- its current profile and ownership boundaries are documented
- agents can find the relevant instructions without a giant context dump
- the first added capability reuses rather than duplicates product behavior
- identity, authorization, context, and side effects are explicit
- tests, evaluations, monitoring, and rollback match the capability risk
- users receive a measurable improvement

Use the companion Agent Capabilities guide to select the interaction mode and
design the operation boundary.
