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

project_skills=(
  spec-project
  choose-technology
  build-project
  review-project
  ship-project
  audit-project
)

check_skill_layout() {
  local skills_root="$1"
  local context="$2"
  local expected_children actual_children expected_files actual_files support_dirs

  require_file "$skills_root/README.md"
  [[ ! -e "$skills_root/manage-skills" ]] ||
    fail "$context contains the generic local manage-skills payload"

  expected_children="$(printf '%s\n' "${project_skills[@]}" | LC_ALL=C sort)"
  actual_children="$(
    for child in "$skills_root"/*; do
      [[ -d "$child" ]] || continue
      basename "$child"
    done | LC_ALL=C sort
  )"
  [[ "$actual_children" = "$expected_children" ]] ||
    fail "$context skill children differ from the six Project-local routes"

  expected_files="$(
    printf '%s\n' "${project_skills[@]}" |
      sed 's#$#/SKILL.md#' | LC_ALL=C sort
  )"
  actual_files="$(
    find "$skills_root" -mindepth 2 -type f -print |
      sed "s#^$skills_root/##" | LC_ALL=C sort
  )"
  [[ "$actual_files" = "$expected_files" ]] ||
    fail "$context Project-local skill folders must contain only SKILL.md"

  support_dirs="$(find "$skills_root" -mindepth 2 -type d -print)"
  [[ -z "$support_dirs" ]] ||
    fail "$context contains Project-local skill support directories: $support_dirs"

  if rg --fixed-strings --quiet -- 'name: manage-skills' "$skills_root" ||
    rg --quiet -- 'npx skills (find|add)' "$skills_root"; then
    fail "$context contains a copied global skill-management payload"
  fi
}

skills_root="$repository_root/.agents/skills"
check_skill_layout "$skills_root" "seed"
for skill in "${project_skills[@]}"; do
  require_file "$repository_root/.agents/skills/$skill/SKILL.md"
  require_literal "name: $skill" "$repository_root/.agents/skills/$skill/SKILL.md"
  require_literal "description:" "$repository_root/.agents/skills/$skill/SKILL.md"
done

for index_contract in \
  '.agents/skills/<name>/SKILL.md' \
  'Project- or domain-specific' \
  'repeatable methods and evals' \
  'neither owns nor auto-updates' \
  'inventory existing Project-local' \
  'harness-native, installed, and Global capabilities' \
  'Cross-Project and Global Skills' \
  'chosen harness or plugin' \
  'outside the Project payload' \
  'installed optional manager' \
  'explicit authority'
do
  require_literal "$index_contract" "$skills_root/README.md"
done

require_file "$repository_root/scripts/create-project.sh"
require_file "$repository_root/README.md"
require_file "$repository_root/AGENTS.md"
require_file "$repository_root/LICENSE"
[[ ! -d "$repository_root/docs" ]] ||
  fail "seed contains a duplicate documentation surface"
[[ ! -d "$repository_root/assets" ]] ||
  fail "seed contains a cosmetic asset surface"

[[ ! -e "$repository_root/CLAUDE.md" ]] ||
  fail "CLAUDE.md must remain absent after reconciliation"
require_literal "\`CLAUDE.md\` is intentionally absent" "$repository_root/AGENTS.md"

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
require_literal "https://github.com/onlinesourdough/AIOS-template" "$repository_root/README.md"
require_literal "[Agentic Design System](https://github.com/onlinesourdough/Agentic-Design-System)" "$repository_root/README.md"
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
stale_ads_url="https://github.com/onlinesourdough/Design-template"
if rg --fixed-strings --quiet --glob '!tests/validate-project-template.sh' \
  -- "$stale_ads_url" "$repository_root"; then
  fail "stale Agentic Design System URL remains: $stale_ads_url"
fi
require_literal "scripts/create-project.sh" "$repository_root/README.md"
for in_place_contract in \
  "--in-place" \
  "--source-url" \
  "--source-sha" \
  "fresh empty Git history" \
  "historical provenance"; do
  require_literal "$in_place_contract" "$repository_root/README.md"
done
require_literal "pre-transition failure leaves the verified seed untouched" \
  "$repository_root/README.md"
require_literal "retained recovery directory" "$repository_root/README.md"
require_literal "re-enter that exact absolute path" "$repository_root/README.md"
require_literal "required only for this in-place route" "$repository_root/README.md"
require_literal "\`--canonical-url\` is optional" "$repository_root/README.md"
require_literal "never overwrites" "$repository_root/README.md"
require_literal "spec-project" "$repository_root/AGENTS.md"
require_literal "build-project" "$repository_root/AGENTS.md"
require_literal "review-project" "$repository_root/AGENTS.md"
require_literal "ship-project" "$repository_root/AGENTS.md"
require_literal "audit-project" "$repository_root/AGENTS.md"
require_literal "choose-technology" "$repository_root/AGENTS.md"
require_literal "Cost and usage acceptance case" "$repository_root/.agents/skills/choose-technology/SKILL.md"
choose_skill="$repository_root/.agents/skills/choose-technology/SKILL.md"
for technology_contract in \
  "Derive candidates from the Project's resolved responsibilities" \
  "Inspect current official sources" \
  "Do not retain a starter catalogue or default stack in Project truth."; do
  require_literal "$technology_contract" "$choose_skill"
done
spec_skill="$repository_root/.agents/skills/spec-project/SKILL.md"
for spec_readiness_contract in \
  "Preserve useful source material" \
  "Accept source material at any maturity" \
  "Rough idea:" \
  "Developed brief:" \
  "Near-complete specification:" \
  "Existing-system change request:" \
  "accept resolved AIOS intent, outcome, scope, proof," \
  "and authority as upstream truth." \
  "Return exactly one gate." \
  "### READY" \
  "### REVISE" \
  "### BLOCKED"; do
  require_literal "$spec_readiness_contract" "$spec_skill"
done
for spec_security_contract in \
  "Intentionally public and local-only Projects do not require authentication" \
  "managed session, OIDC, or OAuth" \
  "scoped API key or stronger service identity" \
  "verified request signature" \
  "JWT is conditional, not the default for APIs." \
  "configured algorithms, issuer, audience, time claims, and key rotation" \
  "expiry, revocation, and replay"; do
  require_literal "$spec_security_contract" "$spec_skill"
done

build_skill="$repository_root/.agents/skills/build-project/SKILL.md"
for build_security_contract in \
  "maintained framework, identity-provider, or protocol primitives" \
  "Fail closed in production" \
  "per action and resource" \
  "security-relevant failures visible through redacted, safe telemetry" \
  "authenticated-but-forbidden" \
  "Do not invent a universal scanner command."; do
  require_literal "$build_security_contract" "$build_skill"
done

review_skill="$repository_root/.agents/skills/review-project/SKILL.md"
require_literal "material gap in an applicable security responsibility" "$review_skill"
require_literal "is a Required finding." "$review_skill"

audit_skill="$repository_root/.agents/skills/audit-project/SKILL.md"
require_literal "security drift" "$audit_skill"
require_literal "intentionally public interfaces" "$audit_skill"

require_literal "Proportional security baseline" "$repository_root/README.md"
require_literal \
  "Public and local-only Projects do not gain authentication by default." \
  "$repository_root/README.md"

for audit_contract in \
  "exact Git root" \
  "credential-free remote identity" \
  "fresh fetched live upstream object" \
  "equal, behind, ahead, or diverged" \
  "Cached tracking refs and a clean worktree are not live proof." \
  "Do not fast-forward, commit, push, stash, rebase, merge, or force"; do
  require_literal "$audit_contract" "$audit_skill"
done

ship_skill="$repository_root/.agents/skills/ship-project/SKILL.md"
for ship_contract in \
  "Git delivery gate" \
  "reviewed exact commit" \
  "fresh fetch" \
  "normal non-force push" \
  "Do not auto-merge, rebase, or force" \
  "local HEAD equals the fresh fetched live branch object" \
  "Local-only Projects and Projects without a remote do not need this Git gate."; do
  require_literal "$ship_contract" "$ship_skill"
done

if rg -n -i --glob '!.git/**' \
  '(cloudflare|github pages).{0,40}\\b(required|mandatory|default)\\b' "$repository_root"; then
  fail "mandatory workflow or provider language remains"
fi
if rg --files -uu --glob '!.git/**' --glob '!node_modules/**' "$repository_root" |
  rg -i '(free-for-dev\\.md|price.*catalog|catalog.*price)'; then
  fail "static price catalogue path remains"
fi
if rg --quiet '!\[[^]]*\]\([^)]*\)' "$repository_root/README.md"; then
  fail "README contains a cosmetic image route"
fi

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
done < <(cd "$repository_root" && rg --files -uu --glob '*.md' \
  --glob '!.git/**' --glob '!node_modules/**')

# The validator contains the legacy literals it rejects. It is the sole
# intentional allowlist; no current instruction, resource, test, or asset may
# carry the former public identity or skill paths.
legacy_scan_exclusion='tests/validate-project-template.sh'
legacy_pattern='Solution-template|solution-template-overview|spec-solution|build-solution|review-solution|ship-solution|audit-solution|Agentic-videoeditor|Design-template'
if rg -n -uu --glob '!.git/**' --glob '!node_modules/**' \
  --glob "!$legacy_scan_exclusion" "$legacy_pattern" "$repository_root"; then
  fail "stale public identity or path remains"
fi

if rg -n -uu --glob '!.git/**' --glob '!node_modules/**' \
  --glob '!tests/validate-project-template.sh' 'manage-skills|Skills Atlas' "$repository_root"; then
  fail "removed local manager route or excluded Project state remains"
fi

if rg --files -uu --glob '!.git/**' --glob '!node_modules/**' "$repository_root" |
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
    .agents/skills/README.md \
    .agents/skills/spec-project/SKILL.md \
    .agents/skills/choose-technology/SKILL.md \
    .agents/skills/build-project/SKILL.md \
    .agents/skills/review-project/SKILL.md \
    .agents/skills/ship-project/SKILL.md \
    .agents/skills/audit-project/SKILL.md \
    docs/ownership.md docs/proof.md docs/recovery.md; do
    require_file "$project/$file"
  done

  check_skill_layout "$project/.agents/skills" "created Project $expected_name"

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
  require_literal "Security and denial evidence" "$project/docs/proof.md"
  require_literal "Production security misconfiguration fails closed where protection is required" \
    "$project/docs/proof.md"
  require_literal "JWT is conditional, not the default for APIs." \
    "$project/.agents/skills/spec-project/SKILL.md"
  require_literal "authenticated-but-forbidden" \
    "$project/.agents/skills/build-project/SKILL.md"

  cmp -s "$repository_root/.agents/skills/README.md" \
    "$project/.agents/skills/README.md" ||
    fail "created Project did not receive the current local skill index"
  for lifecycle_skill in "${project_skills[@]}"; do
    cmp -s "$repository_root/.agents/skills/$lifecycle_skill/SKILL.md" \
      "$project/.agents/skills/$lifecycle_skill/SKILL.md" ||
      fail "created Project did not receive current $lifecycle_skill skill"
  done

  for excluded in assets tests scripts; do
    [[ ! -e "$project/$excluded" ]] || fail "seed-only path copied: $excluded"
  done
  while IFS= read -r markdown; do
    check_local_links "$project/$markdown"
  done < <(cd "$project" && rg --files -uu --glob '*.md' --glob '!.git/**')
  [[ ! -e "$project/.git/refs/remotes/origin" ]] ||
    fail "created Project inherited origin refs"
  if rg -n -uu --glob '!.git/**' \
    'Agentic Project Template|APT|Solution-template|spec-solution|build-solution|review-solution|ship-solution|audit-solution|Agentic-videoeditor|manage-skills|Skills Atlas|template-owned\.psv|#19|#17' \
    "$project"; then
    fail "created Project inherited seed identity or issue state"
  fi
}

check_created_project "$standalone_project" "Standalone Proof" "Prove independent ownership"
check_created_project "$aios_project" "AIOS Proof" "Prove the direct AIOS creation path"
require_literal "https://example.test/standalone-proof" "$standalone_project/README.md"
printf 'out-of-place creation proof: standalone=%s aios=%s history=empty remotes=0 skills=6 support-files=absent\n' \
  "$standalone_project" "$aios_project"

in_place_source_url='https://github.com/onlinesourdough/Agentic-project-template.git'

make_seed_fixture() {
  local seed="$1"

  mkdir -p "$seed"
  cp -R "$repository_root/." "$seed/"
  rm -rf "$seed/.git"
  git -C "$seed" -c init.defaultBranch=main init --quiet
  git -C "$seed" add .
  git -C "$seed" -c user.name='APT validation' \
    -c user.email='apt-validation@example.test' commit --quiet \
    -m 'Verified APT seed fixture'
  git -C "$seed" remote add origin "$in_place_source_url"
}

assert_verified_seed() {
  local seed="$1"
  local expected_sha="$2"
  local context="$3"

  [[ -d "$seed/.git" ]] || fail "$context did not retain the seed Git directory"
  [[ "$(git -C "$seed" rev-parse HEAD)" = "$expected_sha" ]] ||
    fail "$context changed the verified seed revision"
  [[ -z "$(git -C "$seed" status --porcelain=v1)" ]] ||
    fail "$context left the verified seed dirty"
  require_file "$seed/scripts/create-project.sh"
  require_file "$seed/tests/validate-project-template.sh"
}

assert_no_transition_artifacts() {
  local parent="$1"
  local context="$2"
  local artifacts

  artifacts="$(find "$parent" -maxdepth 1 -type d \
    \( -name '.project-create.*' -o -name '.apt-seed-recovery.*' \) -print)"
  [[ -z "$artifacts" ]] ||
    fail "$context left private transition artifacts: $artifacts"
}

require_output_literal() {
  local needle="$1"
  local output="$2"
  local context="$3"

  case "$output" in
    *"$needle"*) ;;
    *) fail "$context did not report: $needle" ;;
  esac
}

in_place_seed="$temporary_root/in-place-project"
make_seed_fixture "$in_place_seed"
in_place_sha="$(git -C "$in_place_seed" rev-parse HEAD)"
in_place_path_before="$(cd "$in_place_seed" && pwd -P)"
(
  cd "$in_place_seed"
  in_place_success_output="$(bash scripts/create-project.sh --in-place \
    --name "In-place Proof" \
    --outcome "Prove same-root ownership transfer" \
    --source-url "$in_place_source_url" \
    --source-sha "$in_place_sha")"
  require_output_literal "Re-enter Project root before continuing" \
    "$in_place_success_output" "successful in-place creation"
  cd "$in_place_path_before"
  [[ "$(pwd -P)" = "$in_place_path_before" ]] ||
    fail "in-place caller could not re-enter the final Project path"
  [[ "$(git rev-parse --show-toplevel)" = "$in_place_path_before" ]] ||
    fail "post-transition attestation did not resolve the final Project root"
)
in_place_path_after="$(cd "$in_place_seed" && pwd -P)"
[[ "$in_place_path_after" = "$in_place_path_before" ]] ||
  fail "in-place creation changed the final filesystem path"
[[ "$(git -C "$in_place_seed" rev-parse --show-toplevel)" = \
  "$in_place_path_after" ]] ||
  fail "in-place creation did not leave the Project at the exact Git top level"
check_created_project "$in_place_seed" "In-place Proof" \
  "Prove same-root ownership transfer"
require_literal "$in_place_source_url@$in_place_sha" \
  "$in_place_seed/docs/ownership.md"
require_literal "Historical provenance" "$in_place_seed/docs/ownership.md"
assert_no_transition_artifacts "$temporary_root" "successful in-place creation"
printf 'in-place transition proof: before=%s after=%s source=%s@%s history=empty remotes=0 skills=6 seed-only-paths=absent\n' \
  "$in_place_path_before" "$in_place_path_after" "$in_place_source_url" \
  "$in_place_sha"

guarded_seed="$temporary_root/guarded-seed"
make_seed_fixture "$guarded_seed"
guarded_sha="$(git -C "$guarded_seed" rev-parse HEAD)"
git -C "$guarded_seed" remote set-url origin \
  "https://example.test/not-the-seed.git"
if wrong_source_output="$(
  (
    cd "$guarded_seed"
    bash scripts/create-project.sh --in-place \
      --name "Wrong Source" --outcome "Must fail" \
      --source-url "$in_place_source_url" \
      --source-sha "$guarded_sha"
  ) 2>&1
)"; then
  fail "in-place creation accepted the wrong source URL"
fi
require_output_literal "source URL mismatch: expected $in_place_source_url" \
  "$wrong_source_output" "wrong-source guard"
assert_verified_seed "$guarded_seed" "$guarded_sha" "wrong-source guard"
git -C "$guarded_seed" remote set-url origin "$in_place_source_url"

if wrong_revision_output="$(
  (
    cd "$guarded_seed"
    bash scripts/create-project.sh --in-place \
      --name "Wrong Revision" --outcome "Must fail" \
      --source-url "$in_place_source_url" \
      --source-sha "0000000000000000000000000000000000000000"
  ) 2>&1
)"; then
  fail "in-place creation accepted the wrong source revision"
fi
require_output_literal "source revision mismatch: expected" \
  "$wrong_revision_output" "wrong-revision guard"
assert_verified_seed "$guarded_seed" "$guarded_sha" "wrong-revision guard"

touch "$guarded_seed/existing-state.txt"
if dirty_seed_output="$(
  (
    cd "$guarded_seed"
    bash scripts/create-project.sh --in-place \
      --name "Dirty Seed" --outcome "Must fail" \
      --source-url "$in_place_source_url" \
      --source-sha "$guarded_sha"
  ) 2>&1
)"; then
  fail "in-place creation accepted a dirty seed"
fi
require_output_literal "--in-place source must be clean" \
  "$dirty_seed_output" "dirty-seed guard"
require_file "$guarded_seed/existing-state.txt"
[[ "$(git -C "$guarded_seed" rev-parse HEAD)" = "$guarded_sha" ]] ||
  fail "dirty-seed guard changed the verified seed revision"
rm "$guarded_seed/existing-state.txt"
assert_verified_seed "$guarded_seed" "$guarded_sha" "dirty-seed guard"

existing_readme="$temporary_root/existing-project-readme"
cp "$standalone_project/README.md" "$existing_readme"
if existing_project_output="$(
  (
    cd "$standalone_project"
    bash "$repository_root/scripts/create-project.sh" --in-place \
      --name "Existing Project" --outcome "Must remain unchanged" \
      --source-url "$in_place_source_url" \
      --source-sha "$guarded_sha"
  ) 2>&1
)"; then
  fail "in-place creation accepted an existing Project root"
fi
require_output_literal "--in-place must run from the APT seed root" \
  "$existing_project_output" "existing-Project guard"
cmp -s "$standalone_project/README.md" "$existing_readme" ||
  fail "existing Project changed after rejected in-place creation"

generation_seed="$temporary_root/generation-failure-seed"
make_seed_fixture "$generation_seed"
generation_sha="$(git -C "$generation_seed" rev-parse HEAD)"
real_git="$(command -v git)"
fake_git_bin="$temporary_root/fake-git-bin"
mkdir -p "$fake_git_bin"
cat > "$fake_git_bin/git" <<EOF
#!/usr/bin/env bash
for argument in "\$@"; do
  if [[ "\$argument" = init ]]; then
    exit 91
  fi
done
exec "$real_git" "\$@"
EOF
chmod +x "$fake_git_bin/git"
if generation_failure_output="$(
  (
    cd "$generation_seed"
    PATH="$fake_git_bin:$PATH" bash scripts/create-project.sh --in-place \
      --name "Generation Failure" --outcome "Restore the seed" \
      --source-url "$in_place_source_url" \
      --source-sha "$generation_sha"
  ) 2>&1
)"; then
  fail "in-place creation survived an injected generation failure"
fi
require_output_literal "could not initialize generated Project Git repository" \
  "$generation_failure_output" "generation-failure recovery"
assert_verified_seed "$generation_seed" "$generation_sha" \
  "generation-failure recovery"
assert_no_transition_artifacts "$temporary_root" "generation-failure recovery"

late_state_seed="$temporary_root/late-state-seed"
make_seed_fixture "$late_state_seed"
late_state_sha="$(git -C "$late_state_seed" rev-parse HEAD)"
fake_late_state_git_bin="$temporary_root/fake-late-state-git-bin"
mkdir -p "$fake_late_state_git_bin"
cat > "$fake_late_state_git_bin/git" <<EOF
#!/usr/bin/env bash
for argument in "\$@"; do
  if [[ "\$argument" = init ]]; then
    touch "$late_state_seed/late-existing-state.txt"
  fi
done
exec "$real_git" "\$@"
EOF
chmod +x "$fake_late_state_git_bin/git"
if late_state_output="$(
  (
    cd "$late_state_seed"
    PATH="$fake_late_state_git_bin:$PATH" bash scripts/create-project.sh --in-place \
      --name "Late State" --outcome "Must remain a seed" \
      --source-url "$in_place_source_url" \
      --source-sha "$late_state_sha"
  ) 2>&1
)"; then
  fail "in-place creation removed state introduced during generation"
fi
require_output_literal "--in-place source must be clean" \
  "$late_state_output" "pre-transition seed recheck"
require_file "$late_state_seed/late-existing-state.txt"
[[ "$(git -C "$late_state_seed" rev-parse HEAD)" = "$late_state_sha" ]] ||
  fail "pre-transition seed recheck changed the verified revision"
rm "$late_state_seed/late-existing-state.txt"
assert_verified_seed "$late_state_seed" "$late_state_sha" \
  "pre-transition seed recheck"
assert_no_transition_artifacts "$temporary_root" "pre-transition seed recheck"

transition_seed="$temporary_root/transition-failure-seed"
make_seed_fixture "$transition_seed"
transition_sha="$(git -C "$transition_seed" rev-parse HEAD)"
real_mv="$(command -v mv)"
fake_mv_bin="$temporary_root/fake-mv-bin"
mv_counter="$temporary_root/mv-counter"
mkdir -p "$fake_mv_bin"
cat > "$fake_mv_bin/mv" <<EOF
#!/usr/bin/env bash
count=0
if [[ -f "$mv_counter" ]]; then
  count="\$(<"$mv_counter")"
fi
count=\$((count + 1))
printf '%s\n' "\$count" > "$mv_counter"
if [[ "\$count" = 2 ]]; then
  exit 92
fi
exec "$real_mv" "\$@"
EOF
chmod +x "$fake_mv_bin/mv"
if transition_failure_output="$(
  (
    cd "$transition_seed"
    PATH="$fake_mv_bin:$PATH" bash scripts/create-project.sh --in-place \
      --name "Transition Failure" --outcome "Restore the seed" \
      --source-url "$in_place_source_url" \
      --source-sha "$transition_sha"
  ) 2>&1
)"; then
  fail "in-place creation survived an injected transition failure"
fi
require_output_literal "could not install the generated Project at the final root" \
  "$transition_failure_output" "transition-failure recovery"
require_output_literal "restored verified seed after failed transition" \
  "$transition_failure_output" "transition-failure recovery"
assert_verified_seed "$transition_seed" "$transition_sha" \
  "transition-failure recovery"
assert_no_transition_artifacts "$temporary_root" "transition-failure recovery"

retained_seed="$temporary_root/retained-recovery-seed"
make_seed_fixture "$retained_seed"
retained_sha="$(git -C "$retained_seed" rev-parse HEAD)"
fake_retained_mv_bin="$temporary_root/fake-retained-mv-bin"
retained_mv_counter="$temporary_root/retained-mv-counter"
mkdir -p "$fake_retained_mv_bin"
cat > "$fake_retained_mv_bin/mv" <<EOF
#!/usr/bin/env bash
count=0
if [[ -f "$retained_mv_counter" ]]; then
  count="\$(<"$retained_mv_counter")"
fi
count=\$((count + 1))
printf '%s\n' "\$count" > "$retained_mv_counter"
if [[ "\$count" = 2 || "\$count" = 3 ]]; then
  exit 93
fi
exec "$real_mv" "\$@"
EOF
chmod +x "$fake_retained_mv_bin/mv"
if retained_recovery_output="$(
  (
    cd "$retained_seed"
    PATH="$fake_retained_mv_bin:$PATH" bash scripts/create-project.sh --in-place \
      --name "Retained Recovery" --outcome "Retain the verified seed" \
      --source-url "$in_place_source_url" \
      --source-sha "$retained_sha"
  ) 2>&1
)"; then
  fail "in-place creation survived failed installation and restoration"
fi
require_output_literal "could not install the generated Project at the final root" \
  "$retained_recovery_output" "retained-recovery failure"
require_output_literal "recovery required; verified seed retained at:" \
  "$retained_recovery_output" "retained-recovery failure"
retained_recovery_directory="$(find "$temporary_root" -maxdepth 1 -type d \
  -name '.apt-seed-recovery.*' -print)"
[[ -n "$retained_recovery_directory" && \
  "$retained_recovery_directory" != *$'\n'* ]] ||
  fail "retained-recovery failure did not leave exactly one recovery directory"
[[ ! -e "$retained_seed" ]] ||
  fail "retained-recovery failure left an ambiguous final path"
assert_verified_seed "$retained_recovery_directory" "$retained_sha" \
  "retained-recovery failure"
printf 'retained recovery proof: source=%s recovery=%s revision=%s\n' \
  "$retained_seed" "$retained_recovery_directory" "$retained_sha"

if bash "$repository_root/scripts/create-project.sh" "$standalone_project" \
  --name "Duplicate" --outcome "Must fail" >/dev/null 2>&1; then
  fail "creation unexpectedly overwrote an existing destination"
fi
require_literal "# Standalone Proof" "$standalone_project/README.md"

printf 'project template validation: PASS\n'
