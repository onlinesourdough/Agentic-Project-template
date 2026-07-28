# AI-native Solution Template

A minimal, composable foundation for building the smallest technical solution
that can create the intended outcome.

Business development, understanding, analysis, and architecture come before
code and frameworks. This template begins after the decision that a technical
change is justified. It helps people and coding agents create an owned,
testable, operable solution without assembling an expensive supermarket stack.

## What AI-native means

AI-native does not mean AI-only or maximally autonomous. It means:

- context and intent are explicit
- people and coding agents can understand the system
- architecture and ownership precede implementation
- boundaries, trust decisions, and acceptance are inspectable
- deterministic code owns critical rules and side effects
- tests and operational evidence replace confidence theatre
- humans can operate, recover, change, and hand over the result
- runtime AI, models, databases, and vendors remain deliberate choices

Every repository should be **coding-agent-ready**. A product becomes
**agent-capable** only when a real user outcome requires a runtime agent.

## Where it enters the work

The Solution Template does not replace discovery, business context, or the
decision that software should exist. It joins at the technical edge of Plan,
governs Build, and remains through the technical side of Adoption.

| Stage     | Template responsibility                                                        |
| --------- | ------------------------------------------------------------------------------ |
| Discovery | None: understand the work, constraint, people, and build-or-not decision       |
| Outcome   | Consume: users, baseline, data, rules, examples, exceptions, and useful result |
| Plan      | Join: choose the smallest owned technical change and explicit non-goals        |
| Build     | Govern: design, code, AI, integrations, tests, security, deployment, recovery  |
| Adoption  | Support: documentation, measurement, iteration, operations, and handover       |

Deployment is a checkpoint, not the end. Read
[`LIFECYCLE.md`](LIFECYCLE.md) for the entry gate, optional shared-intent
pattern, scope boundaries, feedback loop, and exit conditions.

## Start with context

The template does not require a particular brief, AIOS, or planning tool. Before
implementation, Codex or another collaborator should be able to find:

1. the intended outcome and current baseline
2. the users, workflow, or system being changed
3. the owners of data, identity, process, deployment, and operations
4. the rules, examples, and exceptions that matter to the first slice
5. the smallest independently valuable slice
6. the evidence that will prove technical acceptance and early adoption
7. the capabilities explicitly deferred

That context may live in an issue, README, decision record, architecture map,
customer conversation, optional `DESIGN.md`, or an AIOS. If something material
is missing, ask one precise question instead of imposing a new intake schema.

AIOS and this template are independent. AIOS can help decide what deserves to
change; the Solution Template helps build the technical change. They share
principles, not runtime code, data synchronization, or a required handoff
format.

## Choose one solution shape

| Shape                                | Use it for                                                       |
| ------------------------------------ | ---------------------------------------------------------------- |
| [`application`](shapes/application/) | Website, dashboard, portal, digital product, internal tool, SaaS |
| [`service`](shapes/service/)         | API, microservice, calculation, worker, bounded domain behavior  |
| [`automation`](shapes/automation/)   | n8n workflow, scheduled job, event-driven process                |
| [`integration`](shapes/integration/) | Webhook, proxy, adapter, bot boundary, system connection         |
| [`system`](shapes/system/)           | Architecture, infrastructure, ownership, ADRs, runbooks          |

A business may use several shapes in separate repositories. Do not force
different owners and deployment lifecycles into one application.

### Application runtime profiles

Applications additionally choose the smallest runtime profile that fits:

| Profile                                                      | Use when                                                                                                         |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| [`static-pages`](profiles/static-pages/PROFILE.md)           | The product is public and fully static                                                                           |
| [`cloudflare-native`](profiles/cloudflare-native/PROFILE.md) | Edge endpoints or straightforward relational persistence exist                                                   |
| [`convex`](profiles/convex/PROFILE.md)                       | Authenticated data, realtime behavior, collaboration, scheduling, search, or shared web/native data exist        |
| [`external`](profiles/external/PROFILE.md)                   | Python/FastAPI, specialist compute, an existing database, or an independently deployed backend owns the behavior |

Profiles are implementation choices inside the Application shape. Services,
automations, integrations, and system repositories do not inherit frontend
assumptions.

## Apply the template

Create or inspect the real target repository first. Use current official
scaffolds for the selected runtime; this repository does not freeze generated
starter code.

Clone the template next to the target:

```sh
git clone --depth 1 https://github.com/gustavonline/solution-template.git
```

Application example:

```sh
node solution-template/bin/apply-template.mjs \
  --target ./my-product \
  --shape application \
  --profile cloudflare-native
```

Service example:

```sh
node solution-template/bin/apply-template.mjs \
  --target ./signal-service \
  --shape service
```

Automation example:

```sh
node solution-template/bin/apply-template.mjs \
  --target ./workflow-automation \
  --shape automation
```

Preview any selection without writing:

```sh
node solution-template/bin/apply-template.mjs \
  --target ./my-product \
  --shape application \
  --profile static-pages \
  --dry-run
```

The applicator copies a short agent guide, shared architecture, the selected
shape, delivery guidance, and only the relevant Application profile and
workflows. It never generates framework code or rewrites runtime manifests.

Legacy `--profile` commands continue to infer `--shape application` during the
`v0.x` preview and print a migration warning.

## Application scaffolds

Static Pages:

```sh
npx @tanstack/cli@latest create my-product \
  --router-only \
  --blank \
  --toolchain eslint
```

Cloudflare-native:

```sh
npx @tanstack/cli@latest create my-product --deployment cloudflare
```

External backend:

```sh
npx @tanstack/cli@latest create my-product
```

Convex with TanStack Start:

```sh
npm create convex@latest -- -t tanstack-start
```

For Services and other runtimes, follow that language or platform's current
official scaffold. Automation and System repositories may intentionally contain
no package manifest or runtime code.

## Add capabilities deliberately

Use this as a menu, not a checklist:

- authentication and authorization
- relational or realtime data
- payments and entitlements
- transactional email
- storage, queues, and scheduled work
- product analytics
- runtime AI and agent-capable operations
- mobile, desktop, CLI, or public API surfaces

Do not add a capability until a vertical slice needs it.

## Static storefronts and paid products

GitHub Pages is public hosting for storefronts, documentation, and free
resources. Never place paid files, secrets, or private source material in a
Pages artifact.

Developer products may use a public storefront and private-repository
fulfillment when every buyer has a GitHub account. Products for broader
audiences should enforce entitlements server-side. See
[`docs/digital-products.md`](docs/digital-products.md).

## Proof through use

The
[static Pages reference](https://gustavonline.github.io/app-template-static-example/)
is a fresh official TanStack Router application deployed through the included
workflow. Its
[source](https://github.com/gustavonline/app-template-static-example) remains
intentionally small.

[`resources.onlinesourdough.com`](https://resources.onlinesourdough.com) is a
Cloudflare-native implementation with server-owned paid access, contracts,
adapters, tests, migrations, and CI. Read the
[case study](docs/case-studies/onlinesourdough-resources.md).

The [CryptoClub retrospective](docs/case-studies/cryptoclub-retrospective.md)
shows how Application, Service, Automation, Integration, and System repositories
emerged in a real customer platform before the current AIOS existed.

## Repository map

- [`AGENTS.md`](AGENTS.md): short operational rules for coding agents
- [`LIFECYCLE.md`](LIFECYCLE.md): entry, pipeline scope, adoption, and exit
- [`ARCHITECTURE.md`](ARCHITECTURE.md): principles shared by all shapes
- [`shapes/`](shapes): responsibility and delivery rules by solution shape
- [`profiles/`](profiles): Application runtime profiles
- [`delivery/README.md`](delivery/README.md): tests, branches, CI, and releases
- [`docs/`](docs): specialist guidance and case studies
- [`bin/apply-template.mjs`](bin/apply-template.mjs): safe shape applicator
- [`ROADMAP.md`](ROADMAP.md): public direction and commercial boundary

## Status

`v0.2.x` is a public preview. Shapes, profiles, the applicator interface, and
the generated manifest may still change before `v1.0.0`. Breaking changes are
recorded in [`CHANGELOG.md`](CHANGELOG.md).

## Contributing and security

Contributions target `dev`; releases move from `dev` to `main`. Read
[`CONTRIBUTING.md`](CONTRIBUTING.md) before opening a pull request and
[`SECURITY.md`](SECURITY.md) before reporting a vulnerability.

MIT licensed. Built by Arc'IT and available through Online Sourdough Resources.
