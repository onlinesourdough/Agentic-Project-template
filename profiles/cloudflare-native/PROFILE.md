# Cloudflare Native

Use when an Application needs edge endpoints or Cloudflare-owned state.

## Runtime

- TanStack Router or Start on Cloudflare
- explicit validation at public boundaries
- GitHub Actions CI and staged deployment
- D1, R2, KV, Queues, or Durable Objects only when required

Expected scripts are `lint`, `typecheck`, `test`, and `build`. Add
`db:migrate:remote` only when the Application owns D1 migrations; deployment
detects it automatically.

Configure `CLOUDFLARE_ACCOUNT_ID` and a scoped `CLOUDFLARE_API_TOKEN` in
separate `staging` and `production` environments.

Keep workflows and domain rules outside routes, vendor calls at the edge, paid
access server-owned, and side-effecting webhooks idempotent.
