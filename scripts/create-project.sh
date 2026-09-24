#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/create-project.sh DESTINATION --name "Project Name" \
    --outcome "The intended Project outcome" [--kind general|application|api|cli] \
    [--canonical-url URL]

  bash scripts/create-project.sh --in-place --name "Project Name" \
    --outcome "The intended Project outcome" --source-url URL \
    --source-sha SHA [--kind general|application|api|cli] [--canonical-url URL]

DESTINATION must not already exist. --in-place converts the clean, verified APT
seed at the current Git root. Both routes create a fresh Project with no Git
commit and no remote.
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

in_place=false
destination_input=''
case "$1" in
  --help)
    usage
    exit 0
    ;;
  --in-place)
    in_place=true
    shift
    ;;
  *)
    destination_input="$1"
    shift
    ;;
esac
project_name=''
project_outcome=''
canonical_url=''
source_url=''
source_sha=''
project_kind='general'

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
    --source-url)
      [[ $# -ge 2 ]] || fail "--source-url requires a value"
      source_url="$2"
      shift 2
      ;;
    --source-sha)
      [[ $# -ge 2 ]] || fail "--source-sha requires a value"
      source_sha="$2"
      shift 2
      ;;
    --kind)
      [[ $# -ge 2 ]] || fail "--kind requires a value"
      project_kind="$2"
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

[[ -n "$project_name" ]] || fail "--name is required"
[[ -n "$project_outcome" ]] || fail "--outcome is required"
case "$project_kind" in
  general|application|api|cli) ;;
  *) fail "--kind must be general, application, api, or cli" ;;
esac

if $in_place; then
  [[ -n "$source_url" ]] || fail "--source-url is required with --in-place"
  [[ -n "$source_sha" ]] || fail "--source-sha is required with --in-place"
else
  [[ -n "$destination_input" ]] || fail "destination is required"
  [[ -z "$source_url" && -z "$source_sha" ]] ||
    fail "--source-url and --source-sha require --in-place"
  case "$destination_input" in
    */) fail "destination must not end with a slash" ;;
  esac
fi

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

if $in_place; then
  case "$source_url" in
    http://*|https://*) ;;
    *) fail "--source-url must begin with http:// or https://" ;;
  esac
  case "$source_url" in
    *$'\n'*|*$'\r'*|*[[:space:]]*|*'('*|*')'*|*'['*|*']'*|*'`'*)
      fail "--source-url contains unsupported characters"
      ;;
  esac
  [[ "$source_sha" =~ ^[0-9a-f]{40}$ ]] ||
    fail "--source-sha must be a full lowercase 40-character Git SHA"
fi

source_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
[[ -d "$source_root/.agents/skills" ]] || fail "missing local skills"
[[ -f "$source_root/.agents/skills/README.md" ]] || fail "missing local skill index"
[[ -f "$source_root/LICENSE" ]] || fail "missing license"
[[ -f "$source_root/scripts/foundation-content.sh" ]] || fail "missing foundation generator"

verify_in_place_seed() {
  local seed_root="$1"
  local git_top source_branch source_remotes actual_source_url actual_push_url
  local actual_source_sha source_status

  git_top="$(git -C "$seed_root" rev-parse --show-toplevel 2>/dev/null)" ||
    fail "--in-place source is not a Git worktree"
  [[ "$git_top" = "$seed_root" ]] ||
    fail "--in-place source is not the exact Git top level"
  source_branch="$(git -C "$seed_root" symbolic-ref --quiet --short HEAD 2>/dev/null)" ||
    fail "--in-place source must be on branch main"
  [[ "$source_branch" = main ]] ||
    fail "--in-place source must be on branch main"
  source_remotes="$(git -C "$seed_root" remote)"
  [[ "$source_remotes" = origin ]] ||
    fail "--in-place source must have only the origin remote"
  actual_source_url="$(git -C "$seed_root" remote get-url --all origin 2>/dev/null)" ||
    fail "--in-place source has no origin URL"
  [[ "$actual_source_url" = "$source_url" ]] ||
    fail "--in-place source URL mismatch: expected $source_url"
  actual_push_url="$(git -C "$seed_root" remote get-url --push --all origin 2>/dev/null)" ||
    fail "--in-place source has no origin push URL"
  [[ "$actual_push_url" = "$source_url" ]] ||
    fail "--in-place source push URL mismatch: expected $source_url"
  actual_source_sha="$(git -C "$seed_root" rev-parse HEAD 2>/dev/null)" ||
    fail "--in-place source has no HEAD revision"
  [[ "$actual_source_sha" = "$source_sha" ]] ||
    fail "--in-place source revision mismatch: expected $source_sha"
  source_status="$(git -C "$seed_root" status --porcelain=v1 \
    --untracked-files=all --ignored=matching)"
  [[ -z "$source_status" ]] || fail "--in-place source must be clean"
}

if $in_place; then
  current_root="$(pwd -P)"
  [[ "$current_root" = "$source_root" ]] ||
    fail "--in-place must run from the APT seed root: $source_root"
  verify_in_place_seed "$source_root"

  destination="$source_root"
  destination_parent="$(dirname "$source_root")"
  destination_name="$(basename "$source_root")"
else
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
fi

staging_directory="$(mktemp -d "$destination_parent/.project-create.XXXXXX")"
recovery_directory=''
seed_moved=false
project_installed=false
cleanup() {
  local exit_status=$?
  trap - EXIT HUP INT TERM
  set +e

  if [[ -n "$staging_directory" && -e "$staging_directory" ]]; then
    rm -rf "$staging_directory"
  fi

  if $seed_moved && ! $project_installed; then
    if [[ ! -e "$source_root" && -d "$recovery_directory" ]]; then
      if mv "$recovery_directory" "$source_root"; then
        printf 'create-project: restored verified seed after failed transition: %s\n' \
          "$source_root" >&2
      else
        printf 'create-project: recovery required; verified seed retained at: %s\n' \
          "$recovery_directory" >&2
      fi
    elif [[ -d "$recovery_directory" ]]; then
      printf 'create-project: recovery required; verified seed retained at: %s\n' \
        "$recovery_directory" >&2
    fi
  elif $project_installed && [[ -d "$recovery_directory" ]]; then
    printf 'create-project: recovery cleanup required; verified seed retained at: %s\n' \
      "$recovery_directory" >&2
  elif [[ -n "$recovery_directory" && -d "$recovery_directory" ]]; then
    rmdir "$recovery_directory" 2>/dev/null ||
      printf 'create-project: unused recovery directory retained at: %s\n' \
        "$recovery_directory" >&2
  fi

  exit "$exit_status"
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

mkdir -p "$staging_directory/.agents/skills" "$staging_directory/docs"
cp "$source_root/.agents/skills/README.md" "$staging_directory/.agents/skills/README.md"
{
  printf "%s\n\n" "Template-derived starter material: generated foundation text and .agents/skills/README.md. This notice does not license later product code or content."
  cat "$source_root/LICENSE"
} > "$staging_directory/docs/template-license.txt"

cat > "$staging_directory/.gitignore" <<'GITIGNORE'
.DS_Store
node_modules/
dist/
build/
coverage/
.cache/
.tmp/
.venv/
__pycache__/
.pytest_cache/
.turbo/
.next/
.tanstack/
.wrangler/
.dev.vars
.dev.vars.*
!.dev.vars.example
.env
.env.*
!.env.example
.local/
GITIGNORE

# Generate the foundation from validated facts; keep transfer guards below separate.
source "$source_root/scripts/foundation-content.sh"

if ! git -C "$staging_directory" -c init.defaultBranch=main init --quiet; then
  fail "could not initialize generated Project Git repository"
fi

if $in_place; then
  verify_in_place_seed "$source_root"
  recovery_directory="$(mktemp -d \
    "$destination_parent/.apt-seed-recovery.XXXXXX")"
  rmdir "$recovery_directory"

  if ! mv "$source_root" "$recovery_directory"; then
    fail "could not move the verified seed into recovery position"
  fi
  seed_moved=true
  verify_in_place_seed "$recovery_directory"

  if ! mv "$staging_directory" "$source_root"; then
    fail "could not install the generated Project at the final root"
  fi
  project_installed=true
  staging_directory=''

  if ! rm -rf "$recovery_directory"; then
    fail "Project installed but verified seed recovery cleanup failed"
  fi
  recovery_directory=''
  seed_moved=false
  trap - EXIT HUP INT TERM
  printf 'Initialized Project in place: %s\n' "$destination"
  printf 'Re-enter Project root before continuing: %s\n' "$destination"
else
  if [[ -e "$destination" || -L "$destination" ]]; then
    fail "destination appeared during creation: $destination"
  fi
  mv "$staging_directory" "$destination"
  staging_directory=''
  trap - EXIT HUP INT TERM
  printf 'Created Project: %s\n' "$destination"
fi
