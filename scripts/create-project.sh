#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/create-project.sh DESTINATION --name "Project Name" \
    --outcome "The intended Project outcome" [--canonical-url URL]

DESTINATION must not already exist. The helper creates a fresh Project with no
Git commit and no remote.
USAGE
}

fail() {
  printf 'create-project: %s\n' "$1" >&2
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 1
fi

if [[ "$1" == "--help" ]]; then
  usage
  exit 0
fi

destination_input="$1"
shift
project_name=''
project_outcome=''
canonical_url=''

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)
      [[ $# -ge 2 ]] || fail "--name requires a value"
      project_name="$2"
      shift 2
      ;;
    --outcome)
      [[ $# -ge 2 ]] || fail "--outcome requires a value"
      project_outcome="$2"
      shift 2
      ;;
    --canonical-url)
      [[ $# -ge 2 ]] || fail "--canonical-url requires a value"
      canonical_url="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

[[ -n "$destination_input" ]] || fail "destination is required"
[[ -n "$project_name" ]] || fail "--name is required"
[[ -n "$project_outcome" ]] || fail "--outcome is required"

case "$destination_input" in
  */) fail "destination must not end with a slash" ;;
esac

case "$project_name" in
  *$'\n'*|*$'\r'*) fail "--name must be a single line" ;;
esac
case "$project_outcome" in
  *$'\n'*|*$'\r'*) fail "--outcome must be a single line" ;;
esac

if [[ -n "$canonical_url" ]]; then
  case "$canonical_url" in
    http://*|https://*) ;;
    *) fail "--canonical-url must begin with http:// or https://" ;;
  esac
  case "$canonical_url" in
    *$'\n'*|*$'\r'*|*[[:space:]]*|*'('*|*')'*|*'['*|*']'*)
      fail "--canonical-url contains unsupported characters"
      ;;
  esac
fi

source_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
[[ -d "$source_root/.agents/skills" ]] || fail "missing local skills"
[[ -f "$source_root/LICENSE" ]] || fail "missing license"

destination_name="$(basename "$destination_input")"
destination_parent_input="$(dirname "$destination_input")"
[[ "$destination_name" != "." && "$destination_name" != ".." ]] ||
  fail "destination must name a child directory"
[[ -d "$destination_parent_input" ]] ||
  fail "destination parent must already exist: $destination_parent_input"

destination_parent="$(cd "$destination_parent_input" && pwd -P)"
destination="$destination_parent/$destination_name"
case "$destination/" in
  "$source_root/"*) fail "destination must be outside the seed" ;;
esac
if [[ -e "$destination" || -L "$destination" ]]; then
  fail "destination already exists: $destination"
fi

staging_directory="$(mktemp -d "$destination_parent/.project-create.XXXXXX")"
cleanup() {
  rm -rf "$staging_directory"
}
trap cleanup EXIT HUP INT TERM

mkdir -p "$staging_directory/.agents"
cp -R "$source_root/.agents/skills" "$staging_directory/.agents/skills"
cp "$source_root/LICENSE" "$staging_directory/LICENSE"

cat > "$staging_directory/.gitignore" <<'GITIGNORE'
.DS_Store
node_modules/
dist/
build/
coverage/
.cache/
.tmp/
.env
.env.*
!.env.example
GITIGNORE

markdown_name="$project_name"
markdown_name="${markdown_name//\\/\\\\}"
markdown_name="${markdown_name//\`/\\\`}"
markdown_name="${markdown_name//\[/\\[}"
markdown_name="${markdown_name//\]/\\]}"
markdown_outcome="$project_outcome"
markdown_outcome="${markdown_outcome//\\/\\\\}"
markdown_outcome="${markdown_outcome//\`/\\\`}"
markdown_outcome="${markdown_outcome//\[/\\[}"
markdown_outcome="${markdown_outcome//\]/\\]}"

if [[ -n "$canonical_url" ]]; then
  canonical_section="Canonical URL: [$canonical_url]($canonical_url)"
else
  canonical_section='Canonical location: this repository.'
fi

cat > "$staging_directory/AGENTS.md" <<EOF
# $markdown_name

Build and operate the smallest independent Project that creates this outcome:

> $markdown_outcome

## Start

Read this file, [README.md](README.md), and the canonical context for the
Project. Confirm that this repository owns an independent lifecycle. Run the
project-local Spec before implementation when scope, ownership, boundaries,
proof, or contracts are not already clear.

Ask one question only when a missing owner decision materially changes the
Project. Keep resolved context intact and record technical inferences locally.

## Route

| Work | Skill |
| --- | --- |
| Technical scope, boundaries, proof, or contracts | \`.agents/skills/spec-project/SKILL.md\` |
| New or materially changed technology decision | \`.agents/skills/choose-technology/SKILL.md\` |
| Implementation | \`.agents/skills/build-project/SKILL.md\` |
| Correctness, security, simplicity, and proof review | \`.agents/skills/review-project/SKILL.md\` |
| Authorized delivery, deployment, activation, or recovery | \`.agents/skills/ship-project/SKILL.md\` |
| Periodic whole-repository health check | \`.agents/skills/audit-project/SKILL.md\` |
| A concrete specialist capability gap | \`.agents/skills/manage-skills/SKILL.md\` |

Keep one lifecycle record across Spec, Build, Review, revisions, and any
authorized Ship. The Project repository is canonical after creation.

## Before completion

Verify behavior through the real interface or validator. Run the relevant
format, lint, type, test, build, contract, and security checks. Check failure,
denial, duplicate, and recovery behavior as relevant. Keep the README and
[proof record](docs/proof.md) current with actual evidence.

## Ownership and recovery

Record current responsibility in [docs/ownership.md](docs/ownership.md),
acceptance evidence in [docs/proof.md](docs/proof.md), and the tested recovery
path in [docs/recovery.md](docs/recovery.md). Keep secrets and private data out
of source, logs, exports, and client builds.
EOF

cat > "$staging_directory/README.md" <<EOF
# $markdown_name

## Outcome

$markdown_outcome

This repository is the canonical home of the Project. It owns the Project's
instructions, skills, implementation, proof, recovery, and lifecycle. Context
from other repositories or systems is copied as needed and is not a runtime
dependency.

$canonical_section

## Start

Read [AGENTS.md](AGENTS.md), then inspect the current Project truth and the
records in [docs/](docs/). Run the project-local Spec when a build-ready
technical contract is not already resolved. Continue from this repository root
for Build, Review, authorized Ship, and operation.

## Lifecycle

\`intent → project-local spec → build ↔ review → authorized ship → owned result\`

The public local routes are:

- [Spec](.agents/skills/spec-project/SKILL.md)
- [Technology choice](.agents/skills/choose-technology/SKILL.md), only for a
  new or materially changed decision
- [Build](.agents/skills/build-project/SKILL.md)
- [Review](.agents/skills/review-project/SKILL.md)
- [Ship](.agents/skills/ship-project/SKILL.md), only with owner authority
- [Audit](.agents/skills/audit-project/SKILL.md), periodically
- [Skill management](.agents/skills/manage-skills/SKILL.md), only for a proven
  specialist gap

## Ownership and recovery

- [Ownership](docs/ownership.md) records the owner and canonical sources.
- [Proof](docs/proof.md) records acceptance and outcome measurement.
- [Recovery](docs/recovery.md) records rollback, rebuild, restore, replay, or
  reconciliation evidence as the Project requires.

The repository was initialized with fresh empty Git history and no remote. The
Project owner makes the first commit and adds a canonical remote when ready.
See [LICENSE](LICENSE) for the applicable license.
EOF

mkdir -p "$staging_directory/docs"
cat > "$staging_directory/docs/ownership.md" <<EOF
# Ownership

## Canonical Project

- Name: $markdown_name
- Outcome: $markdown_outcome
- Technical source of truth: this repository
- Lifecycle owner: record the person or team responsible for decisions,
  operation, and handover

## Responsibilities

Record one owner for each material responsibility, data source, external
dependency, trust boundary, and operational decision. Link to the authoritative
contract rather than copying it into this record.

| Responsibility | Source of truth | Owner | Failure or escalation route |
| --- | --- | --- | --- |
| Project outcome | [README.md](../README.md) | To be recorded | To be recorded |
| Implementation | This repository | To be recorded | To be recorded |
| Operation | To be recorded | To be recorded | To be recorded |
| Recovery | [recovery.md](recovery.md) | To be recorded | To be recorded |

## Boundary

The Project is canonical after creation. Context providers and adjacent
repositories may be referenced as inputs, but they do not own this Project's
runtime truth.
EOF

cat > "$staging_directory/docs/proof.md" <<EOF
# Proof

## Intended outcome

$markdown_outcome

## Acceptance evidence

Record the real interface, validator, rehearsal, or runtime journey that proves
the outcome. Keep command output or links to durable evidence with the change.

- [ ] Success behavior verified
- [ ] Invalid or denied behavior checked where relevant
- [ ] Duplicate, partial-failure, and recovery behavior checked where relevant
- [ ] Documentation and local links checked

## Measurement

- Outcome signal: To be recorded
- Measurement owner: To be recorded
- Measurement point or window: To be recorded

Tests prove behavior and delivery. Record an outcome as pending until its
measurement window has elapsed.
EOF

cat > "$staging_directory/docs/recovery.md" <<EOF
# Recovery

## Recovery owner

Record the person or team who can disable, roll back, rebuild, restore, replay,
or reconcile the Project and who owns the recovery decision.

## Current path

Document the actual deployment or operating shape, the last known good
artifact, required configuration, and the exact recovery command or runbook.
Do not place secrets in this record.

1. Identify the affected artifact or state.
2. Stop or disable the unsafe operation when applicable.
3. Apply the tested rollback, rebuild, restore, replay, or reconciliation path.
4. Verify the critical journey and failure visibility.
5. Record the result in [docs/proof.md](proof.md) and return to operation only
   with owner authority.

## Rehearsal

- Last recovery rehearsal: To be recorded
- Result and evidence: To be recorded
- Remaining risk: To be recorded
EOF

git -C "$staging_directory" -c init.defaultBranch=main init --quiet

if [[ -e "$destination" || -L "$destination" ]]; then
  fail "destination appeared during creation: $destination"
fi
mv "$staging_directory" "$destination"
trap - EXIT HUP INT TERM

printf 'Created Project: %s\n' "$destination"
