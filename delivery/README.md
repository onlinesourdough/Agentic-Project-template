# Delivery

This document defines the delivery principles shared by all solution shapes.
Use the selected `SHAPE.md` for its specific evidence gate.

## Evidence before implementation

Before changing a target, identify:

- intended outcome and testable done-state
- existing owners and contracts
- selected solution shape
- smallest valuable slice
- explicit non-goals
- runtime and operational owner

Do not require a fixed business brief. Link or read the best existing source of
context and ask only for material missing decisions.

## Test-driven development

Write or update a failing test before deterministic behavior when practical.
Implement the smallest passing change and keep checks green while refactoring.

Use TDD especially for:

- domain and calculation rules
- input/output contracts and mappings
- authorization and paid access
- signatures, webhooks, and integrations
- retries, duplicates, idempotency, and concurrency
- workflow branching and recovery behavior
- migrations and incident fixes

Pure documentation, visual composition, configuration inventory, and spikes may
use review or runtime evidence instead. Every important outcome still needs a
repeatable acceptance method.

## Evidence by shape

| Shape       | Minimum evidence                                                                        |
| ----------- | --------------------------------------------------------------------------------------- |
| Application | Static checks, behavior tests, build, and critical browser journey                      |
| Service     | Contract/domain tests, auth and failure tests, health evidence, deploy and rollback     |
| Automation  | Safe end-to-end run, duplicate/retry/failure exercise, replay and disable procedure     |
| Integration | Auth/mapping tests, timeout/downstream failure, acknowledgement, and reconciliation     |
| System      | Link validation, ownership review, current/target distinction, and incident walkthrough |

Use official runtime tools. A Python service may use pytest and mypy; an n8n
repository may validate exported workflows and perform a safe remote acceptance
run; a documentation system may use Markdown, link, YAML, and secret checks.

Do not add placeholder Node scripts or fake CI merely to make different shapes
look alike.

## Application checks

The included Application workflows expect:

```sh
npm run lint
npm run typecheck
npm run test
npm run build
```

Use current official scaffold scripts when names differ. Add route, adapter,
webhook, browser, real-backend, or migration coverage only when those
capabilities exist.

`convex-test` does not prove every production behavior. Critical auth, webhook,
scheduling, search, Component, and integration behavior may need a local or
isolated cloud backend.

## Branching

Use:

- `main`: production
- `dev`: integration and staging
- `feature/<short-name>`: new work
- `fix/<short-name>`: bug fixes
- `chore/<short-name>`: maintenance

Create feature branches from `dev`, open pull requests to `dev`, and release
through a pull request from `dev` to `main`. Hotfixes branch from `main` and are
merged back into `dev`.

Protect production branches from force-push. Require the checks that actually
prove the selected shape.

## Pull requests

Every pull request should include:

- intended outcome
- responsibility and boundaries changed
- tests or acceptance evidence
- migration and compatibility notes
- deployment, rollback, replay, or disable notes when relevant
- screenshots only when presentation changed

Merge only when evidence passes, no secrets are committed, and the operational
owner can understand the change.

## Application workflows

Templates live under `delivery/github-actions/`:

- `ci.yml`
- `ci-convex.yml`
- `deploy-github-pages.yml`
- `deploy-cloudflare.yml`
- `deploy-cloudflare-convex.yml`

The applicator installs these only for the Application shape:

- static Pages receives generic CI and GitHub Pages deployment
- Cloudflare native receives generic CI and Cloudflare deployment
- Convex receives Convex-aware CI and the combined Convex/Cloudflare release
- external receives generic frontend CI and no fabricated backend deployment

Other shapes receive no universal workflow. Adopt the official CI and
deployment model for the detected runtime after its real commands are known.

## GitHub Pages

The Pages workflow expects `dist/index.html`. Configure the Application to
consume `VITE_BASE_PATH` for repository-subpath deployment. Use `/` when a
custom domain is attached.

Pages is public hosting. Never include secrets, paid files, private source
material, or server-owned access decisions in the artifact.

## Cloudflare

Cloudflare workflows use scoped:

- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`

The Cloudflare-native workflow detects `db:migrate:remote` before applying D1
migrations. An application without D1 needs no placeholder migration script.

## Convex

The Convex deployment and frontend build form one release unit. Use separate
development/staging and production deployments. Never share a production deploy
key with pull requests, agents, or local worktrees.

CI may use an isolated non-production `VITE_CONVEX_URL`. Production uses an
environment-scoped `CONVEX_DEPLOY_KEY`.

For local agent work, prefer:

```sh
npm ci
npx convex dev --once
```

Use a separate expiring cloud development deployment only when public callbacks
or cloud runtime configuration are necessary.

## Secrets and external systems

- Keep secrets in the runtime or platform secret store.
- Keep sanitized examples in git.
- Never commit production workflow payloads, backup dumps, customer data, or
  private incident content.
- Scope service identities and tokens to the target environment.
- Verify deployment output, health, and the critical journey before claiming a
  release succeeded.

## Completion

Before Done:

1. Walk every requirement against evidence.
2. Resolve artifact paths and links.
3. Run automated checks and real-runtime acceptance appropriate to the shape.
4. State anything skipped, partial, or unavailable.
5. Confirm recovery, rollback, replay, or disable behavior.
6. Record operational ownership and handover notes.

## References

- [GitHub Actions](https://docs.github.com/actions)
- [GitHub Actions Environments](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [actions/setup-node](https://github.com/actions/setup-node)
- [Cloudflare Workers CI/CD](https://developers.cloudflare.com/workers/ci-cd/external-cicd/github-actions/)
- [Cloudflare Wrangler Action](https://github.com/cloudflare/wrangler-action)
- [Convex deployment](https://docs.convex.dev/cli/reference/deploy)
- [Convex testing](https://docs.convex.dev/testing/overview)
