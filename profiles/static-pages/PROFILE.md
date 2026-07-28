# Static Pages

Use for a public site that builds entirely to `dist/`.

## Runtime

- Vite with a static/client router
- GitHub Actions CI
- GitHub Pages deployment

Expected scripts are `lint`, `typecheck`, `test`, and `build`. Use the current
official scaffold's commands when their names differ.

The copied workflow sets `VITE_BASE_PATH` to the repository subpath. The app
must use it in Vite and router base configuration. Set the repository variable
`VITE_BASE_PATH=/` for a custom domain.

GitHub Pages has no application server. Use pre-rendering, a hash router, or a
deliberate fallback for client routes.

Do not add auth, a database, billing, queues, or private files. A static
storefront may link to checkout, but secrets, paid content, and entitlement
decisions must not exist in the public build.
