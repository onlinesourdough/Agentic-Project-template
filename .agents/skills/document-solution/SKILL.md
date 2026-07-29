---
name: document-solution
description: Create, update, consolidate, or review the minimum technical documentation needed to understand, use, change, operate, and hand over a solution. Use for README guidance, AGENTS instructions, architecture decisions, C4 or flow diagrams, OpenAPI contracts, runbooks, code comments, deployment notes, or stale and duplicated documentation.
---

# Document Solution

Keep technical truth discoverable without creating a documentation system for
its own sake.

## Choose the owner

| Truth                                                   | Preferred artifact               |
| ------------------------------------------------------- | -------------------------------- |
| Purpose, setup, use, checks, deployment entrypoint      | `README.md`                      |
| Stable agent operating rules                            | `AGENTS.md` and project skills   |
| Selected shape and profile constraints                  | `docs/solution-template/`        |
| Costly or hard-to-reverse decision and alternatives     | Short ADR                        |
| Long-lived or multi-consumer HTTP contract              | OpenAPI                          |
| Hard-to-see system relationships                        | C4-style or focused flow diagram |
| Alert, incident, recovery, replay, or restore procedure | Runbook                          |
| Non-obvious local reason that must stay beside code     | Code comment                     |

Prefer an existing canonical artifact. Do not create a parallel `SYSTEM.md`,
task archive, wiki, diagram, or status document by default.

## Write

1. Identify the reader and decision or action the documentation must enable.
2. Inspect the implementation and runtime evidence; do not preserve stale
   claims.
3. Explain ownership, boundaries, commands, environment names, and recovery
   concretely.
4. Link to upstream business context rather than copying it without a project
   reason.
5. Use diagrams only when relationships are clearer visually. A C4 context and
   container view are usually enough; label every relationship.
6. Remove or consolidate superseded truth.

Document why and constraints, not line-by-line code behavior. Keep examples
safe and executable. Never include credentials, private payloads, production
data, or internal incident details.

## Verify

Run link, formatting, schema, example, and command checks that apply. Confirm a
new maintainer can find setup, ownership, deployment, failure visibility, and
recovery without reading an archive.
