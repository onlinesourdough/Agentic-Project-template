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
| Spec   | Understand the outcome and choose the smallest solution |
| Build  | Create complete, testable results                       |
| Review | Check the result and remove unnecessary complexity      |
| Ship   | Release, verify, and preserve a recovery path           |

Natural language is the interface. The repository instructions make the
workflow repeatable without requiring a specific coding agent or platform.

Give the agent the outcome once. When implementation is authorized, it owns the
ordinary planning, technical decisions, implementation, testing, and review
needed to complete that outcome. It may divide a large solution into many
internal work steps, but you should not have to manage them one by one.

## Two ways to start

Both paths lead to the same independent Solution repository. AIOS can provide
understanding and routing, but it is never a dependency of the solution.

### From AIOS

Use this path when work in AIOS reveals that an application, service,
automation, integration, library, or system needs its own durable lifecycle.

1. Open or create the relevant Solution repository.
2. Give the agent only the relevant AIOS context and links to canonical sources.
3. Let the project README become the current technical and operational truth.
4. Build and verify the outcome, then bring the measured result back to AIOS.

Ask:

> Build the smallest useful solution that creates this outcome: [...]. Use
> [AIOS context, link, or file] as the canonical context.

### From existing context

AIOS is optional. Start with whatever explains the need: a chatbot conversation,
notes from a meeting with a customer, friend, colleague, or manager, a
brainstorm, email, issue, analysis, Product Brief, existing README, or a system
that needs to change.

The context does not need a required format or need to be complete. Before
Build, the agent finds or clarifies:

- what should change and who the result is for
- the intended outcome and evidence that would prove it
- relevant ownership, constraints, and existing systems
- what should deliberately not be built yet

If one missing decision would materially change the solution, the agent asks
one precise question. It records durable decisions in the project README and
links to canonical sources instead of copying them.

Ask:

> Use [conversation, notes, link, file, or repository] as context. Build the
> smallest useful solution that creates [...]. Ask one precise question if a
> consequential decision is missing.

### Let the agent own the execution

For substantial work, one lead session owns the outcome and may use native
goals or independent workers. The agent handles the internal work steps; the
user does not need to create or manage an issue for each one.

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
The four included lifecycle skills are the default workflow. Add a specialist
skill only for a concrete project need; `manage-skills` handles that safely.

## Repository map

```text
Solution Template
├── AGENTS.md
├── .agents/skills/
│   ├── spec-solution/SKILL.md
│   ├── build-solution/SKILL.md
│   ├── manage-skills/SKILL.md
│   ├── review-solution/SKILL.md
│   └── ship-solution/SKILL.md
├── TECHNOLOGY.md
├── CLAUDE.md
├── assets/solution-template-overview.png
└── README.md
```

Start with one outcome, one owner, and one repository. Add another layer only
when the solution has a clear responsibility for it.
