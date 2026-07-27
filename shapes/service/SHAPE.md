# Service Shape

Use this shape for a bounded API, microservice, calculation engine, worker, or
domain capability that has no primary human-facing UI.

## Responsibility

State one sentence describing what the service owns. Also state what remains
owned by upstream data producers, callers, workflow engines, and infrastructure.

Do not turn a bounded service into a general backend merely because new callers
appear.

## Contract

Document and test:

- input and output schemas
- authentication and authorization
- error shapes and status semantics
- timeouts and resource limits
- idempotency and concurrency for writes
- compatibility and versioning expectations
- caller-owned versus service-owned retries

Reject invalid data at the boundary. Keep domain logic independent of the HTTP,
queue, function, or framework entrypoint.

## Runtime

Use the language and official scaffold that fit the domain and operating
environment. TypeScript is not required. Python/FastAPI, Go, Rust, a Worker, or
another bounded runtime are valid when justified.

Add persistence only when the service owns durable state. Do not copy upstream
data for convenience without a freshness, reconciliation, and exit plan.

## Operations

Provide:

- health or readiness evidence
- structured, redacted logs
- timeout and dependency failure behavior
- configuration validation at startup
- a deployment and rollback procedure
- a named incident owner

## Delivery gate

- domain responsibility and non-responsibilities are explicit
- contracts and deterministic rules have tests
- auth, validation, failure, and retry behavior are verified
- health and configuration failure are observable
- the service can be deployed and rolled back independently
