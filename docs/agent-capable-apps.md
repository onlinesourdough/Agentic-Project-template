# Agent-Capable Applications

AI-native and agent-capable are related, but they are not the same decision.
Every application built with this template should be understandable and safe
for coding agents to work on. Only products with a real user need should expose
runtime capabilities to an agent.

The four application profiles still decide where the product runs and owns
data. This document adds an independent interaction choice: what, if anything,
an agent may do inside the product.

## Choose an interaction mode

Start with the least autonomous mode that delivers the outcome.

| Mode               | Agent role                                      | Human role                                     | Typical use                                 |
| ------------------ | ----------------------------------------------- | ---------------------------------------------- | ------------------------------------------- |
| Coding-agent-ready | Changes the codebase through the delivery loop  | Reviews and ships software                     | Every application                           |
| Agent-assisted     | Explains, drafts, compares, or recommends       | Decides and performs consequential actions     | Research, support, analysis, content drafts |
| Agent-operated     | Invokes a bounded set of application operations | Sets intent and approves sensitive changes     | Internal tools and focused product agents   |
| Automation-first   | Runs scheduled or event-driven workflows        | Configures, supervises, and handles exceptions | Repetitive operational work                 |

An application may use different modes for different capabilities. A read-only
analysis tool can be agent-operated while refunds remain human-operated.

Do not select an agent mode because a model or framework is available. Select
it when the mode reduces user effort without weakening control, traceability,
or recovery.

## The operation seam

When both people and agents need the same product behavior, define one
application-owned operation and expose it through the necessary surfaces. The
UI, HTTP API, background job, CLI, or agent tool should adapt to that operation
instead of reimplementing its rules.

An operation contract should make these properties visible:

```ts
type Actor =
  | { kind: "user"; id: string }
  | { kind: "service"; id: string }
  | { kind: "anonymous" };

type OperationContext = {
  actor: Actor;
  caller: "ui" | "api" | "agent" | "automation";
  tenantId?: string;
  requestId: string;
  idempotencyKey?: string;
};

type Operation<Input, Output> = (
  input: Input,
  context: OperationContext,
) => Promise<Output>;
```

This is a design shape, not a required framework or base class. In a small
application it may be a function. In a conventional backend it may sit in a
service. In Convex it may be a validated query, mutation, or action backed by
shared pure rules.

Keep product language stable across surfaces. If the UI calls an operation
“publish article,” the agent tool should not call the same behavior “sync
content” without a product reason.

## Context is a product contract

Do not make an agent scrape the visible interface to guess what the user is
working on. Project the smallest useful context explicitly:

- current route or workspace
- resource type and stable identifier
- current selection or filters
- user and tenant scope
- permitted operations
- relevant version or freshness timestamp

Context is untrusted input. Validate identifiers and reload authoritative data
inside the operation before making a decision. Never place session secrets,
private credentials, or an entire application state dump in model context.

## Select tools by user outcome

Not every button should become an agent tool. Expose a bounded operation when:

- it represents a meaningful user outcome
- its authorization decision is explicit
- its input and output can be runtime-validated
- its effect is testable and observable
- failure and retry behavior are understood
- the product can explain or recover from the result

Prefer a few outcome-level operations over a large catalog of low-level CRUD
tools. Keep deterministic calculations, policy decisions, access checks, and
irreversible side effects outside model reasoning.

## Trust requirements

Every agent-callable operation needs the same application controls as any
other caller, plus controls for nondeterministic execution.

### Identity and authorization

- Resolve the human or service actor independently of model-provided text.
- Record the calling surface separately from the actor.
- Enforce tenant and resource scope inside every operation.
- Give background agents scoped service identities, not a shared superuser.
- Deny access when identity, policy, or scope cannot be proven.

### Input and output validation

- Runtime-validate inputs at the operation boundary.
- Validate structured model output before it reaches domain logic.
- Return stable application DTOs rather than database or vendor documents.
- Treat retrieved content, web pages, files, and tool results as untrusted.

### Approval

Ask for approval at the last responsible moment when an operation is
consequential, outward-facing, costly, privileged, or difficult to undo.
Approval must name the actual effect and target. A generic “continue?” prompt
is not evidence of informed consent.

Do not add approval to every harmless read. Excessive prompts teach users to
approve without reading.

### Retries and concurrency

- Give side-effecting operations idempotency semantics.
- Define whether stale versions may be overwritten.
- Use optimistic concurrency or a version check when parallel work is possible.
- Make partial failure visible and resumable.
- Never let a model improvise retry rules for financial or destructive actions.

### Audit, observability, and analytics

Keep three questions separate:

1. **Audit:** who changed what, when, through which caller, and with what result?
2. **Agent observability:** which context, tools, model, latency, cost, and
   decisions produced the attempt?
3. **Product analytics:** did the capability help the user complete the job?

Redact secrets and unnecessary personal data. An audit trail should store
stable identifiers and outcomes; it does not need to preserve every private
prompt forever.

## Evaluation and release

Unit and integration tests prove deterministic boundaries. Agent evaluations
prove whether nondeterministic behavior is useful and stays within policy.

For each material agent capability:

1. Collect representative tasks, including ambiguous and adversarial cases.
2. Define observable success and forbidden outcomes.
3. Run deterministic contract, authorization, and idempotency tests first.
4. Run agent evaluations with disposable data and scoped credentials.
5. Require human review for a failed safety or acceptance criterion.
6. Monitor production outcomes and turn incidents into regression cases.

Candidate code and evaluation environments must not receive production
credentials. Fail closed when an evaluator, approval service, or policy check
is unavailable.

## Profile mapping

### Static Pages

A static build can be coding-agent-ready and may use browser-safe capabilities
over public data. It cannot safely own model API keys, secrets, paid
entitlements, privileged tools, or server-side agent execution. Add a real
backend profile before exposing those capabilities.

### Cloudflare-native

Keep operations in application services and expose selected operations through
Worker routes, queues, or scheduled handlers. Put model and external service
calls in adapters. Use D1, Durable Objects, Queues, or Workflows only when the
operation needs their persistence or coordination semantics.

### Convex

Use validated public functions as product boundaries and internal functions for
agent-inaccessible work. Put external model calls in actions, while mutations
record intent, enforce authorization, and schedule work. Keep pure evaluation
rules framework-free where practical.

### External backend

Make the HTTP contract the stable seam. The frontend, agent runtime, and
specialist service should share versioned DTOs or generated clients without
sharing infrastructure types. The external service owns its authorization,
idempotency, audit, and execution controls.

## First vertical slice

Add agent capability one outcome at a time:

1. Write the user outcome and choose an interaction mode.
2. Define a typed input, output, actor, and authorization decision.
3. Implement and test the operation without an agent.
4. Expose it through one human surface.
5. Project only the context required for that outcome.
6. Add the agent surface with the same operation.
7. Add approval, idempotency, audit, and evaluation according to risk.
8. Measure whether it removes work or merely adds novelty.

If the operation cannot be made safe and useful without broad authority, keep
it agent-assisted or human-operated.

This guide is framework-neutral. It does not require a particular agent
runtime, database, auth provider, model provider, or frontend framework.
