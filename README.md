# Agentic Project Template (APT)

A small, directly copyable foundation for an application, service, automation,
integration, library, or system that needs its own owner and lifecycle.

APT is a Project Template, not a persistent Agentic System. The ownership
transfer is the important behavior:

```text
resolved context
→ copy/use APT
→ projects/<name>/
→ the new Project owns its instructions, skills, implementation, proof,
  recovery, and lifecycle
```

After creation, the Project is canonical. AIOS, a Design System, and this seed
may supply context, but the Project works without them at runtime and retains
no competing template identity or state.

```text
intent → project-local spec → build ↔ review → authorized ship → owned result
```

## Start

Use an AIOS handoff, Design System handoff, conversation, brief, existing
README, or change request as context. Then ask:

> Use this context as resolved input. Run `spec-project`, construct the
> smallest build-ready contract, and build the smallest useful result. Ask one
> question only if a missing decision would materially change it.

`spec-project` accepts rough ideas, developed briefs, near-complete
specifications, and existing-system changes. It preserves resolved material
and constructs the missing project-local technical specification instead of
demanding a ceremonial document.

## Workflow

| Need | Skill |
| --- | --- |
| Clarify boundaries, proof, or contracts | `.agents/skills/spec-project/SKILL.md` |
| Choose a new or materially changed technology | `.agents/skills/choose-technology/SKILL.md` |
| Implement and verify behavior | `.agents/skills/build-project/SKILL.md` |
| Review intent, correctness, security, and simplicity | `.agents/skills/review-project/SKILL.md` |
| Deliver, activate, deploy, or recover | `.agents/skills/ship-project/SKILL.md` |
| Periodic whole-repository health check | `.agents/skills/audit-project/SKILL.md` |

The [local skill index](.agents/skills/README.md) records the flat layout,
ownership boundary, and specialist-gap route.

Build and Review repeat until the requested proof passes. Ship happens only
when the owner authorizes the consequential action.

## Inputs and boundaries

### From AIOS

AIOS can supply resolved outcome, scope, proof, authority, and canonical links.
The Project runs a compact project-local Spec, then owns implementation,
operation, recovery, and handover. Measured learning can return to AIOS; AIOS
is not a runtime dependency.

### From a Design System

Copy an approved handoff as ordinary resolved input and verify it against the
real product, content, accessibility, and technology. Do not require a
maintained Design↔Project schema or make the Design System a runtime dependency.

### Standalone

Start from any useful context. The created Project owns the full path from
intent through operation. Keep one source for each fact and link rather than
duplicate business truth.

Canonical adjacent repositories, when their context is relevant, are
[AIOS](https://github.com/onlinesourdough/AIOS-template),
[Agentic Design System](https://github.com/onlinesourdough/Agentic-Design-System), and
[Agentic Content System](https://github.com/onlinesourdough/Agentic-Content-System).
They are optional context sources, not runtime dependencies.

The authorized Ship target is
[onlinesourdough/Agentic-project-template](https://github.com/onlinesourdough/Agentic-project-template).
Renaming the GitHub repository or changing remotes is an authorized Ship action,
not part of this Build.

## Create an owned Project

The root is the seed; do not introduce a nested `template/` directory.

### Direct final-root path

When a creation worker is already rooted at the final Project path, fetch the
live canonical APT commit directly into that empty Git repository. Do not
download another seed checkout. Before conversion, verify all of these facts:

- the physical current directory is the exact Git top level and final path;
- `origin` is the sole remote and is
  `https://github.com/onlinesourdough/Agentic-project-template.git`;
- the checked-out branch is `main`, the source default branch is `main`, and
  local `HEAD` equals the freshly queried live `origin/main` SHA;
- the worktree contains no tracked, untracked, or ignored state beyond the
  verified seed; and
- `bash tests/validate-project-template.sh` passes at that exact revision.

Then invoke the APT-owned transition from that root:

```sh
bash scripts/create-project.sh --in-place \
  --name "Project Name" \
  --outcome "The intended Project outcome" \
  --source-url "https://github.com/onlinesourdough/Agentic-project-template.git" \
  --source-sha "$(git rev-parse HEAD)"
```

`--source-url` and `--source-sha` are required only for this in-place route and
are recorded as historical provenance, not runtime ownership.

The helper verifies the current root, branch, sole remote, source URL, exact
SHA, and clean state again before generating a private sibling payload. A
pre-transition failure leaves the verified seed untouched. If replacement
fails after the seed moves into recovery position, the helper restores the
verified seed at the same final path. If restoration or cleanup cannot finish,
it reports the exact retained recovery directory instead of claiming success.
Success leaves that final path as the new Project with fresh empty Git history,
no remote, the filtered payload, and the verified source URL@SHA in
`docs/ownership.md` as historical provenance. Because the directory entry is
replaced, the worker must re-enter that exact absolute path before its
post-transition root and Git attestation.

### AIOS path

From the AIOS workspace, create directly under `projects/<name>` and continue
from the returned Project root:

```sh
bash /path/to/agentic-project-template/scripts/create-project.sh \
  /path/to/AIOS/projects/<name> \
  --name "Project Name" \
  --outcome "The intended Project outcome"
```

AIOS hands off resolved context, then the new Project owns `AGENTS.md`, local
skills, implementation, proof, recovery, and lifecycle.

### Standalone path

From a checked-out APT seed, run the same helper and then work only from the
new root:

```sh
bash scripts/create-project.sh ../<name> \
  --name "Project Name" \
  --outcome "The intended Project outcome" \
  --canonical-url "https://example.com/projects/<name>"
cd ../<name>
```

`--canonical-url` is optional; without it, the repository remains the declared
canonical location.

Both helper routes initialize fresh empty Git history, do not inherit an origin
remote, and leave the first commit to the Project owner. They copy only the
local skill index, six Project-local skills, and the license; they generate new
Project instructions, README, ownership, proof, and recovery notes.
Template-only assets, tests, creation scripts, issue references, caches, and
generated state are not copied.
An out-of-place failure removes only private staging state and never overwrites
an existing destination.
`CLAUDE.md` is intentionally not generated; the Project uses its own
`AGENTS.md` as its root instruction contract.

## Technology

Keep an existing working stack when the change does not materially alter it,
record it in the Spec, and go directly to Build. For a new or materially
changed technology decision, use
`.agents/skills/choose-technology/SKILL.md` after the project-local contract is
ready. For a concrete specialist capability gap, follow the inventory and
authority boundary in the
[local skill index](.agents/skills/README.md); do not preload or install
stack-specific skills from this template.

When usage or cost can change the smallest reliable result, the technology
decision records a dated check of current official terms, a bounded usage
guardrail, and the operator's stop condition. It does not retain a price table
or recommend a provider. An existing workflow runtime may own visible triggers,
integrations, approvals, schedules, and bounded retries only when those
responsibilities justify it. A concrete Project selects its runtime, schemas,
tests, or workflows; this template supplies no orchestration default or bundled
runtime artifacts. Keep reusable deterministic domain logic in tested Project
code so it can be replayed independently.

## Proportional security baseline

Every Project classifies callers, exposure, trust boundaries, intentionally
public and protected interfaces, data and side effects, and abuse or cost risk
during Spec.
Public and local-only Projects do not gain authentication by default.
A protected browser, service, or webhook boundary selects the smallest
suitable established mechanism, keeps authorization server-side per action and
resource, fails closed in production, and records relevant success and denial
proof. JWT is used only when the Project's risk and interoperability contract
justify it; it is never the generic API default.

Use current OWASP guidance as evidence when resolving a concrete boundary:
[API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0x11-t10/),
[REST Security](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html),
[Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html),
[Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html),
and [JWT](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_Cheat_Sheet.html).

## Repository map

```text
Agentic-project-template
├── AGENTS.md
├── README.md
├── .agents/skills/       # Flat Project-local skills and their index
├── scripts/              # Direct Project creation helper
└── tests/                # Template contract and creation validation
```

Validate the template and creation behavior with:

```sh
bash tests/validate-project-template.sh
```

The GitHub repository rename and any remote/settings change are Ship actions;
they are intentionally not performed by this Build.
