# AI-native Solution Template

A self-contained technical foundation for building and operating an
Application, Service, Automation, Integration, or System.

It makes framework, stack, architecture, testing, deployment, recovery, and
technical ownership simpler without pretending to know the business problem.
It works with or without AIOS.

## Responsibility boundary

| Supplied to the project                                            | Owned by the Solution Template                                                                        |
| ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| Outcome, users, acceptance, business rules, constraints, authority | Shape, stack, architecture, contracts, implementation, tests, CI, deployment, observability, recovery |

Inputs may come directly from a person, an existing README or issue, a meeting,
an AIOS, or another trustworthy source. The template checks that enough input
exists, but it does not invent it or require a handoff format.

Project-specific technical truth stays in the project repository.

## Start anywhere

Create or open the real project repository in Codex, Claude Code, Pi, or another
file-capable agent harness. Then say:

> Use the project skill to set up this solution, choose the smallest fitting
> architecture, and show which technical readiness areas are Ready, Not
> applicable, Missing, or Blocked.

The canonical project skill is:

```text
.agents/skills/develop-solution/SKILL.md
```

It supports four workflows:

- **Set up:** establish responsibility, stack, architecture, commands, and
  operations.
- **Build:** implement and verify the smallest useful technical slice.
- **Check:** audit architecture, security, quality, deployment, and recovery.
- **Deploy:** release, verify, roll back, replay, or disable safely.

Natural language works without a skill picker. `$develop-solution` is an
optional Codex convenience, and a thin Claude adapter routes to the same
canonical skill.

## Optional AIOS transition

AIOS can be the persistent home base where business context, priorities, and
the decision to build are handled. When the answer requires a technical
solution:

1. Create or locate a separate repository under `projects/`.
2. Give the project access or links to the relevant input.
3. Apply the Solution Template.
4. Continue with the project-local `develop-solution` skill.

Nothing is copied from AIOS by default. There is no shared schema, runtime,
version, skill, or data synchronization. The project remains fully usable when
opened on its own.

## Choose one shape

| Shape         | Repository responsibility                                 |
| ------------- | --------------------------------------------------------- |
| `application` | Human-facing website, product, portal, dashboard, or tool |
| `service`     | Bounded API, worker, calculation, or domain capability    |
| `automation`  | Triggered or scheduled workflow                           |
| `integration` | Translation and delivery between authoritative systems    |
| `system`      | Cross-repository architecture, ownership, and operations  |

Only an Application selects a runtime profile:

| Profile             | Primary runtime                                          |
| ------------------- | -------------------------------------------------------- |
| `static-pages`      | Vite/static router on GitHub Pages                       |
| `cloudflare-native` | TanStack on Cloudflare with optional native state        |
| `convex`            | TanStack and Convex as a coordinated application release |
| `external`          | Frontend with an independently owned HTTP backend        |

Shapes define responsibility. Profiles make an Application stack and deployment
choice. Capabilities such as auth, persistence, billing, queues, analytics, or
runtime AI are added only when the selected slice requires them.

## Apply

Use the runtime's current official scaffold. The template does not freeze or
generate framework starter code.

```sh
git clone --depth 1 https://github.com/gustavonline/solution-template.git

node solution-template/bin/apply-template.mjs \
  --target ./my-solution \
  --shape application \
  --profile cloudflare-native
```

For another shape, omit the profile:

```sh
node solution-template/bin/apply-template.mjs \
  --target ./my-service \
  --shape service
```

Options:

```text
--target <path>
--shape <application|service|automation|integration|system>
--profile <static-pages|cloudflare-native|convex|external>
--dry-run
--force
```

`--dry-run` previews the result. `--force` replaces changed template-owned
files and should be used only after review.

## What is added

Every target receives:

- `AGENTS.md` and the thin `CLAUDE.md` adapter
- the canonical `develop-solution` skill and technical readiness reference
- optional Codex UI metadata and a thin Claude skill adapter
- the selected `docs/solution-template/SHAPE.md`
- `.solution-template.json` with version, selection, detected markers, applied
  files, and missing Application scripts

An Application also receives:

- the selected `docs/solution-template/PROFILE.md`
- CI and one deployment workflow when the profile has an honest common path

Non-Application shapes receive no fake universal CI or deployment. Their local
skill establishes the official path for the selected runtime or platform.

The applicator never rewrites manifests, adds a framework, creates auth or a
database, copies AIOS content, or claims a deployment succeeded.

## Technical coverage

The project skill checks every necessary technical area:

- responsibility, shape, profile, runtime, and stack
- architecture, contracts, data, identity, security, and privacy
- optional AI boundaries and autonomy
- tests, real-runtime acceptance, CI, and compatibility
- environments, secrets, migrations, deployment, and verification
- health, logs, metrics, performance, cost, incidents, and recovery
- operations, handover, portability, and decommissioning

Each area must be Ready, Not applicable with a reason, Missing, or Blocked.
Depth is proportional to consequence; a static page does not need a database
runbook, while a paid multi-tenant product does.

## Deployment

Static Pages, Cloudflare Native, and Convex Applications receive selected
deployment workflows. External Applications receive frontend CI but no invented
backend deployment.

Services, Automations, Integrations, and Systems use their actual platform's
official release or publication path. The project skill requires an exact
artifact and environment, configuration and secret ownership, migration order,
runtime verification, failure visibility, an operational owner, and a real
rollback, replay, disable, or recovery path.

Deployment is proven by the target environment—not by a successful build.

## Source repository

- `.agents/skills/develop-solution/` — canonical project workflow
- `bin/apply-template.mjs` — zero-dependency applicator
- `shapes/` — responsibility and deployment rules by solution shape
- `profiles/` — Application stack and deployment guidance
- `delivery/github-actions/` — selected Application workflows
- `test/` — applicator and independence contract tests

`v0.4.0` is a public preview. Read
[`CHANGELOG.md`](CHANGELOG.md) for changes,
[`CONTRIBUTING.md`](CONTRIBUTING.md) before contributing, and
[`SECURITY.md`](SECURITY.md) for vulnerability reporting.

MIT licensed. Built by Arc'IT and available through Online Sourdough Resources.
