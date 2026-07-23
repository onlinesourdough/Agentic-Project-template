# Agent Guide

This guide tells a coding agent how to use the template safely. Keep it operational and concrete.

## First Rule

Do not commit generated TanStack or Convex starter projects into this documentation repository. Official scaffolds change over time. Create the real application from the current official CLI, then apply this architecture.

Cloudflare-native or external backend:

```sh
npx @tanstack/cli@latest create my-product
```

Convex with TanStack Start:

```sh
npm create convex@latest -- -t tanstack-start
```

If the official documentation changes, follow the current documentation.

## Working Order

1. Read `README.md`.
2. Read `ARCHITECTURE.md`.
3. Read `delivery/README.md`.
4. Read `docs/app-template/PROFILE.md` when the applicator copied one.
5. Classify the product shape.
6. Select one profile: static Pages, Cloudflare native, Convex, or external backend.
7. Create or inspect the real project scaffold.
8. Identify the smallest vertical slice for that product and profile.
9. Write or update the test before implementing testable behavior.
10. Add only the folders and capabilities needed for that slice.
11. Run lint, typecheck, tests, and build.
12. Keep the repo deployable.

## Profile Decision

Choose static Pages when the product is fully public and builds to static files.
Do not put paid content, secrets, or server-owned access decisions in the Pages
artifact.

Choose Convex when the product has authenticated application data, realtime behavior, collaboration, scheduling, search, AI workflows, or web and native clients sharing a backend.

Choose Cloudflare Workers with optional D1 when the product is static or mostly static, needs a few edge endpoints, is simple relational CRUD, or clearly benefits from SQL and Cloudflare-native operation.

Choose an external backend when the product requires Python/FastAPI, an existing database, specialist compute, or an independently deployed service.

Do not install Convex, D1, auth, billing, storage, queues, or analytics before the product needs them.

## Default Implementation Rules

- Use TypeScript.
- Keep route files thin.
- Keep components small and pure.
- Put shared contracts and pure rules in `shared/`.
- Keep vendor-specific document and SDK types out of presentational components and shared contracts.
- Put third-party calls in adapters or Convex actions/integrations, according to the selected profile.
- Follow TDD for domain rules, backend functions, adapters, webhooks, authorization, migrations, and bug fixes.

Cloudflare-native and external profiles:

- Put product workflows in services.
- Put external SDKs in adapters.
- Use repository interfaces when they protect a real persistence boundary.
- Use D1 as the first database for straightforward relational persistence unless another data model is clearly required.
- Use explicit API routes for mobile, desktop, webhooks, and public integrations.
- Centralize dependency wiring in `src/server/context.ts`.

Convex profile:

- Treat `convex/` as the server and data boundary, not as a database adapter.
- Keep public queries and mutations thin but responsible for validation, identity, authorization, and stable return shapes.
- Put reusable typed database operations and document mapping in `convex/model/`.
- Put pure business rules in `shared/domain/` or another framework-free module.
- Use actions for external APIs and nondeterministic work.
- Prefer a mutation that records intent and schedules an internal action over a client calling an action directly.
- Use HTTP actions for backend-owned webhooks and explicit HTTP clients.
- Give every public function argument validators and an explicit authorization decision.
- Add return validators where practical.
- Use internal functions for operations clients must not call.
- Use indexes and bounded reads; avoid unbounded `.collect()` and database `.filter()`.
- Await every database write, scheduler call, and promise.
- Do not wrap `ctx.db` in a repository interface that adds no useful boundary.
- Do not proxy ordinary Convex calls through TanStack server functions or Cloudflare Workers.
- Keep generated API imports in feature hooks and route data helpers.
- Let reactive subscriptions update query results instead of manually maintaining a second cache.
- Add Convex Components only when they solve a real capability, and wrap them behind application-owned functions.

## Expected Scripts

A real scaffold should expose the scripts its selected profile needs. Exact commands can change with official scaffolds.

Common:

```json
{
  "scripts": {
    "dev": "vite --host 127.0.0.1",
    "typecheck": "tsc -b",
    "lint": "eslint .",
    "test": "vitest run",
    "build": "vite build"
  }
}
```

Cloudflare-native additions:

```json
{
  "scripts": {
    "db:generate": "drizzle-kit generate",
    "db:migrate:local": "wrangler d1 migrations apply DB --local",
    "db:migrate:remote": "wrangler d1 migrations apply DB --remote",
    "deploy": "wrangler deploy"
  }
}
```

Convex additions may include:

```json
{
  "scripts": {
    "convex:dev": "convex dev",
    "convex:deploy": "convex deploy",
    "convex:ai:status": "convex ai-files status"
  }
}
```

Use the scripts generated by the current CLI when they differ.

## Tooling Access

Use official APIs and CLIs:

- Convex through its CLI, isolated development deployments, optional beta MCP server, and maintained AI files.
- Cloudflare through Wrangler and scoped API tokens.
- Stripe through Stripe CLI and webhook forwarding.
- Resend through API keys and API calls.
- Conventional databases through migrations and repository adapters.
- Browser verification through Playwright or the available browser tool.
- Repository and issue workflows through available MCP servers or official CLIs.

For a Convex project, install or refresh its maintained agent guidance:

```sh
npx convex ai-files install
npx convex ai-files status
```

Use `npx convex dev --once` for an isolated local backend in a non-interactive agent environment. Use a separate expiring cloud dev deployment and scoped key only when the task needs public callbacks or cloud services. Never give an agent worktree a production deploy key.

Do not hardcode secrets. Use platform secrets or local `.env` files ignored by git.

## Environment Variables

Document variable names before using them. Keep TanStack server-only environment parsing in one module, usually `src/server/env.ts`. Configure Convex runtime secrets through Convex environment management.

Common categories:

- public site URL
- auth client IDs, server secrets, cookie keys, and redirect URLs
- Stripe keys and webhook secret
- Resend API key and sender
- PostHog key when product analytics is enabled
- Cloudflare account and deployment settings

Convex categories:

- `CONVEX_DEPLOYMENT` for the selected local development deployment
- `VITE_CONVEX_URL` or the current framework-specific public deployment URL
- `CONVEX_DEPLOY_KEY` in CI only, scoped to the target deployment
- runtime secrets set on the matching Convex development, staging, preview, or production deployment

Cloudflare-native categories:

- D1 and other binding names
- `CLOUDFLARE_ACCOUNT_ID`
- a scoped `CLOUDFLARE_API_TOKEN`

## Vertical Slice Patterns

Convex application feature:

1. Add a shared DTO or pure rule only when it crosses clients or is framework-independent.
2. Write a failing domain or Convex function test.
3. Add or update validators, schema, and indexes in `convex/`.
4. Add reusable database work and mapping in `convex/model/<feature>.ts`.
5. Add the smallest public query or mutation in `convex/<feature>.ts`.
6. Add an internal action or HTTP action only if the workflow requires it.
7. Add `src/features/<feature>/hooks/` around the generated API.
8. Add small feature components.
9. Add the route entrypoint.
10. Run lint, typecheck, tests, build, and relevant integration checks.

Cloudflare-native or conventional SaaS feature:

1. `shared/schemas/<feature>.schema.ts`
2. failing or updated behavior test
3. `src/domain/<feature>/`
4. `src/repositories/<feature>-repository.ts`
5. `src/adapters/d1/<feature>-repository.ts`
6. `src/services/<feature>/`
7. `src/features/<feature>/hooks/`
8. `src/features/<feature>/components/`
9. `src/routes/` entrypoint
10. passing checks

Mostly-static feature:

1. Add a shared contract only when data crosses a form, API, or vendor boundary.
2. Write a test for boundary parsing or workflow behavior when relevant.
3. Add a service only when workflow logic exists.
4. Add an HTTP or provider adapter only when an external endpoint exists.
5. Add feature hooks and components.
6. Add the route entrypoint.
7. Run passing checks.

Do not create every possible file upfront. A missing folder is correct when the product has no responsibility for that layer.

## Review Checklist

Always verify:

- route files are thin
- components do not import server SDKs or raw database document types
- shared contracts have no React, Cloudflare, Convex, or database imports
- external inputs are runtime-validated
- authorization and paid access are enforced server-side
- Stripe and other side-effecting webhooks are idempotent
- `lint`, `typecheck`, `test`, and `build` pass or failures are explained
- feature branches target `dev`; release changes move from `dev` to `main`

For Convex, also verify:

- every public function has argument validators and an authorization decision
- client-inaccessible operations use internal functions
- queries use indexes and bounded result sets
- actions do not perform direct database access
- Components are isolated behind application-owned wrappers
- important data has an export and migration plan
- `convex-test` coverage is supplemented by real-backend or end-to-end coverage where its mock cannot prove behavior
- the frontend build points at the same Convex deployment updated by CI

For conventional databases, also verify:

- services do not import infrastructure SDKs
- adapters contain infrastructure details
- migrations are checked in
- mapper and repository contract tests cover data-layer changes

## Migration Checklist

Conventional adapter change:

1. Add the new adapter next to the old adapter.
2. Implement the same repository interfaces.
3. Add mapper tests.
4. Write export/import or dual-write migration scripts.
5. Test with staging data.
6. Run service tests against both adapters.
7. Switch wiring in `src/server/context.ts`.
8. Keep the old adapter read-only during verification.
9. Remove it only after rollback is no longer needed.

Moving from Convex to another backend:

1. Freeze and test the application DTOs consumed by routes and feature components.
2. Inventory dependencies on subscriptions, Components, scheduling, search, storage, and IDs.
3. Export production-like data and test the export parser.
4. Implement equivalent API behavior and map IDs and timestamps explicitly.
5. Point feature hooks or typed API clients at the new backend.
6. Test authorization, transactions, realtime behavior, background work, and webhooks end to end.
7. Rehearse migration and rollback with staging data.
8. Use a maintenance window or controlled dual-write only when its consistency model is understood.
9. Retain the old deployment read-only until data and behavior are verified.

Self-hosting Convex keeps the Convex programming model and is a different operation from migrating to PostgreSQL or MongoDB.

## Keep It Simple

This template ships products; it does not demonstrate architecture. If a pattern makes the first product harder without protecting a real boundary, do not add it.

The right implementation is the smallest one that keeps future change cheap. Convex removes several backend layers when selected, but it does not justify adding a backend to a product that can remain static.
