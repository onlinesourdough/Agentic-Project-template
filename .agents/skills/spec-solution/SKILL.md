---
name: spec-solution
description: Clarify and plan the smallest technical solution one question at a time. Use when starting a project, feature, Service, Automation, Integration, or system change and the outcome, ownership, shape, stack, boundaries, acceptance, or implementation order is not yet explicit.
---

# Spec Solution

Understand the problem before choosing code or framework.

## Inspect first

Read the request, repository instructions, current code, existing owners, and
any supplied context. Resolve facts from the repository instead of asking the
user.

## Ask one question at a time

When a consequential decision is missing:

1. State the current best interpretation briefly.
2. Ask exactly one question.
3. Include the best guess and why it matters.
4. Wait for the answer before continuing.

Do not send a questionnaire. Stop when the outcome, user or caller, success
evidence, constraint, ownership, smallest slice, and non-goals are clear enough
to proceed.

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

- outcome, user or caller, and success evidence
- selected shape and stack
- what the repository owns, consumes, and does not own
- interfaces, data authority, trust boundaries, and deployment unit
- smallest valuable slice and explicit non-goals
- ordered vertical slices with a verification point for each
- material risks, open decisions, and recovery expectation

Keep this in the conversation for small work. Update the shortest existing
project artifact only when the decisions must survive the conversation.
