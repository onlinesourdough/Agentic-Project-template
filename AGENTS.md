# Agentic Project Template (APT)

Build the smallest independent Project that creates the intended outcome and
can be understood, operated, recovered, and handed over by its owner.

## Shared lifecycle

Use the installed AIOS plugin (0.4.0 or later) for shared procedures:
`aios-spec-work`, `aios-build-work`, `aios-review-work` and `aios-ship-work`.
Spec owns conditional technology selection; Review owns generic repository
health audits. Resolve these skills through the harness, not copied files or
hardcoded cache paths. This repository owns its requirements, specialist
methods, checks, release facts and recovery. Keep those facts here and load
only the phase and local context needed for the change.

Work in the current task by default, including when opened directly from the
sidebar. Use `aios-orchestrate-workers` only for requested or concretely
beneficial delegation, or existing-worker recovery. Verify each selected root
and preserve one writer for overlapping changes. Repository work does not
preload personal AIOS context. Plugin availability is an authoring capability,
not a dependency of the product at runtime; if unavailable, report the method
gap and perform only work adequately covered by the local contract. Do not
recreate generic skills locally.

## Start

1. Read the request, README, and relevant canonical context.
2. Revisit independent ownership only when the requested change affects it.
3. Preserve resolved upstream intent. Use `aios-spec-work` for unresolved
   project-local scope, boundaries, or proof; a clear mechanical change needs
   only the delta and its check in the current session.
4. For a new or materially changed technology decision, run
   `aios-spec-work` after the contract. A working
   stack bypasses it when the change does not materially alter technology.
5. Build, verify, review, and ship only within the granted authority.

Treat cost and usage as acceptance evidence when they can change the smallest
reliable shape. Check current official terms at decision time; do not preserve
volatile prices, a provider catalogue, or a default vendor in Project truth.
An orchestration runtime is optional: select one only when visible workflow
responsibilities justify it, and keep reusable deterministic domain logic in
tested Project code.

Ask one question only when a missing decision would materially change the
Project. Inspect repository truth before asking for facts it already contains.
Act on obvious authorized steps and parallelize safe independent work. Hand
back clear, concise results in the user's language and at the requested depth.

See the [local skill index](.agents/skills/README.md) for the flat layout,
ownership boundary, and specialist-gap route.

Keep the same authorized goal across Spec, Build, Review, revisions, and authorized
Ship. Do not create lifecycle ceremony for a small mechanical change.

## Inputs and ownership

- AIOS may provide resolved business context, outcome, proof, and authority.
- A Design System may provide an approved visual handoff as ordinary input.
- Existing code, a brief, conversation, issue, or README may provide
  standalone context.

Copy only the context the Project needs. The Project repository becomes
canonical for its technical truth and never depends on AIOS, a Design System,
or this template at runtime.

## Creation and transfer

This root is the directly copyable APT seed. It does not contain a nested
template framework. Use the supported helper for either entry point. A
verified task or worker that fetched and validated the exact live APT revision
directly at the final Project path can convert that clean seed in place:

```sh
bash scripts/create-project.sh --in-place \
  --name "Project Name" --outcome "The intended Project outcome" \
  --source-url "https://github.com/onlinesourdough/Agentic-project-template.git" \
  --source-sha "$(git rev-parse HEAD)"
```

The caller verifies the live source, default branch, exact revision, and APT
validator before invoking this destructive route. The helper independently
guards the current Git root, `main`, sole `origin`, source URL, exact HEAD, and
clean state before generation. Existing out-of-place creation remains
supported:

```sh
# AIOS: create directly under its projects directory.
bash scripts/create-project.sh /path/to/AIOS/projects/<name> \
  --name "Project Name" --outcome "The intended Project outcome"

# Standalone: run the same helper from a checked-out APT seed.
bash scripts/create-project.sh ../<name> \
  --name "Project Name" --outcome "The intended Project outcome"
```

Both routes copy the specialist skill index and the
license, generate project-specific `AGENTS.md`, `README.md`, and
ownership/proof/recovery notes, and initialize a fresh empty Git repository.
They exclude the template's
README, instructions, docs, assets, tests, creation script, `.git` directory,
remotes, issue references, caches, and generated state. The owner makes the
first Project commit and adds any canonical remote. In-place creation records
the verified APT URL and SHA as historical provenance, then removes the seed
identity and history. The writer re-enters the exact final path before its
post-transition attestation. The seed is not a runtime dependency after
transfer.
`CLAUDE.md` is intentionally absent; `AGENTS.md` is the sole root instruction
file and the helper does not generate a Claude adapter.

## Engineering rules

- Give every responsibility and source of truth one owner.
- Prefer one deployable unit before adding a network boundary.
- Keep framework and vendor details at the edges of stable capability logic.
- Prefer existing maintainable patterns and small coherent components; comments
  explain only non-obvious intent, tradeoffs, or constraints.
- Validate external input and enforce authorization and irreversible policy on
  a trusted server or worker boundary.
- Make retried effects idempotent; bound reads, timeouts, retries,
  concurrency, and cost.
- Keep secrets and private data out of code, logs, exports, and client builds.
- Use synthetic fixture data; never copy real `.env` files into fixtures or
  worktrees by default.
- Add dependencies, databases, queues, containers, observability, and runtime AI
  only for demonstrated responsibilities.
- Preserve rollback, replay, disable, restore, reconciliation, or export as
  the risk requires.
- Keep README and operational truth current with behavior.
- Preserve unrelated contributors' changes and distinguish source, synthetic,
  and operational proof.

## Before completion

- Verify intended behavior through its real interface.
- Run the affected checks supported by this repository, proportional to risk.
- Check relevant failure, denial, duplicate, and recovery behavior.
- Review the diff for accidental complexity and stale truth.
- State unavailable evidence and remaining risk.

Never claim a test, deployment, migration, or runtime path passed without
reading its result.
