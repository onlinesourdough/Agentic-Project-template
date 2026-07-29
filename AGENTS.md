# Agent Guide

Build the smallest technical solution that can create the intended outcome.
Work from repository evidence and keep the result understandable, testable,
operable, and owned.

## Start

1. Read the request, this guide, and the canonical project context.
2. Confirm that the work needs its own durable repository and lifecycle.
3. Identify the primary solution shape and what the repository owns.
4. Choose the smallest valuable vertical slice.

Ask exactly one question, with a best guess, when one missing decision would
materially change the solution. Inspect the repository instead of asking for
facts it already contains.

## Repository gate

Create or keep a Solution repository when the work needs independent ownership,
context, operation, development, or handover.

If an existing process, tool, workspace, or project should own the capability,
work there instead. Stop before scaffolding a new repository unless the user
explicitly chooses a separate project.

## Repository truth

Before Build, make README the project's current technical and operational
truth. Preserve a useful existing README.

Keep one canonical Product Brief or equivalent source for the problem,
audience, outcome, and direction. Link to it instead of duplicating it.

## Workflow

| Need                                                        | Skill                                     |
| ----------------------------------------------------------- | ----------------------------------------- |
| Clarify, choose shape or stack, define boundaries, or plan  | `.agents/skills/spec-solution/SKILL.md`   |
| Implement or change behavior with tests                     | `.agents/skills/build-solution/SKILL.md`  |
| Review correctness, quality, security, and simplicity       | `.agents/skills/review-solution/SKILL.md` |
| Release, deploy, activate, verify, or recover               | `.agents/skills/ship-solution/SKILL.md`   |
| Find, review, install, update, or remove a specialist skill | `.agents/skills/manage-skills/SKILL.md`   |

Use only the relevant skill. Small mechanical changes do not need the complete
workflow.

## Technology policy

- Read `TECHNOLOGY.md` when selecting or changing the stack.
- Choose technology after outcome, ownership, boundaries, and shape.
- Decide Build, Buy, Rent, and Self-host per responsibility. Hybrid solutions
  are valid when their ownership and contracts remain explicit.
- Before adopting an external capability, read its current official pricing,
  plan limits, license, operations, and exit path when these can affect the
  solution.
- Prefer TypeScript for browser interfaces and ordinary web capabilities.
- Use React when the solution needs a component-based user interface.
- Prefer TypeScript for ordinary web Services and Integrations.
- Choose Python when data, quant, image, scientific, machine-learning, or
  existing Python ownership materially benefits the capability.
- Let n8n or another workflow runtime own orchestration. A separate Service
  owns only substantial reusable or specialist logic.
- Add data, deployment, and observability layers only for demonstrated
  responsibilities.
- Existing ownership and a working system outrank every recommendation.
- Do not mix languages inside one responsibility without a concrete benefit.

## Skill policy

- Keep Spec, Build, Review, and Ship as the default lifecycle skills.
- Use `manage-skills` only for a concrete specialist gap. Prefer project-local
  skills and require review and approval before changing them.

## Engineering rules

- Give every responsibility and source of truth one explicit owner.
- Prefer one deployable unit before adding a network boundary.
- Treat SOLID, DRY, KISS, and YAGNI as design heuristics, not quotas. Remove
  repetition only when the shared concept is stable and one owner is clearer.
- Keep modules cohesive, interfaces small, and framework details at the edge.
- Organize modules around responsibilities and keep dependency direction toward
  stable domain or capability logic.
- Put database, API, queue, filesystem, and vendor clients behind boundaries at
  the system edge.
- Introduce an interface, repository, adapter, or wrapper only for a real
  contract, trust boundary, or substitutable dependency.
- Separate stable capability logic from delivery and infrastructure without
  forcing a ceremonial layer or folder structure.
- Keep routes, handlers, components, and workflow triggers thin.
- Keep secrets, authorization, critical policy, and irreversible effects on
  the trusted server or worker boundary rather than relying on a client.
- Runtime-validate external input and keep contracts stable.
- Keep authorization, critical policy, calculations, and irreversible effects
  deterministic.
- Make retried side effects idempotent and bound reads, timeouts, retries, and
  concurrency.
- Keep secrets and private data out of code, logs, exports, and client builds.
- Emit structured, redacted logs where runtime failure matters.
- Add dependencies and infrastructure only for a demonstrated responsibility.
- Split a microservice only for justified independent ownership, deployment,
  scaling, isolation, or recovery—not merely code organization.
- Reuse working systems and owners instead of rebuilding for symmetry.
- Preserve rollback, replay, disable, restore, reconciliation, or export as
  appropriate.
- Treat code, configuration, workflow exports, infrastructure, architecture,
  runbooks, and project-local agents or skills as valid solution artifacts.
- For infrastructure, document desired state, access and secret ownership,
  health, patching, drift, and a reproducible rebuild or tested restore path.

## Before completion

- verify the intended behavior through its real interface
- run the repository's actual format, lint, type, test, build, and contract
  checks that the change affects
- check relevant failure, denial, duplicate, and recovery behavior
- update only technical truth made stale by the change
- review and simplify the changed responsibility
- state unavailable evidence and remaining risk

Never claim that a test, deployment, migration, or runtime path succeeded
without reading its result.
