---
name: audit-project
description: >-
  Use when a natural-language request asks to audit, check, maintain, repair,
  reconcile, or investigate drift in an evolved Project's current
  truth, documentation, proof, ownership, security, operation, or recovery.
  Run periodically after accumulated change, not for every trivial change.
---

# Project Audit

Use this periodic holistic backstop after many iterations, at a milestone or
handoff, or when drift is suspected. It is not a fifth lifecycle phase and is
not mandatory after every trivial change. Audit the evolved project's current
outcome and canonical truth, never parity with the original seed.

## Audit

Read the current README, project instructions, relevant skills, code,
interfaces, configuration, workflows, tests, runbooks, and operational or
recovery records. Establish the current outcome, owner, boundaries, and
canonical sources before judging any document.

Check, as relevant to the solution:

- README and runbook truth: flag stale or missing outcome, status, ownership,
  commands, configuration, interfaces, operation, recovery, or canonical links.
- Documentation routes: find broken local links; instructions and skill routes
  must point to existing, applicable files with valid frontmatter and metadata.
- Actual behavior: documented commands, configuration, interfaces, workflows,
  and checks match the current repository and runtime evidence.
- Execution state and proof: temporary task notes or generated state are not
  stale; documented proof reflects checks actually run and their results.
- Boundaries and risk: ownership, data authority, callers, exposure,
  trust boundaries, protected and intentionally public interfaces, secrets,
  authorization, private data, bounded input and resource use, external
  effects, and abuse or cost risk remain explicit and safe. Detect
  security drift such as newly exposed operations, silent production bypass,
  weakened per-action or per-resource authorization, stale credentials or
  signing keys, unsafe telemetry, or missing denial and replay evidence.
- Operations and recovery: health, failure visibility, disable, rollback,
  replay, restore, rebuild, or reconciliation are proportional and owned.
- Canonical release and operation: when applicable, the README or runbooks
  identify the release branch, remote or artifact, release owner, operating
  path, and recovery path without making an upstream template the owner.

## Attest live Git currentness when relevant

When repository currentness, sync, or release drift is relevant and the
Project has a remote and upstream, establish live evidence instead of
inferring currentness from local state:

1. Record the exact Git root and confirm it is the intended Project.
2. Record the current branch and its exact upstream. A detached head, missing
   upstream, unexpected branch, or substituted worktree is an evidence gap.
3. Record the remote by name and credential-free remote identity. Redact any
   embedded user information or token; never copy credentials into evidence.
4. Record tracked, staged, unstaged, and untracked state and classify the
   worktree as clean or dirty.
5. Fetch the exact upstream without changing the current branch or worktree,
   then resolve the fresh fetched live upstream object. If access or authority
   is uncertain, or the fetch cannot prove which live object was read, record
   the evidence gap and return **Needs decision**.
6. Compare local `HEAD` with that live object and classify the relation as
   equal, behind, ahead, or diverged: equal hashes are equal;
   local-as-ancestor is behind; live-as-ancestor is ahead; neither ancestry is
   diverged.

Cached tracking refs and a clean worktree are not live proof. State the exact
objects used for the classification and keep access non-interactive so missing
authority is surfaced rather than guessed. This attestation observes release
state; it does not reconcile or deliver it.

Do not fast-forward, commit, push, stash, rebase, merge, or force any ref.
Ahead, behind, diverged, inaccessible, or ambiguous state is evidence to
report, not permission to change it.

Start read-only. Compare documents with the current Project, not with a
seed snapshot or expected file list. If a discrepancy is safe, reversible,
local, and unambiguous, repair only the documentation or routing. Examples are
fixing a broken relative link, adding an omitted route to an existing skill, or
correcting an obvious command path. Re-read repaired routes and verify them.

When available, run the repository's relevant documented safe, non-mutating
validation commands. Record each exact command and its exact result. If a
relevant check is unavailable or unsafe to run, disclose it as an evidence gap.
Do not run consequential or mutating commands or operations.

Do not delete files or change runtime code, configuration, contracts, security
meaning, ownership, authority, or operational behavior. Require one owner
decision for semantic conflict, deletion, authority, or unclear canonical
truth. Record the location, evidence, and decision needed; do not guess.

## Return

Return exactly one status: **Healthy**, **Repaired**, or **Needs decision**.
Include concise evidence with paths, the checks or read-only observations, any
repair made, and any unavailable evidence. Use **Healthy** when current truth
is coherent, **Repaired** only for safe local documentation or routing repairs,
and **Needs decision** when an owner decision is required.
