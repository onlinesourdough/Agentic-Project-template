---
name: clarify-solution
description: Clarify an underspecified technical solution one question at a time, decide whether a separate technical artifact is justified, and select the smallest fitting solution shape and Application profile. Use before architecture or implementation when outcome, caller, ownership, scope, automation boundary, or acceptance is unclear.
---

# Clarify Solution

Find the smallest justified technical intervention without turning discovery
into a questionnaire.

## Inspect first

Read the request, repository instructions, existing README or issue, current
system boundaries, and any linked context. Do not ask for information that is
already available or infer business facts from code.

Read `references/shape-selection.md` when the shape or automation boundary is
unclear.

## Ask one question at a time

1. State the current best interpretation in one short sentence.
2. Ask exactly one question whose answer would most change the technical
   direction.
3. Include a concise best guess or recommended choice so the user can react.
4. Wait for the answer before asking another question.
5. Update the interpretation and repeat only while a material decision is
   missing.

Never send a batch questionnaire. In a non-interactive run, report the single
blocking decision instead of guessing.

## Resolve only what matters

Reach sufficient clarity on:

- intended outcome and observable acceptance
- person, system, or workflow that calls or uses the result
- current source of truth and existing owners
- smallest valuable slice and explicit non-goals
- solution shape and, for an Application, profile
- platform and operational ownership
- constraints that materially change trust, cost, data, or deployment

Do not require a formal brief. Answers may remain in the conversation, issue,
README, or another trustworthy artifact.

## Stop

Stop asking when the agent can choose the boundary and first slice without
inventing a consequential decision. Return:

- outcome and acceptance
- selected shape and optional profile
- repository ownership: owns, consumes, does not own
- smallest slice
- important constraint or risk
- non-goals
- one remaining assumption, if any

Offer to persist this in the shortest existing project artifact only when it
must survive the conversation.
