# Agent Guide

This is a self-contained technical project using the AI-native Solution
Template. AIOS and other planning systems are optional context sources, not
dependencies.

## Start

1. Read the project's existing context and instructions.
2. Read `docs/solution-template/SHAPE.md` when present.
3. For an Application, read `docs/solution-template/PROFILE.md`.
4. Confirm what this repository owns, consumes, and deliberately does not own.
5. Choose the smallest useful slice.

Context may come from the user, a README, issue, decision, conversation, or an
AIOS. Keep project-specific technical truth here and link to upstream context
instead of copying it without a project reason. If one missing decision would
materially change the implementation, ask one precise question.

When working on the template source itself, read `README.md`,
`CONTRIBUTING.md`, and only the shape or profile being changed.

## Build

1. Reuse existing owners and sources of truth.
2. Define or update the smallest boundary or behavior under change.
3. Add a failing test first for deterministic rules when practical.
4. Implement only the capabilities required by the slice.
5. Keep domain rules outside framework entrypoints.
6. Validate success, relevant failure paths, and recovery.
7. Run the target repository's real checks.

A missing folder, database, auth system, queue, analytics tool, billing system,
or AI dependency is correct when the solution does not need it.

## Technical rules

- Give every responsibility one explicit owner.
- Runtime-validate external inputs and keep contracts stable.
- Keep vendor and infrastructure details at the edge.
- Keep critical policy, authorization, calculations, and irreversible effects
  in deterministic code.
- Make retried or duplicate side effects idempotent.
- Keep secrets and private production data out of code and committed exports.
- Use bounded reads, explicit indexes, and checked-in migrations when relevant.
- Use the lowest autonomy that delivers the outcome.
- Preserve rollback, replay, disable, export, or another real recovery path.
- Do not rebuild a working system for architectural symmetry.

## Shape boundaries

- **Application:** keep routes thin, UI free of server types, and paid or
  private access server-owned.
- **Service:** own one bounded capability with validated contracts, health, and
  observable dependency failure.
- **Automation:** make triggers, retries, duplicates, replay, error handling,
  human control, and the kill switch explicit.
- **Integration:** preserve upstream and downstream ownership; test auth,
  mapping, timeouts, acknowledgement, and reconciliation.
- **System:** maintain architecture, ownership, decisions, topology, and
  runbooks without fake runtime code.

## Before completion

- verify the intended artifact or behavior exists
- confirm the selected shape still fits
- confirm no existing owner or source of truth was duplicated
- run relevant formatting, lint, type, test, build, contract, workflow, or link
  checks
- exercise the critical real-runtime path when mocks cannot prove it
- verify failure visibility and recovery
- state skipped or unavailable evidence

Never claim a test, deploy, migration, scan, or release succeeded without
reading its result.

## Project skill

When the user asks to set up, architect, build, change, check, deploy, recover,
or maintain this solution, read and follow
`.agents/skills/develop-solution/SKILL.md`.

Natural language is the stable interface. Runtime skill pickers and
`$develop-solution` are optional conveniences. The canonical skill must work
with normal file access and without AIOS, shell access, subagents, connectors,
or a specific model.
