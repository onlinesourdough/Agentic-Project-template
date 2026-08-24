#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
temporary_root="$(mktemp -d)"
trap 'rm -rf "$temporary_root"' EXIT HUP INT TERM

fail() {
  printf 'template validation: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "missing required file: $1"
}

require_literal() {
  local needle="$1"
  local file="$2"
  rg --fixed-strings --quiet -- "$needle" "$file" ||
    fail "missing required contract text $needle in $file"
}

for skill in spec-project build-project review-project ship-project audit-project choose-technology manage-skills; do
  require_file "$repository_root/.agents/skills/$skill/SKILL.md"
  require_literal "name: $skill" "$repository_root/.agents/skills/$skill/SKILL.md"
  require_literal "description:" "$repository_root/.agents/skills/$skill/SKILL.md"
done

require_file "$repository_root/.agents/skills/spec-project/examples/acceptance-cases.md"
require_file "$repository_root/.agents/skills/choose-technology/references/full-stack-fastapi.md"
require_file "$repository_root/.agents/skills/audit-project/agents/openai.yaml"
require_file "$repository_root/scripts/create-project.sh"
require_file "$repository_root/docs/creation.md"
require_file "$repository_root/README.md"
require_file "$repository_root/AGENTS.md"
require_file "$repository_root/LICENSE"

[[ ! -e "$repository_root/CLAUDE.md" ]] ||
  fail "CLAUDE.md must remain absent after reconciliation"
require_literal "\`CLAUDE.md\` is intentionally absent" "$repository_root/AGENTS.md"
require_literal "\`CLAUDE.md\` is intentionally absent" "$repository_root/docs/creation.md"

[[ ! -e "$repository_root/.agents/skills/spec-solution" ]] ||
  fail "obsolete spec-solution skill remains"
[[ ! -e "$repository_root/.agents/skills/build-solution" ]] ||
  fail "obsolete build-solution skill remains"
[[ ! -e "$repository_root/.agents/skills/review-solution" ]] ||
  fail "obsolete review-solution skill remains"
[[ ! -e "$repository_root/.agents/skills/ship-solution" ]] ||
  fail "obsolete ship-solution skill remains"
[[ ! -e "$repository_root/.agents/skills/audit-solution" ]] ||
  fail "obsolete audit-solution skill remains"
[[ ! -e "$repository_root/tests/validate-spec-solution.sh" ]] ||
  fail "obsolete validation script remains"
[[ ! -e "$repository_root/assets/solution-template-overview-v2.svg" ]] ||
  fail "obsolete workflow illustration remains"

require_literal "![Agentic Project Template workflow](assets/agentic-project-template-overview.svg)" "$repository_root/README.md"
require_literal "https://github.com/onlinesourdough/AIOS-template" "$repository_root/README.md"
require_literal "https://github.com/onlinesourdough/Design-template" "$repository_root/README.md"
require_literal "https://github.com/onlinesourdough/Agentic-Content-System" "$repository_root/README.md"
require_literal "https://github.com/onlinesourdough/Agentic-project-template" "$repository_root/README.md"
for stale_owner in gustavonline onlinesourdough; do
  stale_pattern="https://github\\.com/$stale_owner/AIOS(\$|[^-A-Za-z0-9])"
  if rg --quiet -- "$stale_pattern" "$repository_root/README.md"; then
    fail "stale canonical link remains for $stale_owner/AIOS"
  fi
done
stale_link="https://github.com/onlinesourdough/Agentic-videoeditor"
if rg --fixed-strings --quiet -- "$stale_link" "$repository_root/README.md"; then
  fail "stale canonical link remains: $stale_link"
fi
require_literal "scripts/create-project.sh" "$repository_root/README.md"
require_literal "docs/creation.md" "$repository_root/README.md"
require_literal "spec-project" "$repository_root/AGENTS.md"
require_literal "build-project" "$repository_root/AGENTS.md"
require_literal "review-project" "$repository_root/AGENTS.md"
require_literal "ship-project" "$repository_root/AGENTS.md"
require_literal "audit-project" "$repository_root/AGENTS.md"
require_literal "choose-technology" "$repository_root/AGENTS.md"
require_literal "manage-skills" "$repository_root/AGENTS.md"
require_literal "Agentic Project Template workflow</title>" "$repository_root/assets/agentic-project-template-overview.svg"

readme_image_count="$(rg -o --no-filename '!\[[^]]*\]\([^)]*\)' "$repository_root/README.md" | wc -l | tr -d '[:space:]')"
[[ "$readme_image_count" = 1 ]] ||
  fail "README must contain exactly one illustration; found $readme_image_count"

check_local_links() {
  local markdown="$1"
  local link target
  while IFS= read -r link; do
    target="${link##*](}"
    target="${target%)}"
    target="${target%%#*}"
    case "$target" in
      ''|http://*|https://*|mailto:*|\#*) continue ;;
    esac
    [[ -e "$(dirname "$markdown")/$target" ]] ||
      fail "broken local link $target in $markdown"
  done < <(rg -o --no-filename '\]\([^)]*\)' "$markdown" || true)
}

while IFS= read -r markdown; do
  check_local_links "$repository_root/$markdown"
done < <(cd "$repository_root" && rg --files -uu --glob '*.md' --glob '!.git/**')

# The validator contains the legacy literals it rejects. It is the sole
# intentional allowlist; no current instruction, resource, test, or asset may
# carry the former public identity or skill paths.
legacy_scan_exclusion='tests/validate-project-template.sh'
legacy_pattern='Solution-template|solution-template-overview|spec-solution|build-solution|review-solution|ship-solution|audit-solution|Agentic-videoeditor'
if rg -n -uu --glob '!.git/**' --glob "!$legacy_scan_exclusion" "$legacy_pattern" "$repository_root"; then
  fail "stale public identity or path remains"
fi

if rg --files -uu --glob '!.git/**' "$repository_root" |
  rg -n '(^|/)(spec-solution|build-solution|review-solution|ship-solution|audit-solution|validate-spec-solution\.sh|solution-template-overview-v2\.svg)($|/)'; then
  fail "stale public path remains"
fi

for obsolete in capability-profiles/advanced-full-stack-python.md TECHNOLOGY.md; do
  [[ ! -e "$repository_root/$obsolete" ]] || fail "obsolete file remains: $obsolete"
done

bash -n "$repository_root/scripts/create-project.sh"
bash -n "$repository_root/tests/validate-project-template.sh"

standalone_project="$temporary_root/standalone-project"
aios_parent="$temporary_root/aios/projects"
aios_project="$aios_parent/aios-project"
mkdir -p "$aios_parent"

bash "$repository_root/scripts/create-project.sh" "$standalone_project" \
  --name "Standalone Proof" \
  --outcome "Prove independent ownership" \
  --canonical-url "https://example.test/standalone-proof" >/dev/null
bash "$repository_root/scripts/create-project.sh" "$aios_project" \
  --name "AIOS Proof" \
  --outcome "Prove the direct AIOS creation path" >/dev/null

check_created_project() {
  local project="$1"
  local expected_name="$2"
  local expected_outcome="$3"

  for file in AGENTS.md README.md LICENSE .gitignore \
    .agents/skills/spec-project/SKILL.md \
    .agents/skills/build-project/SKILL.md \
    .agents/skills/review-project/SKILL.md \
    .agents/skills/ship-project/SKILL.md \
    .agents/skills/audit-project/SKILL.md \
    .agents/skills/choose-technology/SKILL.md \
    .agents/skills/manage-skills/SKILL.md \
    docs/ownership.md docs/proof.md docs/recovery.md; do
    require_file "$project/$file"
  done

  [[ -d "$project/.git" ]] || fail "created Project has no fresh Git directory"
  [[ "$(git -C "$project" rev-parse --is-inside-work-tree)" = true ]] ||
    fail "created Project is not a Git worktree"
  [[ -z "$(git -C "$project" remote)" ]] ||
    fail "created Project inherited a Git remote"
  if git -C "$project" rev-parse --verify HEAD >/dev/null 2>&1; then
    fail "created Project inherited Git history"
  fi

  require_literal "# $expected_name" "$project/README.md"
  require_literal "$expected_outcome" "$project/README.md"
  require_literal "$expected_name" "$project/AGENTS.md"
  require_literal "$expected_outcome" "$project/docs/proof.md"

  for excluded in docs/creation.md assets tests scripts; do
    [[ ! -e "$project/$excluded" ]] || fail "seed-only path copied: $excluded"
  done
  while IFS= read -r markdown; do
    check_local_links "$project/$markdown"
  done < <(cd "$project" && rg --files -uu --glob '*.md' --glob '!.git/**')
  [[ ! -e "$project/.git/refs/remotes/origin" ]] ||
    fail "created Project inherited origin refs"
  if rg -n -uu --glob '!.git/**' \
    'Agentic Project Template|APT|Solution-template|spec-solution|build-solution|review-solution|ship-solution|audit-solution|Agentic-videoeditor|#19|#17' \
    "$project"; then
    fail "created Project inherited seed identity or issue state"
  fi
}

check_created_project "$standalone_project" "Standalone Proof" "Prove independent ownership"
check_created_project "$aios_project" "AIOS Proof" "Prove the direct AIOS creation path"
require_literal "https://example.test/standalone-proof" "$standalone_project/README.md"

if bash "$repository_root/scripts/create-project.sh" "$standalone_project" \
  --name "Duplicate" --outcome "Must fail" >/dev/null 2>&1; then
  fail "creation unexpectedly overwrote an existing destination"
fi
require_literal "# Standalone Proof" "$standalone_project/README.md"

printf 'project template validation: PASS\n'
