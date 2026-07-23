# Static Pages profile

Choose this profile for a public site, documentation, portfolio, open resource,
or developer-product storefront that can be built entirely to static files.

## Minimum capabilities

- TypeScript and React
- Vite with TanStack Router or another client/static router
- `dist/` build output
- GitHub Actions CI
- GitHub Pages deployment

Create the current TanStack Router scaffold with:

```sh
npx @tanstack/cli@latest create my-product \
  --router-only \
  --blank \
  --toolchain eslint
```

Do not select TanStack Start SSR for GitHub Pages.

## Expected scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "typecheck": "npm run generate-routes && tsc --noEmit",
    "test": "vitest run",
    "build": "vite build"
  }
}
```

Use the scripts produced by the current official scaffold when they differ.
The apply tool reports missing scripts but does not rewrite `package.json`.

## Deployment contract

The copied Pages workflow publishes `dist/`. It sets `VITE_BASE_PATH` to the
repository subpath by default. The application must use that value in its Vite
and router base configuration.

For a custom domain, create the repository variable:

```text
VITE_BASE_PATH=/
```

Use pre-rendered routes, a hash router, or a deliberate 404 fallback. GitHub
Pages does not provide an application server for arbitrary client-side route
fallbacks.

## Do not add yet

- authentication
- a database
- billing SDKs
- server-side entitlements
- queues or background workers

A static storefront may link to Stripe Payment Links, but paid files and
secrets must not be present in the public repository or Pages artifact.
