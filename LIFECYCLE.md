# Solution Lifecycle

This document places the AI-native Solution Template inside the wider path from
business problem to adopted technical change. It is a responsibility map, not
a waterfall, intake form, project-management system, or data handoff contract.

## Where the template enters

| Stage     | Relationship to the Solution Template                                                               |
| --------- | --------------------------------------------------------------------------------------------------- |
| Discovery | Outside. Understand the work, constraint, people, and whether a technical change is justified.      |
| Outcome   | Upstream input. Make users, baseline, rules, examples, exceptions, and the useful result explicit.  |
| Plan      | Entry boundary. Once a technical intervention is plausible, choose the smallest owned solution.     |
| Build     | Core scope. Design, implement, verify, secure, deploy, observe, recover, and document the solution. |
| Adoption  | Continued technical scope. Support real use, measurement, iteration, operations, and handover.      |

The stages overlap. New evidence during Build or Adoption may change the plan or
show that the solution should be reduced, replaced, or stopped.

The template does not own business discovery, commercial strategy, stakeholder
alignment, or the decision that software must exist. It begins contributing at
the technical edge of Plan and stays until the solution can earn and keep its
place in real work.

## Entry gate

Apply the template when the smallest justified intervention is an application,
service, automation, integration, or system change that needs an owned
repository.

Before implementation, find enough evidence to answer:

1. What outcome should change, and what is the current baseline?
2. Which users, workflow, or system will change?
3. Who owns the process, data, identity, deployment, and operations?
4. Which rules, examples, and exceptions matter to the first slice?
5. What is the smallest independently valuable slice?
6. What will prove technical acceptance and early adoption?
7. What is deliberately deferred?

The answers may be incomplete and may live anywhere useful. Ask one precise
question when a missing answer would materially change the solution. Do not
delay useful work to complete a form.

If configuring an existing tool solves the problem without a maintained
technical artifact, do not apply the template merely to create a repository.

## Shared intent, not a required brief

Shared intent is the minimum context that lets people and coding agents make
the same technical tradeoffs. It is information, not a required filename or
schema.

Use existing project context when it is clear. A target may add a lightweight
`DESIGN.md` when the decision is scattered, disputed, or needs review. Do not
create it by default. When useful, keep it short:

```md
# Design

## Outcome and baseline

## Existing work and owners

## Smallest valuable slice

## Rules, examples, and exceptions

## Acceptance and adoption evidence

## Deferred
```

Link to canonical business context instead of copying it into the project.
Project-specific architecture, contracts, decisions, commands, and evidence
belong in the target repository.

## Plan boundary

At the end of Plan, the template helps the team:

- reuse existing owners before adding systems
- decide whether the technical artifact is an Application, Service,
  Automation, Integration, or System
- choose the smallest slice and explicit non-goals
- map boundaries, trust, data, identity, runtime, and operational ownership
- compare implementation choices only after responsibilities are clear
- define acceptance, rollout, observation, recovery, and handover evidence

The template can support buy, configure, integrate, automate, or custom-build
decisions, but it should only be applied where a maintained technical
responsibility remains.

## Build coverage

During Build, the template governs the complete technical lift required by the
slice:

- product and interaction design where a user surface exists
- architecture, contracts, ownership, and implementation boundaries
- code, configuration, workflows, integrations, and migrations
- deterministic tests and agent evaluations where runtime AI exists
- authorization, secrets, safety, and consequential-action controls
- CI, deployment, observability, rollback, replay, or disable paths
- operator, user, recovery, and handover documentation

It does not require every capability. The complete lift means taking
responsibility for everything the chosen slice actually needs, not installing a
complete stack.

## Adoption coverage

Deployment is a checkpoint, not the end of the template's responsibility.

The technical side of Adoption includes:

- launching into the real workflow with an explicit owner
- providing the documentation and enablement material required for use
- making the agreed acceptance and adoption evidence observable
- watching reliability, security, cost, failure, and user-friction signals
- fixing or reducing the slice as evidence arrives
- keeping operations, recovery, and escalation understandable
- handing the solution over without losing its boundaries or source of truth

Business change management, coaching, commercial decisions, stakeholder
alignment, and interpretation of company-level outcomes remain with the people
and operating context around the solution. The template supplies evidence; it
does not own the business conclusion.

## Feedback and exit

A slice may leave active delivery when:

- it is used in real work or has been consciously stopped
- acceptance and early adoption evidence have been reviewed
- a named owner can operate, observe, recover, and change it
- relevant documentation and handover are complete
- remaining risks, deferred work, and next decisions are visible
- learning has been returned to the relevant business or project context

That feedback is a human and operational loop. AIOS, a board, or another
context system may link to the project, but the repositories do not require
data synchronization or coordinated versions.

## Relationship to AIOS

AIOS and the Solution Template remain independent.

An AIOS may hold business context and route to a separate project repository.
The project repository then owns its technical truth and may use this template.
Unattended or customer-facing execution belongs in that project runtime, not
inside AIOS.

The same template also works when context comes from a README, issue, meeting,
architecture map, or direct conversation.
