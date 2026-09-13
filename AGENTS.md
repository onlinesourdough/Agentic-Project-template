# Agentic Project Template (APT)

Use APT as described in [README.md](README.md) to start a new independent
repository at the caller's actual destination. Do not seed an existing project.

## Local work and shared methods

Read only the request and relevant repository context. This repository owns its
requirements, specialist methods, checks and creation/recovery behavior.
Discover the needed installed AIOS method through the native harness:
`aios-spec-work` for unresolved scope or technology decisions, `aios-build-work`
for implementation, `aios-review-work` for acceptance or repository audit, and
`aios-ship-work` for authorized delivery. Do not copy shared methods or hardcode
installation paths; the [local skill index](.agents/skills/README.md) holds only
specialist guidance. Missing methods are a capability gap, not a runtime
requirement; continue work adequately covered by the local contract.

Keep accepted context and action/destination authority across phases. Complete
authorized work through affected checks, review and in-scope fixes. Preserve
separate acceptance and delivery boundaries when delegated. Work in the current
task, verify each selected root and keep one writer per overlapping change.
Repository work does not preload personal AIOS context. A mechanical or typo
edit needs only the relevant context, scoped diff and affected check.

Use shared design and content skills when needed; working material belongs in
project-local `design/` and `content/` as needed. Copy only relevant inputs and
preserve their provenance. Neither directory is part of the seed payload.

## Creation and transfer

Use [the creation procedure](README.md#create-a-repository). The helper owns both
out-of-place creation and conversion of an exactly verified clean seed at the
final root. Preserve its source URL/SHA, exact Git root, branch, sole remote,
clean-state, payload whitelist, no-overwrite and recovery guards. The caller
verifies the live source/default branch and runs the validator before in-place
conversion. Re-enter the exact final path after replacement before attesting
the new Git root. Retain and report recovery evidence if restoration or cleanup
fails; do not claim success while it remains unresolved.

`scripts/create-project.sh` owns generated instructions and ownership/proof/
recovery notes. New repositories have fresh empty Git history and no remote.
Keep `AGENTS.md` as the maintained instruction source; `CLAUDE.md` is only its
local import adapter. Creation must not change global harness configuration.

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

## Verification

When creation or transfer changes, run `bash tests/validate-project-template.sh`
and inspect a generated project's actual instructions. Use synthetic local
fixtures without production access. Check relevant success, denial, duplicate
and recovery behavior, review the diff and fix in-scope findings. Rerun affected
checks after fixes; broaden only for new failures or unresolved risk. Report
actual check results and material limitations. Delivery and outcome measurement
remain pending until evidenced.
