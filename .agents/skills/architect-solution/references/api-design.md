# API and Contract Design

Choose the communication style from caller needs and ownership:

- direct call inside one deployable unit
- HTTP/REST for broadly interoperable request-response contracts
- webhook for event delivery to an external owner
- queue or event stream for decoupled asynchronous work
- n8n for visible operational orchestration
- gRPC or GraphQL only when their specific consumer needs justify the added
  tooling and coupling

## HTTP baseline

- Model stable resources and actions in domain language; avoid leaking database
  tables or framework types.
- Use HTTP methods and status codes consistently.
- Validate path, query, header, and body input at the boundary.
- Return a stable machine-readable error code, safe message, request ID, and
  field details when useful.
- Bound request size, response size, processing time, and collection reads.
- Paginate collections with an opaque continuation cursor or link and a stable
  order.
- Make externally retried side effects idempotent; use a caller-supplied key
  when natural idempotency is unavailable.
- Define timeout, retry, concurrency, duplicate, and cancellation behavior.
- Keep authentication separate from authorization; decide resource and tenant
  access server-side.
- Do not expose secrets, internal errors, or fields callers do not need.
- Use optimistic concurrency for competing updates when lost writes matter.
- Treat compatibility and deprecation as part of the contract.

## Contract evidence

Use OpenAPI when an HTTP API is public, long-lived, has multiple consumers, or
generates clients/documentation. A small private endpoint can use runtime
schemas plus concise examples when that is clearer.

Verify:

- happy path and representative 4xx/5xx responses
- denial and tenant boundaries
- schema and compatibility tests
- idempotent retry and duplicate delivery
- pagination and resource limits
- timeout and dependency failure
- deployed contract or a real consumer integration

The OpenAPI description is a contract artifact, not a substitute for runtime
validation or tests.

Primary references:

- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
