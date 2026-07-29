# Technology recommendations

These are preferred starting points, not requirements. Choose technology from
the solution's responsibilities, risks, operators, and existing ownership.

A strong default is understandable, well documented, easy to verify, and
replaceable without rewriting the product.

## Choose in this order

1. Identify the capability and its owner.
2. Reuse a working system when it already owns the responsibility.
3. Choose the smallest runtime that can deliver and recover the first slice.
4. Prefer fast feedback through types, schemas, validators, tests, and local
   tooling.
5. Record why each operational layer is needed.

## Preferred starting points

| Layer             | Preferred starting point                                                                                                                                          |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Browser interface | TypeScript and React. Use Vite for a simple browser app and add routing or a full-stack framework only when needed.                                               |
| Web capability    | TypeScript when one language keeps interfaces, contracts, and operations simpler.                                                                                 |
| Specialist logic  | Python for data, scientific, image, quant, and machine-learning ecosystems.                                                                                       |
| Orchestration     | n8n or the existing workflow runtime for visible integrations, schedules, and approvals.                                                                          |
| Local data        | Files or SQLite when one process or device owns the state.                                                                                                        |
| Shared data       | PostgreSQL when a durable relational source of truth should remain portable.                                                                                      |
| Realtime product  | Convex when a TypeScript product benefits from reactive data and accepts an integrated backend platform.                                                          |
| CI                | The repository host's native CI; GitHub Actions when GitHub owns the repository workflow.                                                                         |
| Deployment        | Cloudflare Pages or Workers for static and web-standard edge systems; an OCI container on a managed platform or VPS for long-lived or runtime-specific workloads. |
| Observability     | Health checks and structured logs first; OpenTelemetry when signals cross components or backends.                                                                 |
| Infrastructure    | Versioned configuration; add Docker, OpenTofu, or Terraform when reproducible deployment or handover requires it.                                                 |

Convex is an application backend, not a drop-in PostgreSQL replacement. Choose
it for its TypeScript, transaction, and realtime model—not merely to avoid
operating a database.

Do not add authentication, a database, a queue, a container platform, an
observability vendor, or runtime AI because a starter stack includes it. Each
layer needs one concrete responsibility and owner.

## AI-native selection test

Before accepting a technology, verify:

- its role and source of truth are explicit;
- humans and agents can find current official documentation;
- contracts can be checked by a compiler, schema, validator, or test;
- build, test, deploy, and recovery commands are observable;
- secrets and operational state stay outside source code;
- the replacement or exit path is understood;
- the operator can maintain it after handover.

Language popularity alone is not proof of fit. TypeScript and Python are strong
starting points because they combine large ecosystems, mature tooling, and fast
verification loops. Go, Rust, Java, C#, or another language remains the better
choice when an existing system, operator, runtime, or specialist requirement
justifies it.

## Official references

- [TypeScript documentation](https://www.typescriptlang.org/docs/)
- [React documentation](https://react.dev/)
- [Vite documentation](https://vite.dev/guide/)
- [Python documentation](https://docs.python.org/3/)
- [PostgreSQL documentation](https://www.postgresql.org/docs/)
- [SQLite: appropriate uses](https://www.sqlite.org/whentouse.html)
- [Convex documentation](https://docs.convex.dev/)
- [n8n documentation](https://docs.n8n.io/)
- [Cloudflare Workers documentation](https://developers.cloudflare.com/workers/)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
- [OpenTofu documentation](https://opentofu.org/docs/)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [GitHub Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/)
