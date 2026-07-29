---
name: spec-solution
description: Clarify and plan the smallest technical solution one question at a time. Use when starting a project, feature, Service, Automation, Integration, or system change and the outcome, ownership, shape, stack, boundaries, acceptance, or implementation order is not yet explicit.
---

# Spec Solution

Understand the problem before choosing code or framework.

## Inspect first

Read the request, repository instructions, current code, existing owners, and
any supplied context. Identify the canonical context source and link to it
instead of copying it. Resolve facts from the repository instead of asking the
user.

## Pass the lifecycle gate

Before scaffolding, classify the need as:

1. an existing process or tool
2. an agent, skill, workflow, or other capability local to an existing
   workspace
3. an independent Solution project

An independent repository is justified when the solution must be understood,
developed, operated, accessed, or handed over without the original owner or
workspace. Schedule, credentials, agent use, code volume, and an internal or
external audience are not decisive.

Stop before scaffolding and recommend the smaller owner when an independent
lifecycle is not justified. Continue only if the user explicitly overrides
that recommendation.

## Ask one question at a time

When a consequential decision is missing:

1. State the current best interpretation briefly.
2. Ask exactly one question.
3. Include the best guess and why it matters.
4. Wait for the answer before continuing.

Do not send a questionnaire. Stop when the outcome, user or caller, success
signal and its measurement owner, constraint, ownership, smallest slice, and
non-goals are clear enough to proceed.

## Choose the solution shape

| Shape       | Primary responsibility                                                            |
| ----------- | --------------------------------------------------------------------------------- |
| Application | A human-facing landing page, content library, tool, portal, or full-stack product |
| Service     | One bounded capability behind a stable interface                                  |
| Automation  | A triggered or scheduled sequence of steps                                        |
| Integration | Translation and reliable delivery between existing owners                         |
| System      | Architecture, infrastructure, ownership, or operations across repositories        |

One outcome may use more than one shape, but each repository needs one clear
primary responsibility.

## Choose the stack last

- Use React, TypeScript, and TanStack for Applications unless existing
  ownership gives a better answer. Use TypeScript on the server too when it
  keeps one Application simpler.
- Use TypeScript by default for ordinary web APIs, Services, and Integrations.
- Use Python when the capability materially benefits from Python's data, quant,
  image, scientific, or machine-learning ecosystem, or already has a Python
  owner.
- Let n8n or another workflow runtime own orchestration. Extract code into a
  Service only when logic needs stronger tests, reuse, performance, or
  independent operation.
- Do not mix languages inside one responsibility without a concrete benefit.
  Cross-language parts communicate through an explicit contract.

## Return the compact spec and plan

State:

- canonical context source and independent-lifecycle justification
- outcome, user or caller or operator, success signal, and measurement owner
- selected shape and stack
- what the repository owns, consumes, and does not own
- interfaces, data authority, trust boundaries, and deployment unit
- smallest valuable slice and explicit non-goals
- ordered vertical slices with a verification point for each
- material risks, open decisions, and recovery expectation

Keep one canonical Product Brief or equivalent source. Move it once when the
project is its natural owner; otherwise link to the external owner.

Before Build in a fresh repository, replace the template guide with a
project-specific README. Preserve a useful README in an adopted repository.
Record the outcome, status and current slice, canonical context link, ownership
and boundaries, architecture and dependencies, working commands, delivery,
operation, and recovery as those facts become known. If context exists only in
conversation, write the durable decisions there.
