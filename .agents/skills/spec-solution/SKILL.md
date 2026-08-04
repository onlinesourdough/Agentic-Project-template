---
name: spec-solution
description: Clarify and plan the smallest technical solution one question at a time. Use when starting or changing an Application, Service, Automation, Integration, Library, or System and the outcome, ownership, shape, technology, boundaries, acceptance, or implementation order is not yet explicit.
---

# Spec Solution

Understand the problem before choosing code or framework.

## Keep one lifecycle goal

For substantive implementation, reuse the current task's matching goal or
create one containing the outcome, constraints, verification, and requested
Ship scope. In Codex use `/goal`; elsewhere use native persistent goal/task
state or the same contract in the current session. Spec, Build, Review, REVISE
loops, and authorized Ship are states in this goal, not separate goals. Do not
complete it at a phase boundary or narrow it to match partial progress.

When an AIOS handoff says its lead owns Spec and Review, do not create a second
Spec. Accept that Spec and let the project worker's bounded goal start at Build,
cover Review revisions, and include Ship only when requested and authorized.

## Inspect first

Read the request, repository instructions, current code, existing owners, and
any supplied context. Identify the canonical context source and link to it
instead of copying it. Resolve facts from the repository instead of asking the
user.

## Confirm the repository

Before scaffolding, find the smallest valid owner for the work.

Use a Solution repository when the capability needs its own durable context,
ownership, development, operation, or handover. Otherwise recommend the
existing process, tool, workspace, or project that should own it. Stop before
scaffolding unless the user explicitly chooses a separate project.

## Ask one question at a time

When a consequential decision is missing:

1. State the current best interpretation briefly.
2. Ask exactly one question.
3. Include the best guess and why it matters.
4. Wait for the answer before continuing.

Do not send a questionnaire. Stop when the outcome, user or caller, success
signal and its measurement owner, constraint, ownership, smallest complete
result, and non-goals are clear enough to proceed.

## Choose the solution shape

| Shape       | Primary responsibility                                                           |
| ----------- | -------------------------------------------------------------------------------- |
| Application | A human-facing website, product UI, mobile or desktop app, internal tool, or CLI |
| Service     | One bounded capability behind a stable interface                                 |
| Automation  | A triggered or scheduled sequence of steps                                       |
| Integration | Translation and reliable delivery between existing owners                        |
| Library     | A package, SDK, template, or reusable capability consumed by other solutions     |
| System      | Architecture, infrastructure, ownership, or operations across repositories       |

One outcome may use more than one shape, but each repository needs one clear
primary responsibility.

## Choose architecture proportionally

- Prefer one cohesive deployable unit. Split a Service or microservice only
  when ownership, deployment, scaling, isolation, or recovery must be
  independent.
- Treat Clean Architecture as dependency direction and separation of stable
  capability logic from delivery and infrastructure—not a required set of
  layers or folders.
- Use REST semantics when HTTP resources are the real interface. Use another
  explicit contract when events, jobs, libraries, files, or workflows are the
  natural boundary.

## Choose technology last

- Read `TECHNOLOGY.md` before selecting a new stack.
- Decide Build, Buy, Rent, and Self-host separately for each responsibility.
  A small owned Service and a bought or self-hosted orchestration runtime can
  be the simplest valid solution.
- For a material external capability, read current official pricing, plan
  limits, license, operational responsibilities, and exit options. Explain the
  consequence before implementation instead of relying on a free tier or
  remembered product behavior.
- Prefer TypeScript for browser interfaces and ordinary web capabilities. Use
  React when a component-based user interface is required.
- Prefer TypeScript for ordinary web APIs, Services, and Integrations.
- Use Python when the capability materially benefits from Python's data, quant,
  image, scientific, or machine-learning ecosystem, or already has a Python
  owner.
- Let n8n or another workflow runtime own orchestration. Extract code into a
  Service only when logic needs stronger tests, reuse, performance, or
  independent operation.
- Add data, deployment, and observability layers only when the solution owns a
  responsibility for them.
- Existing ownership and a working system outrank every recommendation.
- Do not mix languages inside one responsibility without a concrete benefit.
  Cross-language parts communicate through an explicit contract.

## Return the compact spec and plan

State:

- canonical context source and independent-lifecycle justification
- outcome, user or caller or operator, success signal, and measurement owner
- selected shape and stack
- Build, Buy, Rent, and Self-host ownership for material responsibilities,
  including the current source for consequential external-service decisions
- what the repository owns, consumes, and does not own
- interfaces, data authority, trust boundaries, and deployment unit
- smallest complete result and explicit non-goals
- ordered complete results with a verification point for each
- material risks, open decisions, and recovery expectation

Keep one canonical Product Brief or equivalent source. Move it once when the
project is its natural owner; otherwise link to the external owner.

Before Build in a fresh repository, replace the template guide with a
project-specific README. Preserve a useful README in an adopted repository.
Record the outcome, status and current result, canonical context link,
ownership and boundaries, architecture and dependencies, working commands,
delivery, operation, and recovery as those facts become known. If context
exists only in conversation, write the durable decisions there.

For a planning or specification request, return the compact spec and stop. For
an implementation request, update the repository truth, use the plan as the
agent's internal execution order, and continue directly with `build-solution`
unless a consequential decision is still missing. Do not require the user to
prompt each lifecycle phase, create a goal per phase, or create an issue for
every result.
