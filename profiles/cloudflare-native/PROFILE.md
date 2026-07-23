# Cloudflare-native profile

Choose this profile for a static or mostly-static product that needs a few edge
endpoints, server-side access checks, straightforward relational persistence,
webhooks, or Cloudflare-native storage.

## Minimum capabilities

- TypeScript and React
- TanStack Start or TanStack Router
- Cloudflare Workers or Pages Functions
- GitHub Actions CI and staged Cloudflare deployment
- explicit runtime validation at every public boundary

Add D1, R2, KV, Queues, or Durable Objects only when a product responsibility
requires them.

## Expected scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "typecheck": "tsc -b",
    "test": "vitest run",
    "build": "vite build"
  }
}
```

When the application owns D1 migrations, also add:

```json
{
  "scripts": {
    "db:migrate:remote": "wrangler d1 migrations apply DB --remote"
  }
}
```

The deployment workflow detects whether `db:migrate:remote` exists and skips
the migration step when the application has no D1 schema.

## Environment

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- application-specific Worker variables and secrets

Use separate `staging` and `production` GitHub environments.

## Boundaries

- workflows belong in services
- infrastructure SDKs belong in adapters
- persistence interfaces protect real replaceable boundaries
- dependency wiring belongs in `src/server/context.ts`
- paid access and authorization are enforced server-side
- side-effecting webhooks are idempotent

Do not add Convex or an external backend proxy unless the product grows into a
different primary profile.
