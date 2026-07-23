# Delivery

This document defines how the template should be developed, tested, branched, and deployed.

## Test-Driven Development

Use test-driven development for product logic and risky changes.

The loop is:

1. Write a failing test for the behavior.
2. Implement the smallest change that passes.
3. Refactor while tests stay green.
4. Run lint, typecheck, tests, and build before merge.

Use TDD especially for:

- domain rules
- services and use cases
- repository adapters
- mappers
- Convex public and internal functions
- Convex authorization and model helpers
- Stripe webhooks
- auth/session behavior
- paid access rules
- bug fixes
- migration scripts

TDD is optional for:

- purely visual UI changes
- copy changes
- simple layout changes
- static landing page composition with no behavior change
- throwaway spikes

Even when TDD is optional, every important user workflow should eventually have automated coverage.

## Test Layers

| Layer                    | Purpose                                                                                                                                                       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Unit tests               | Domain rules, pure helpers, schemas, mappers, services                                                                                                        |
| Adapter tests            | D1, MongoDB, Postgres, Stripe, Resend, CMS/newsletter providers, storage, queues                                                                              |
| Convex function tests    | Queries, mutations, actions, validators, authorization, model helpers, and Components through `convex-test`                                                   |
| Convex integration tests | Critical runtime behavior against a real local or isolated cloud backend when the mock is insufficient                                                        |
| Route tests              | Server functions, API routes, validation, auth boundaries                                                                                                     |
| Webhook tests            | Stripe signatures, idempotency, entitlement updates, provider callbacks                                                                                       |
| End-to-end tests         | The critical user path for the product shape: signup, login, checkout, dashboard access, cancellation, contact form, newsletter signup, or content publishing |

Use the layers that exist. A landing page with a newsletter endpoint may need contract/service tests and one end-to-end smoke test, but no auth, billing, migration, or paid-access tests.

`convex-test` is a fast mock. It does not enforce every production limit or runtime behavior. Keep pure rules under ordinary unit tests, use `convex-test` for backend function behavior, and add real-backend or end-to-end coverage for critical auth, webhooks, scheduling, search, Components, and external integrations.

Minimum merge gate:

```sh
npm run lint
npm run typecheck
npm run test
npm run build
```

Preferred scripts in a real scaffold:

```json
{
  "scripts": {
    "typecheck": "tsc -b",
    "lint": "eslint .",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:e2e": "playwright test",
    "build": "vite build"
  }
}
```

## Branching

Use a simple branch model:

- `main`: production branch.
- `dev`: integration and staging branch.
- `feature/<short-name>`: new work.
- `fix/<short-name>`: bug fixes.
- `chore/<short-name>`: maintenance.

Rules:

- Create feature branches from `dev`.
- Open pull requests back into `dev`.
- `dev` deploys to staging or preview.
- `main` deploys to production.
- Release by opening a pull request from `dev` to `main`.
- Protect `main`.
- Prefer protecting `dev` once there is more than one contributor or agent.
- Do not push directly to `main`.
- Hotfixes branch from `main`, merge to `main`, then merge or cherry-pick back to `dev`.

Recommended setup:

```sh
git checkout main
git checkout -b dev
git push -u origin dev
```

## Pull Request Rules

Every pull request should include:

- short summary
- what changed
- tests run
- migration notes if any
- screenshots for UI changes when useful
- rollback notes for risky changes

Merge only when:

- CI passes
- code follows `ARCHITECTURE.md`
- no secrets are committed
- migrations are reviewed when the app owns a database
- paid-access and webhook changes have tests when those capabilities exist

## GitHub Actions

Workflow templates live in:

- `delivery/github-actions/ci.yml`
- `delivery/github-actions/ci-convex.yml`
- `delivery/github-actions/deploy-github-pages.yml`
- `delivery/github-actions/deploy-cloudflare.yml`
- `delivery/github-actions/deploy-cloudflare-convex.yml`

Copy CI and the one deployment workflow selected for the generated app:

```txt
.github/workflows/ci.yml
.github/workflows/deploy-github-pages.yml       # static Pages profile
# or
.github/workflows/deploy-cloudflare.yml          # Cloudflare-native profile
# or
.github/workflows/deploy-cloudflare-convex.yml   # Convex profile
```

They are stored under `delivery/` so this documentation repo does not run app workflows without a `package.json`.

The applicator installs `ci-convex.yml` as `.github/workflows/ci.yml` only for
the Convex profile. Other profiles receive the vendor-neutral CI workflow.

Copy one deployment workflow:

- `deploy-github-pages.yml` for a fully static public site or storefront
- `deploy-cloudflare.yml` for the Cloudflare-native/D1 profile
- `deploy-cloudflare-convex.yml` for a Cloudflare-hosted TanStack app with a Convex backend

## Deployment Model

For dynamic apps and Worker-backed products, use two deployment paths:

- push to `dev`: run checks and deploy staging
- push to `main`: run checks and deploy production

For static landing pages and content sites, the same branch model still applies, but deployment may be GitHub Pages, Cloudflare Pages, or another static host. Do not add Worker, D1, or migration deployment steps unless the app actually uses them.

The GitHub Pages workflow expects `dist/index.html`. Configure the application
to consume `VITE_BASE_PATH` for repository-subpath deployment. Use `/` through a
repository variable when a custom domain is attached. Pages is public hosting,
not paid-content access control.

Required GitHub secrets:

- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`

Convex profile also requires an environment-specific:

- `CONVEX_DEPLOY_KEY`

Set a non-secret repository variable named `VITE_CONVEX_URL` for CI checks when the frontend build requires a deployment URL. Point it at an isolated development or test deployment, never production. Add any other framework or auth build variables explicitly for the selected project.

Recommended GitHub environments:

- `staging`
- `production`

Use environment-specific secrets when the GitHub plan supports them. Otherwise use repository secrets and keep deploy commands branch-gated.

## Convex And Cloudflare Deploy Notes

The Convex deployment and frontend build are one release unit. Run the Convex deploy command with the frontend build as its `--cmd`; this makes the build use the URL for the same Convex deployment that receives the backend functions. Deploy the already-built TanStack application to Cloudflare afterward.

The workflow template uses:

```sh
npx convex deploy --cmd-url-env-var-name VITE_CONVEX_URL --cmd 'npm run build'
```

Use a persistent staging Convex project or a deliberately managed preview deployment for `dev`. Use the production deployment key only in the GitHub `production` environment. Never reuse the production key for staging, pull requests, or agent worktrees.

Convex deployment performs backend typechecking and generated-code updates. CI must still run the project's normal lint, typecheck, tests, and build before deployment.

For pull-request previews, use a Convex preview deploy key and isolated deployment only when preview infrastructure is actually needed. Seed preview data through an explicit safe function or import; never copy production secrets or personal data by default.

## Cloudflare Deploy Notes

Cloudflare's official GitHub Actions guidance uses `cloudflare/wrangler-action` with `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.

The template deploy workflow assumes the generated app has:

- `npm run lint`
- `npm run typecheck`
- `npm run test`
- `npm run build`
- `npm run db:migrate:remote` when the app owns D1 migrations
- `wrangler deploy` when the app deploys a Worker

Adjust script names if the generated scaffold uses a different package manager or build command.

The workflow detects `db:migrate:remote` before running remote migrations, so a
Cloudflare-native application without D1 does not need a placeholder migration
script.

## Agent Development Environments

For isolated agent work, prefer a local Convex backend:

```sh
npm ci
npx convex dev --once
```

Use a separate expiring cloud dev deployment with a scoped deploy key when public webhooks, cloud environment variables, or dashboard access are required. This prevents agents and developers from overwriting one shared development backend.

## References

- [GitHub Actions](https://docs.github.com/actions)
- [GitHub Actions Environments](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [actions/setup-node](https://github.com/actions/setup-node)
- [Cloudflare Workers GitHub Actions](https://developers.cloudflare.com/workers/ci-cd/external-cicd/github-actions/)
- [Cloudflare Wrangler Action](https://github.com/cloudflare/wrangler-action)
- [Convex deployment CLI](https://docs.convex.dev/cli/reference/deploy)
- [Convex project configuration](https://docs.convex.dev/production/project-configuration)
- [Convex testing](https://docs.convex.dev/testing/overview)
- [Convex Agent Mode](https://docs.convex.dev/cli/agent-mode)
