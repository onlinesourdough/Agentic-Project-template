# Solution Template

![Solution Template overview](assets/solution-template-overview.png)

**Solution Template** is a minimal AI-native foundation for building the
smallest useful technical solution.

Use it when an application, service, automation, integration, library, or
system needs its own durable home, ownership, and lifecycle.

AI-native means that humans and agents can understand, change, verify, operate,
and recover the solution safely. Business intent and architecture come before
code and frameworks.

## Workflow

| Step   | Purpose                                                 |
| ------ | ------------------------------------------------------- |
| Spec   | Audit readiness and define the smallest Build contract  |
| Build  | Create complete, testable results                       |
| Review | Check the result and remove unnecessary complexity      |
| Ship   | Release, verify, and preserve a recovery path           |

Natural language is the interface. The repository instructions make the
workflow repeatable without requiring a specific coding agent or platform.

After many iterations, at a milestone, before handoff, or when drift is
suspected, use [audit-solution](.agents/skills/audit-solution/SKILL.md) as a
periodic holistic backstop. It checks the evolved project's current outcome
and canonical truth; it is not a lifecycle phase or a required step after
every trivial change.

Give the agent the outcome once. When implementation is authorized, it owns the
ordinary planning, technical decisions, implementation, testing, and review
needed to complete that outcome. It may divide a large solution into many
internal work steps, but you should not have to manage them one by one.

## Philosophy

Solution Template covers the independent project and solution layer of modern
AI engineering. Start with prompt and intent: a clear outcome, audience,
constraints, and evidence of success. [Prompt engineering](https://developers.openai.com/api/docs/guides/prompt-engineering)
turns that intent into useful instructions, while [context engineering](https://www.langchain.com/blog/context-engineering-for-agents)
supplies the business, repository, and runtime context an agent needs. README
truth, canonical sources, legible structure, instructions, skills, and tools
make that context findable. The instructions and tools stay harness-neutral: a
harness can provide native goals and sessions, but the repository retains an
explicit contract that remains usable elsewhere.

Build and Review form a persistent feedback loop. Build creates a complete
result; Review evaluates it against the intended outcome, removes unnecessary
complexity, and supplies the next correction when needed. [Harness engineering](https://openai.com/index/harness-engineering/)
makes the repository and environment legible and steerable for agents, while
[loop engineering](https://www.langchain.com/blog/the-art-of-loop-engineering)
makes repeated Build, Review, and revision dependable. Evaluation and proof
come from the real interface and the evidence appropriate to the risk:
tests, validators, checks, logs, rehearsals, and recovery exercises.

Architecture boundaries keep responsibilities and sources of truth explicit.
Security, reliability, observability, operations, and recovery make the result
safe to run and hand over; Ship releases and verifies it while preserving
rollback, replay, restore, export, or disable paths where they matter. These
are complementary disciplines, not successive replacements.

The repository supports both starting modes:

- **Standalone:** the repository owns the complete lifecycle from intent and
  context through Spec, Build, Review, Ship, and recovery, and remains
  independently operable.
- **AIOS-originated:** AIOS supplies business context and lead routing, while
  this project owns the independent solution layer: technical truth, bounded
  implementation, proof, operations, and recovery. The project remains
  independently operable; AIOS coordination is not a runtime dependency.

## Two ways to start

Both paths lead to the same independent Solution repository. AIOS can provide
understanding and routing, but it is never a dependency of the solution.

### From AIOS

Use this path when work in AIOS reveals that an application, service,
automation, integration, library, or system needs its own durable lifecycle.

When work originates in AIOS, the existing AIOS lead remains the canonical
source for resolved intent, outcome, scope, proof, and authority, and may own
the upstream business Spec and lifecycle routing. The project worker accepts
those decisions without duplicating discovery or reopening them, then runs
`spec-solution` for a compact project-local technical Spec using this
repository's instructions, README, technology guidance, current code,
interfaces, operations, recovery, and relevant skills before Build. Use one
bounded worker goal for that Spec, Build, lead Review revisions, and authorized
Ship; pause it for lead Review and resume the same goal when directed.

1. Open or create the relevant Solution repository.
2. Start the separate first-class worker task and one bounded goal in this
   project root. Give it only relevant AIOS context and canonical-source links;
   run the compact project-local Spec before implementation.
3. Make the project README the current technical and operational truth.
4. After Build, pause the worker goal for AIOS lead Review. Resume that same
   goal for REVISE or, after PASS, Ship when authorized.
5. Bring the measured result back to AIOS.

Ask:

> Use [AIOS context, link, or file] as the canonical context. Accept the
> resolved intent, outcome, scope, proof, and authority; run the compact
> project-local Spec, then build the smallest useful solution.

### From existing context

AIOS is optional. Start with whatever explains the need: a chatbot conversation,
notes from a meeting with a customer, friend, colleague, or manager, a
brainstorm, email, issue, analysis, Product Brief, existing README, or a system
that needs to change.

The context does not need a required format or need to be complete. A rough
idea, developed brief, near-complete specification, or existing-system change
request can all enter the same Standalone path. `spec-solution` audits the
source at its current maturity, preserves resolved material, and classifies
material dimensions as resolved, inferred, missing, or conflicting before
returning READY, REVISE, or BLOCKED. The agent finds or clarifies:

- what should change and who the result is for
- the intended outcome and evidence that would prove it
- relevant ownership, constraints, and existing systems
- what should deliberately not be built yet

When rough input and canonical context resolve the material dimensions,
`spec-solution` constructs the missing project-local technical specification as
the compact Build contract. When an existing source needs only a non-blocking
correction, it returns or applies a minimal REVISE patch; it does not demand a
formal brief merely because the input is rough.

If one missing decision would materially change the solution, the agent asks
one precise question. It records durable decisions in the project README and
links to canonical sources instead of copying them.

Ask:

> Use [conversation, notes, link, file, or repository] as context. Run the full
> `spec-solution`, then build the smallest useful solution that creates [...].
> Ask one precise question if a consequential decision is missing.

### Let the agent own the execution

For substantial work, one lead session owns the outcome and may use native
goals or independent workers. Keep one persistent goal around the full
lifecycle rather than one goal per phase, using the harness's native goal/task
state or the same explicit outcome contract. The agent handles the internal
work steps; the user does not manage each one.

Ask for a plan when you only want a plan. Ask explicitly for release,
publication, activation, or production deployment when Ship should be included.
Otherwise, the agent stops after the solution is implemented, reviewed, and
verified locally.

Native goal or session state is preferred. A short, temporary `TASK.md` is
useful only when work must survive several sessions, harnesses, or restarts. It
records the outcome, active responsibilities, verified status, and real
blockers, not a backlog of minor tasks. Remove it when durable truth has been
recorded in the README, decisions, or runbooks.

## Solution shapes

| Shape       | Examples                                         |
| ----------- | ------------------------------------------------ |
| Application | Website, UI, app, internal tool, or CLI          |
| Service     | API, calculation, model, or domain capability    |
| Automation  | Workflow, scheduled job, or event-driven process |
| Integration | Webhook, adapter, proxy, bot, or connection      |
| Library     | Package, SDK, template, or shared module         |
| System      | Infrastructure, architecture, or operations      |

Choose the primary responsibility of the repository. Supporting parts may use
other shapes without becoming separate projects.

## Technology and skills

Technology is chosen last. Existing ownership and a working system outrank
every recommendation.

- Prefer **TypeScript** for browser interfaces and ordinary web systems.
- Prefer **Python** for data, scientific, image, quant, and machine-learning
  capabilities.
- Prefer **n8n** or another workflow runtime for visible orchestration.
- Add databases, hosting, queues, containers, and observability only when a
  concrete responsibility needs them.
- Combine Build, Buy, Rent, and Self-host choices per responsibility when that
  creates a smaller and better-owned solution.

See [Technology recommendations](TECHNOLOGY.md) for the full decision guide.
Its [optional capability profiles](TECHNOLOGY.md#optional-capability-profiles)
are sourced decision aids for combinations of justified responsibilities, not
default stacks. The advanced full-stack Python profile is selected only when
all of its fit conditions and operator responsibilities are resolved.
The four included lifecycle skills are the default workflow. Use
[`audit-solution`](.agents/skills/audit-solution/SKILL.md) periodically as a
holistic backstop, not as another lifecycle phase. Add a specialist skill only
for a concrete project need; `manage-skills` handles that safely.

## Repository map

```text
Solution Template
├── AGENTS.md
├── .agents/skills/
│   ├── spec-solution/
│   │   ├── SKILL.md
│   │   └── examples/acceptance-cases.md
│   ├── build-solution/SKILL.md
│   ├── manage-skills/SKILL.md
│   ├── review-solution/SKILL.md
│   ├── audit-solution/SKILL.md (periodic holistic backstop)
│   └── ship-solution/SKILL.md
├── capability-profiles/
│   └── advanced-full-stack-python.md
├── tests/
│   └── validate-spec-solution.sh
├── TECHNOLOGY.md
├── CLAUDE.md
├── assets/solution-template-overview.png
└── README.md
```

Start with one outcome, one owner, and one repository. Add another layer only
when the solution has a clear responsibility for it.

Validate the maturity audit, readiness gates, AIOS preservation, and optional
profile contract with:

```sh
bash tests/validate-spec-solution.sh
```
