![Solution-template workflow](assets/solution-template-overview-v2.svg)

# Solution-template

A small foundation for an application, service, automation, integration,
library, or system that needs its own owner and lifecycle.

```text
intent → technical spec → build ↔ review → ship → owned operation
```

AIOS may supply the business need. Design-template may supply an approved
visual handoff. This repository owns the resulting solution and remains usable
without either one.

## Start

Use an AIOS handoff, Design-template handoff, conversation, brief, existing
README, or change request as context. Then ask:

> Use this context as resolved input. Run `spec-solution`, construct the
> smallest build-ready contract, and build the smallest useful result. Ask one
> question only if a missing decision would materially change it.

`spec-solution` accepts rough ideas, developed briefs, near-complete
specifications, and existing-system changes. It preserves resolved material and
constructs the missing project-local technical specification instead of
demanding a ceremonial document.

## Workflow

| Need | Skill |
| --- | --- |
| Clarify boundaries, proof, or contracts | `.agents/skills/spec-solution/SKILL.md` |
| Choose a new or materially changed technology | `.agents/skills/choose-technology/SKILL.md` |
| Implement and verify behavior | `.agents/skills/build-solution/SKILL.md` |
| Review intent, correctness, security, and simplicity | `.agents/skills/review-solution/SKILL.md` |
| Deliver, activate, deploy, or recover | `.agents/skills/ship-solution/SKILL.md` |
| Periodic whole-repository health check | `.agents/skills/audit-solution/SKILL.md` |
| Add a justified specialist skill | `.agents/skills/manage-skills/SKILL.md` |

Build and Review repeat until the requested proof passes. Ship happens only
when the user authorizes the consequential action.

## Inputs and ownership

### From AIOS

Accept resolved outcome, scope, proof, authority, and canonical links. Run a
compact project-local technical Spec, then let this repository own
implementation, operation, recovery, and handover. Bring measured learning
back to AIOS; do not make AIOS a runtime dependency.

### From Design-template

Copy the approved handoff into this repository. Treat its `DESIGN.md`, preview,
assets, and token exports as accepted visual direction, then verify them against
the real product, content, accessibility, and technology. Once copied, this
repository is canonical; Design-template is not introduced as a runtime dependency.

### Standalone

Start from any useful context. The repository owns the full path from intent
through operation. Keep one source for each fact and link rather than duplicate
business truth.

## Technology

Keep an existing working stack when the change does not materially alter it,
record it in the Spec, and go directly to Build. For a new or materially
changed technology decision, use
`.agents/skills/choose-technology/SKILL.md` after the project-local contract is
ready. Its rare Full Stack FastAPI reference loads only when its fit gates may
be independently satisfied. If a concrete specialist capability is missing,
route it through `.agents/skills/manage-skills/SKILL.md`; do not preload or
install stack-specific skills from this template.

## Repository map

```text
Solution-template
├── AGENTS.md
├── .agents/skills/       # Lifecycle skills and conditional technology choice
├── tests/                # Template contract validation
├── assets/               # README illustration
└── README.md              # Current project truth
```

Validate the template contract with:

```sh
bash tests/validate-spec-solution.sh
```
