# Agent Guide

Build the smallest technical solution that can create the intended outcome.
Work from repository evidence and keep the result understandable, testable,
operable, and owned.

## Start

1. Read the request, this guide, and existing project context.
2. Confirm what the repository owns, consumes, and does not own.
3. Identify the solution shape and current stack.
4. Choose the smallest valuable vertical slice.

Ask exactly one question, with a best guess, when one missing decision would
materially change the solution. Inspect the repository instead of asking for
facts it already contains.

## Workflow

| Need                                                       | Skill                                     |
| ---------------------------------------------------------- | ----------------------------------------- |
| Clarify, choose shape or stack, define boundaries, or plan | `.agents/skills/spec-solution/SKILL.md`   |
| Implement or change behavior with tests                    | `.agents/skills/build-solution/SKILL.md`  |
| Review correctness, quality, security, and simplicity      | `.agents/skills/review-solution/SKILL.md` |
| Release, deploy, activate, verify, or recover              | `.agents/skills/ship-solution/SKILL.md`   |

Use only the relevant skill. Small mechanical changes do not need the complete
workflow.

## Stack policy

- Applications default to React, TypeScript, and TanStack. Prefer TypeScript
  end-to-end when that keeps one Application simpler.
- Services and Integrations default to TypeScript for ordinary web and API
  work.
- Choose Python when data, quant, image, scientific, machine-learning, or
  existing Python ownership materially benefits the capability.
- Let n8n or another workflow runtime own orchestration. A separate Service
  owns only substantial reusable or specialist logic.
- Do not mix languages inside one responsibility without a concrete benefit.

## Engineering rules

- Give every responsibility and source of truth one explicit owner.
- Prefer one deployable unit before adding a network boundary.
- Keep modules cohesive, interfaces small, and framework details at the edge.
- Keep routes, handlers, components, and workflow triggers thin.
- Runtime-validate external input and keep contracts stable.
- Keep authorization, critical policy, calculations, and irreversible effects
  deterministic.
- Make retried side effects idempotent and bound reads, timeouts, retries, and
  concurrency.
- Keep secrets and private data out of code, logs, exports, and client builds.
- Emit structured, redacted logs where runtime failure matters.
- Add dependencies and infrastructure only for a demonstrated responsibility.
- Reuse working systems and owners instead of rebuilding for symmetry.
- Preserve rollback, replay, disable, restore, reconciliation, or export as
  appropriate.

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
