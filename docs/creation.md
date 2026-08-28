# Project creation and transfer

This root is the directly copyable Agentic Project Template seed. The supported
helper creates a new Project as the destination, then the destination owns its
instructions, skills, implementation, proof, recovery, and lifecycle.

The helper is [scripts/create-project.sh](../scripts/create-project.sh). It
requires a new destination, a Project name, and an intended outcome:

```sh
bash scripts/create-project.sh ../<name> \
  --name "Project Name" \
  --outcome "The intended Project outcome"
```

## AIOS path

AIOS supplies resolved context and invokes the same helper directly below its
Projects directory:

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

The helper stages the destination and moves it into place only after all
generation succeeds. It copies only:

- `.agents/skills/README.md` and the six flat Project-local skill directories,
  including conditional acceptance examples that evaluate a technology
  boundary locally without making its runtime a Project dependency; and
- `LICENSE`.

It generates a Project-specific `AGENTS.md`, `README.md`, `.gitignore`, and
`docs/ownership.md`, `docs/proof.md`, and `docs/recovery.md`. It does not copy
the seed README or instructions, this creation contract, assets, tests, the
creation helper, issue references, caches, generated state, or the seed's
`.git` directory. The resulting `.git` directory is new and has no `origin`
remote.

## History and ownership choice

The destination starts with empty Git history and no remote. This keeps the
seed's history and remote ownership out of the new Project. The Project owner
creates the first commit and adds the canonical remote when ready. A failed
generation removes only its private staging directory and leaves an existing
destination untouched.

`CLAUDE.md` is intentionally absent from this seed and is never generated.
`AGENTS.md` is the sole root instruction contract; no alternate root adapter is
needed.

After transfer, the destination is the source of truth. Changes to the seed do
not flow into an existing Project automatically, and the Project does not
import runtime state from the seed. Cross-Project or Global Skills remain
outside the copied Project payload and follow the chosen harness or plugin's
own authorized installation and update path.
