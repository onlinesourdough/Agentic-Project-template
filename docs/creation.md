# Project creation and transfer

This root is the directly copyable Agentic Project Template seed. The supported
helper either creates a new destination or safely converts a verified seed at
the final path in place. The result owns its instructions, skills,
implementation, proof, recovery, and lifecycle.

The helper is [scripts/create-project.sh](../scripts/create-project.sh). It
requires a new destination, a Project name, and an intended outcome:

```sh
bash scripts/create-project.sh ../<name> \
  --name "Project Name" \
  --outcome "The intended Project outcome"
```

For a clean, directly fetched seed already at the final path:

```sh
bash scripts/create-project.sh --in-place \
  --name "Project Name" \
  --outcome "The intended Project outcome" \
  --source-url "https://github.com/onlinesourdough/Agentic-project-template.git" \
  --source-sha "$(git rev-parse HEAD)"
```

`--source-url` and `--source-sha` are required only for `--in-place`. They bind
the destructive transition to the source already verified by its caller and
become historical provenance in the generated ownership record.

## AIOS path

For direct-final-root creation, AIOS prepares the empty final Git root and
starts one worker rooted there. That worker fetches the canonical APT commit
into the same repository, verifies the credential-free source, live default
branch, exact SHA, clean state, and APT validator, then invokes `--in-place`.
There is no second temporary or persistent APT checkout.

The existing out-of-place AIOS path remains supported. AIOS can supply resolved
context and invoke the helper from a maintained seed checkout directly below
its Projects directory:

```sh
bash /path/to/agentic-project-template/scripts/create-project.sh \
  /path/to/AIOS/projects/<name> \
  --name "Project Name" \
  --outcome "The intended Project outcome"
```

The operator then continues from `/path/to/AIOS/projects/<name>`. AIOS is an
input and optional coordination context; the created Project does not require
AIOS, a Design System, or this seed at runtime.

## Standalone path

A standalone user checks out or copies this seed, runs the same helper, and
continues from the new destination:

```sh
bash scripts/create-project.sh ../<name> \
  --name "Project Name" \
  --outcome "The intended Project outcome" \
  --canonical-url "https://example.com/projects/<name>"
cd ../<name>
```

`--canonical-url` is optional. When supplied it is recorded as the Project's
canonical link; when omitted, the repository itself remains the only declared
canonical location.

## Transfer boundary

The helper stages the generated payload beside the destination and moves it
into place only after all generation succeeds. It copies only:

- `.agents/skills/README.md` and the six flat Project-local skill
  directories; and
- `LICENSE`.

It generates a Project-specific `AGENTS.md`, `README.md`, `.gitignore`, and
`docs/ownership.md`, `docs/proof.md`, and `docs/recovery.md`. It does not copy
the seed README or instructions, this creation contract, assets, tests, the
creation helper, issue references, caches, generated state, or the seed's
`.git` directory. The resulting `.git` directory is new and has no `origin`
remote.

The copied Spec, Build, Review, and Audit skills retain the proportional
security contract inside the existing lifecycle. The generated proof record
prompts the owner to classify public and protected boundaries and preserve the
applicable success, denial, misconfiguration, and replay evidence; it does not
require authentication for a public or local-only Project.

### In-place guards and transition

The in-place route operates only on the helper's own physical root. Before it
generates anything, it requires that root to be the exact Git top level on
`main`, with only `origin`, the exact supplied source URL and HEAD SHA, and no
tracked, untracked, or ignored state. The caller remains responsible for the
fresh remote query that proves source default-branch and live SHA equality and
for reading the APT validator result at that revision.

Generation occurs in a private sibling staging directory; it is a Project
payload, not a second APT checkout. Generation failure removes that staging
directory and leaves the verified seed untouched. For replacement, the helper
moves the verified seed once into a private sibling recovery position and
moves the completed Project into the original path. If installation fails, the
exit cleanup restores the verified seed to that path. If restoration or final
cleanup cannot finish, the error identifies the retained recovery directory
instead of claiming success.

After successful replacement, the helper removes the recovery seed. The exact
source URL@SHA remains in `docs/ownership.md` as historical provenance and is
the refetch path if the old seed must be reconstructed. The generated Project
contains no seed history, remote, scripts, tests, assets, or other template
state. The helper prints the final root; the same worker must re-enter that
absolute path before its post-transition root and Git attestation because the
directory entry was replaced.

## History and ownership choice

The destination starts with fresh empty Git history and no remote. This keeps
the seed's history and remote ownership out of the new Project. The Project
owner creates the first commit and adds the canonical remote when ready. A
failed out-of-place generation removes only its private staging directory and
leaves an existing destination untouched. The in-place route rejects an
existing Project because it cannot satisfy the verified-seed guards.

`CLAUDE.md` is intentionally absent from this seed and is never generated.
`AGENTS.md` is the sole root instruction contract; no alternate root adapter is
needed.

After transfer, the destination is the source of truth. Changes to the seed do
not flow into an existing Project automatically, and the Project does not
import runtime state from the seed. Cross-Project or Global Skills remain
outside the copied Project payload and follow the chosen harness or plugin's
own authorized installation and update path.
