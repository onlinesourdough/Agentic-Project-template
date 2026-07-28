# AI-native Solution Template

A small technical seed for a repository that needs to become an application,
service, automation, integration, or system.

Use it after you have decided that something technical should be built or
changed. It does not discover the business problem, create an AIOS, generate a
framework, or prescribe a full stack.

## With AIOS

AIOS is the persistent home base. The solution remains a separate repository
under `projects/`.

| AIOS owns                                                                | The project repository owns                                          |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------- |
| Business context, priorities, task routing, shared connections, learning | Code, contracts, technical decisions, commands, deployment, recovery |

Start from the AIOS root and ask the agent in normal language:

> Create or use the repository at `projects/<name>`. Apply the AI-native
> Solution Template as a `<shape>` with the `<profile>` profile when required.
> Use the context already available for this task, build the smallest useful
> slice, and keep project-specific technical truth in the project.

The agent can clone this template temporarily, run the applicator, and continue
inside the target repository. No formal handoff document or data sync is
required.

AIOS is optional. The template works equally well from a README, issue, meeting,
architecture note, or direct conversation.

## Choose one shape

| Shape         | Repository responsibility                                 |
| ------------- | --------------------------------------------------------- |
| `application` | Human-facing website, product, portal, dashboard, or tool |
| `service`     | Bounded API, worker, calculation, or domain capability    |
| `automation`  | Triggered or scheduled workflow                           |
| `integration` | Translation and delivery between authoritative systems    |
| `system`      | Cross-repository architecture, ownership, and operations  |

Only an Application selects a runtime profile:

| Profile             | Use when                                                          |
| ------------------- | ----------------------------------------------------------------- |
| `static-pages`      | The output is public and fully static                             |
| `cloudflare-native` | Edge endpoints or Cloudflare-owned state are needed               |
| `convex`            | Authenticated, realtime, collaborative application data is needed |
| `external`          | An existing or specialist backend owns the behavior               |

The shape describes what the repository owns. The profile is only an
Application runtime choice.

## Apply

The target must already be a repository or scaffold. Use the runtime's current
official scaffold rather than frozen starter code from this repository.

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

`--profile` is required only for an Application. `--dry-run` previews the
result. `--force` replaces template-owned files and should be used only after
reviewing conflicts.

## What is added

Every target receives only:

- a short `AGENTS.md`
- the selected `docs/solution-template/SHAPE.md`
- `.solution-template.json` with provenance and detected project markers

An Application also receives:

- the selected `docs/solution-template/PROFILE.md`
- CI and, where a real generic deployment exists, one deployment workflow

The applicator never writes framework code, rewrites manifests, adds auth or a
database, copies AIOS context, or creates a product brief. Non-Application
shapes receive no pretend universal CI.

Applications must contain `package.json`. The applicator reports missing
`lint`, `typecheck`, `test`, and `build` scripts without changing the file.
Other shapes may be identified by `.git`, `pyproject.toml`,
`requirements.txt`, `go.mod`, or `Cargo.toml`.

## AI-native

Here, AI-native means that the repository is understandable and safely
changeable by both people and coding agents: ownership is explicit, external
inputs are validated, critical rules remain deterministic, and verification,
recovery, and handover are possible. Runtime AI is optional.

## Source repository

- `bin/apply-template.mjs` — zero-dependency applicator
- `shapes/` — one small guide per repository responsibility
- `profiles/` — Application runtime guidance
- `delivery/github-actions/` — workflows installed only when relevant
- `test/` — applicator contract tests

`v0.3.0` is a public preview. Read
[`CHANGELOG.md`](CHANGELOG.md) for breaking changes,
[`CONTRIBUTING.md`](CONTRIBUTING.md) before contributing, and
[`SECURITY.md`](SECURITY.md) for vulnerability reporting.

MIT licensed. Built by Arc'IT and available through Online Sourdough Resources.
