# Technology recommendations

These are preferred starting points, not requirements. Choose technology from
the solution's responsibilities, risks, operators, and existing ownership.

A strong default is understandable, well documented, easy to verify, and
replaceable without rewriting the product.

## Choose what to own

Build, buy, rent, and self-host are not mutually exclusive. Decide them per
responsibility instead of choosing one model for the whole solution.

1. Identify the capability and its owner.
2. Reuse a working system when it already owns the responsibility.
3. Build the smallest differentiating or ownership-critical part.
4. Buy a managed capability when reduced operation justifies its cost and
   dependency.
5. Rent generic infrastructure when control and portability matter more than
   convenience.
6. Self-host third-party software only when its license permits the use and
   someone owns updates, security, observability, backup, and recovery.
7. Choose the smallest runtime that can deliver and recover the first slice.
8. Prefer fast feedback through types, schemas, validators, tests, and local
   tooling.
9. Record why each operational layer is needed.

A small owned Service can, for example, keep domain logic and contracts while
an n8n instance owns orchestration and a rented VPS owns the runtime boundary.
Keep these responsibilities explicit so one choice can change without
rewriting the whole solution.

## Preferred starting points

| Layer                   | Preferred starting point                                                                                                                                                         |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Browser interface       | TypeScript and React. Use Vite for a simple browser app and add routing or a full-stack framework only when needed.                                                              |
| Web capability          | TypeScript when one language keeps interfaces, contracts, and operations simpler.                                                                                                |
| Specialist logic        | Python for data, scientific, image, quant, and machine-learning ecosystems.                                                                                                      |
| Orchestration           | n8n or the existing workflow runtime for visible integrations, schedules, and approvals. Keep substantial reusable logic in a small Service.                                     |
| Local data              | Files or SQLite when one process or device owns the state.                                                                                                                       |
| Shared data             | PostgreSQL when a durable relational source of truth should remain portable.                                                                                                     |
| Realtime product        | Convex when a TypeScript product benefits from reactive data and accepts an integrated backend platform.                                                                         |
| CI                      | The repository host's native CI; GitHub Actions when GitHub owns the repository workflow.                                                                                        |
| Public static delivery  | GitHub Pages for public static repository content; Cloudflare Pages when edge delivery or a wider web platform is useful.                                                        |
| Web and edge deployment | Cloudflare Pages or Workers for web-standard edge systems. Vercel or Netlify are valid when their framework integration and managed workflow justify the platform dependency.    |
| Portable deployment     | An OCI container on a managed platform or VPS for long-lived or runtime-specific workloads.                                                                                      |
| VPS                     | Hetzner when the operator can own Linux and recovery. Consider Hostinger when its assisted dashboard reduces friction, while keeping the same explicit self-managed obligations. |
| Observability           | Health checks and structured logs first; existing platform signals next; Grafana for useful dashboards and alerts; OpenTelemetry for portable cross-component telemetry.         |
| Infrastructure          | Versioned configuration; add Docker, OpenTofu, or Terraform when reproducible deployment or handover requires it.                                                                |

Convex is an application backend, not a drop-in PostgreSQL replacement. Choose
it for its TypeScript, transaction, and realtime model—not merely to avoid
operating a database.

Do not add authentication, a database, a queue, a container platform, an
observability vendor, or runtime AI because a starter stack includes it. Each
layer needs one concrete responsibility and owner.

## Understand an external capability before adopting it

Use current official documentation instead of remembered pricing or a free
starter plan. Before recommending a managed service or self-hosted product,
check:

- the billing unit and realistic usage at the first slice and a plausible
  growth level;
- plan limits for executions, requests, bandwidth, storage, retention,
  concurrency, environments, and users as relevant;
- which plan contains the required feature;
- license terms and whether the intended commercial use is permitted;
- data ownership, export, migration, cancellation, downgrade, and exit paths;
- security, secret handling, data location, support, and incident ownership;
- backup, restore, upgrades, monitoring, and the operator time added by
  self-hosting.

Record the material decision and its source in the project's technical truth.
Explain it in plain language before implementation when it can materially
change architecture, cost, ownership, or handover.

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
- [n8n pricing](https://n8n.io/pricing/)
- [Cloudflare Workers documentation](https://developers.cloudflare.com/workers/)
- [GitHub Pages documentation](https://docs.github.com/en/pages)
- [Vercel documentation](https://vercel.com/docs)
- [Netlify documentation](https://docs.netlify.com/)
- [Hetzner Cloud documentation](https://docs.hetzner.com/cloud/)
- [Hostinger VPS documentation](https://www.hostinger.com/support/vps/)
- [Grafana documentation](https://grafana.com/docs/)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
- [OpenTofu documentation](https://opentofu.org/docs/)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [GitHub Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/)
