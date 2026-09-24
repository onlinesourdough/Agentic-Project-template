#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
temporary_root="$(mktemp -d "${TMPDIR:-/tmp}/apt-validation.XXXXXX")"
temporary_root="$(cd "$temporary_root" && pwd -P)"
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

# The seed and its generated projects carry only the specialist shelf index.
# Shared method behavior is validated by AIOS, not copied here as wording tests.
check_skill_layout() {
  local skills_root="$1"
  local context="$2"
  require_file "$skills_root/README.md"
  local extra
  extra="$(find "$skills_root" -mindepth 1 ! -path "$skills_root/README.md" -print)"
  [[ -z "$extra" ]] || fail "$context contains a copied skill payload: $extra"
}

skills_root="$repository_root/.agents/skills"
check_skill_layout "$skills_root" "seed"
for file in scripts/create-project.sh scripts/foundation-content.sh README.md AGENTS.md LICENSE \
  assets/branding/project-banner.png assets/branding/project-icon.png; do
  require_file "$repository_root/$file"
done
check_instruction_adapter() {
  local root="$1"
  require_file "$root/AGENTS.md"
  # A native import must resolve locally and contain no second instruction body.
  cmp -s "$root/CLAUDE.md" <(printf '%s\n' '@AGENTS.md') ||
    fail "Claude adapter must import the single maintained AGENTS source: $root"
}
check_instruction_adapter "$repository_root"
for skill in aios-spec-work aios-build-work aios-review-work aios-ship-work; do
  require_literal "$skill" "$repository_root/AGENTS.md"
done
require_literal "https://github.com/onlinesourdough/AIOS-Plugin" "$repository_root/README.md"

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

if rg -n -uu --glob '!.git/**' --glob '!tests/validate-project-template.sh' \
  '\.agents/skills/(spec|build|review|ship|audit)-(project|solution)/|\.agents/skills/choose-technology/' "$repository_root"; then
  fail "local generic lifecycle route remains"
fi

bash -n "$repository_root/scripts/create-project.sh"
bash -n "$repository_root/scripts/foundation-content.sh"
bash -n "$repository_root/tests/validate-project-template.sh"

standalone_project="$temporary_root/standalone-project"
chosen_parent="$temporary_root/customer work"
chosen_project="$chosen_parent/forecast tool"
mkdir -p "$chosen_parent"

bash "$repository_root/scripts/create-project.sh" "$standalone_project" \
  --name "Standalone Proof" \
  --outcome "Prove independent ownership" \
  --canonical-url "https://example.test/standalone-proof" >/dev/null
chosen_output="$(bash "$repository_root/scripts/create-project.sh" "$chosen_project" \
  --name "Destination Proof" \
  --outcome "Use the caller-selected repository")"
[[ "$chosen_output" = "Created Project: $chosen_project" ]] ||
  fail "creation did not return the caller's actual destination"
[[ "$(git -C "$chosen_project" rev-parse --show-toplevel)" = "$chosen_project" ]] ||
  fail "creation placed Git outside the chosen root"
application_project="$temporary_root/application-project"
bash "$repository_root/scripts/create-project.sh" "$application_project" \
  --name "Application Proof" --outcome "Serve a small local application" \
  --kind application >/dev/null
api_project="$temporary_root/api-project"
bash "$repository_root/scripts/create-project.sh" "$api_project" \
  --name "API Proof" --outcome "Expose a documented interface" \
  --kind api >/dev/null
cli_project="$temporary_root/cli-project"
bash "$repository_root/scripts/create-project.sh" "$cli_project" \
  --name "CLI Proof" --outcome "Provide a command interface" \
  --kind cli >/dev/null

check_created_project() {
  local project="$1"
  local expected_name="$2"
  local expected_outcome="$3"
  local kind="${4:-general}"

  for file in AGENTS.md CLAUDE.md README.md CONTRIBUTING.md .gitignore \
    .agents/skills/README.md \
    docs/README.md docs/template-license.txt; do
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
  require_literal "No application," "$project/README.md"
  [[ ! -e "$project/LICENSE" ]] || fail "template license became a product license"
  require_literal "Copyright (c) 2026 Gustav Anderson" "$project/docs/template-license.txt"
  require_literal "does not license later product code" "$project/docs/template-license.txt"
  cmp -s <(tail -n +3 "$project/docs/template-license.txt") "$repository_root/LICENSE" ||
    fail "template license notice changed in generated project"
  [[ ! -e "$project/docs/ownership.md" && ! -e "$project/docs/proof.md" &&
     ! -e "$project/docs/recovery.md" ]] ||
    fail "obsolete boilerplate notes were generated"
  for skill in aios-spec-work aios-build-work aios-review-work aios-ship-work; do
    require_literal "$skill" "$project/AGENTS.md"
  done
  cmp -s "$repository_root/.agents/skills/README.md" \
    "$project/.agents/skills/README.md" || fail "specialist shelf index changed during creation"

  check_instruction_adapter "$project"
  # Check the actual payload boundary, not prose promising an independent role.
  # No registry, shared method copies, runtime, design/content placeholders or
  # harness configuration should be created alongside these owned files.
  local actual_files expected_files
  actual_files="$(cd "$project" && rg --files -uu --glob '!.git/**' | LC_ALL=C sort)"
  if [[ "$kind" = general ]]; then
    expected_files="$(printf '%s\n' .agents/skills/README.md .gitignore AGENTS.md \
      CLAUDE.md README.md CONTRIBUTING.md docs/README.md docs/template-license.txt | LC_ALL=C sort)"
  else
    expected_files="$(printf '%s\n' .agents/skills/README.md .gitignore AGENTS.md \
      CLAUDE.md README.md CONTRIBUTING.md docs/README.md docs/template-license.txt \
      ARCHITECTURE.md DESIGN.md SECURITY.md docs/operations.md \
      docs/deployment.md docs/infrastructure.md | LC_ALL=C sort)"
  fi
  [[ "$actual_files" = "$expected_files" ]] || fail "unexpected generated payload: $actual_files"
  local actual_directories expected_directories
  actual_directories="$(cd "$project" && find . -type d -not -path './.git*' | LC_ALL=C sort)"
  expected_directories="$(printf '%s\n' . ./.agents ./.agents/skills ./docs | LC_ALL=C sort)"
  [[ "$actual_directories" = "$expected_directories" ]] ||
    fail "unexpected generated directories: $actual_directories"
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
check_created_project "$chosen_project" "Destination Proof" "Use the caller-selected repository"
check_created_project "$application_project" "Application Proof" "Serve a small local application" application
check_created_project "$api_project" "API Proof" "Expose a documented interface" api
check_created_project "$cli_project" "CLI Proof" "Provide a command interface" cli
require_literal "# Interface contract" "$api_project/DESIGN.md"
require_literal "selected interface kind is api" "$api_project/DESIGN.md"
require_literal "selected interface kind is cli" "$cli_project/DESIGN.md"
require_literal "every three hours" "$application_project/docs/operations.md"
require_literal "No provider" "$application_project/docs/deployment.md"
invalid_kind="$temporary_root/invalid-kind"
if bash "$repository_root/scripts/create-project.sh" "$invalid_kind" \
  --name "Invalid" --outcome "Reject an unsupported kind" \
  --kind factory >/dev/null 2>&1; then
  fail "creation accepted an unsupported kind"
fi
[[ ! -e "$invalid_kind" ]] || fail "unsupported kind created a destination"
for project in "$standalone_project" "$application_project"; do
  for ignored in .env .env.production .dev.vars .local/cache node_modules/cache .venv/lib .wrangler/state; do
    git -C "$project" check-ignore --quiet "$ignored" ||
      fail "credential or local state was not ignored: $ignored"
  done
  for tracked in .env.example .dev.vars.example package-lock.json pnpm-lock.yaml src/main.ts config.local.json .vscode/settings.json; do
    if git -C "$project" check-ignore --quiet "$tracked"; then
      fail "source or example was ignored: $tracked"
    fi
  done
done
require_literal "https://example.test/standalone-proof" "$standalone_project/README.md"
printf 'out-of-place creation proof: standalone=%s chosen=%s history=empty remotes=0 skills=0 shared-routes=4\n' \
  "$standalone_project" "$chosen_project"

# Extra methods in a locally customized seed must not leak into a new Project.
whitelist_seed="$temporary_root/whitelist-seed"
mkdir -p "$whitelist_seed"
cp -R "$repository_root/." "$whitelist_seed/"
mkdir -p "$whitelist_seed/.agents/skills/spec-project"
printf '%s\n' 'unexpected copied method' > "$whitelist_seed/.agents/skills/spec-project/SKILL.md"
bash "$whitelist_seed/scripts/create-project.sh" "$temporary_root/whitelist-project" \
  --name "Whitelist Proof" --outcome "No copied generic skill" >/dev/null
check_skill_layout "$temporary_root/whitelist-project/.agents/skills" "payload whitelist"

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
  "$in_place_seed/README.md"
require_literal "historical provenance" "$in_place_seed/README.md"
assert_no_transition_artifacts "$temporary_root" "successful in-place creation"
printf 'in-place transition proof: before=%s after=%s source=%s@%s history=empty remotes=0 skills=0 shared-routes=4 seed-only-paths=absent\n' \
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

# Identity and caller-location guards must reject without converting the seed.
for guard in branch remote push-url subdirectory ignored-state tracked-state; do
  case "$guard" in
    branch) git -C "$guarded_seed" checkout --quiet -b wrong-branch ;;
    remote) git -C "$guarded_seed" remote add unexpected https://example.test/other.git ;;
    push-url) git -C "$guarded_seed" remote set-url --push origin https://example.test/push.git ;;
    ignored-state) printf '%s\n' 'synthetic secret fixture' > "$guarded_seed/.env" ;;
    tracked-state) printf '%s\n' 'local owner change' >> "$guarded_seed/README.md" ;;
  esac
  if (
    cd "$guarded_seed"
    if [[ "$guard" = subdirectory ]]; then cd scripts; fi
    bash "$guarded_seed/scripts/create-project.sh" --in-place \
      --name "Guard Failure" --outcome "Keep the seed" \
      --source-url "$in_place_source_url" --source-sha "$guarded_sha"
  ) >/dev/null 2>&1; then
    fail "in-place creation accepted $guard"
  fi
  [[ "$(git -C "$guarded_seed" rev-parse HEAD)" = "$guarded_sha" ]] ||
    fail "$guard changed seed history"
  require_file "$guarded_seed/scripts/create-project.sh"
  case "$guard" in
    branch)
      [[ "$(git -C "$guarded_seed" branch --show-current)" = wrong-branch ]] || fail "guard changed branch"
      git -C "$guarded_seed" checkout --quiet main
      ;;
    remote)
      [[ "$(git -C "$guarded_seed" remote get-url unexpected)" = https://example.test/other.git ]] || fail "guard changed remote"
      git -C "$guarded_seed" remote remove unexpected
      ;;
    push-url)
      [[ "$(git -C "$guarded_seed" remote get-url --push origin)" = https://example.test/push.git ]] || fail "guard changed push URL"
      git -C "$guarded_seed" config --unset-all remote.origin.pushurl
      ;;
    ignored-state)
      cmp -s "$guarded_seed/.env" <(printf '%s\n' 'synthetic secret fixture') || fail "guard changed ignored state"
      rm "$guarded_seed/.env"
      ;;
    tracked-state)
      [[ "$(tail -n 1 "$guarded_seed/README.md")" = 'local owner change' ]] || fail "guard changed tracked state"
      git -C "$guarded_seed" restore README.md
      ;;
  esac
  assert_verified_seed "$guarded_seed" "$guarded_sha" "$guard"
  assert_no_transition_artifacts "$temporary_root" "$guard"
done

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

# Existing destinations, including empty directories and symlinks, are never seeded.
empty_destination="$temporary_root/empty-existing"
mkdir "$empty_destination"
linked_destination="$temporary_root/linked-existing"
ln -s "$standalone_project" "$linked_destination"
dangling_destination="$temporary_root/dangling-existing"
ln -s "$temporary_root/absent-target" "$dangling_destination"
for destination in "$empty_destination" "$linked_destination" "$dangling_destination"; do
  if bash "$repository_root/scripts/create-project.sh" "$destination" \
    --name "No Overwrite" --outcome "Preserve existing owner state" >/dev/null 2>&1; then
    fail "creation accepted an existing directory or symlink: $destination"
  fi
done
[[ -z "$(ls -A "$empty_destination")" ]] || fail "empty destination was seeded"
[[ "$(readlink "$linked_destination")" = "$standalone_project" ]] || fail "owner symlink changed"
[[ "$(readlink "$dangling_destination")" = "$temporary_root/absent-target" ]] || fail "dangling symlink changed"
cmp -s "$standalone_project/README.md" "$existing_readme" || fail "existing owner content changed"

# Out-of-place generation failure must not install partial output.
failed_destination="$temporary_root/failed-project"
if PATH="$fake_git_bin:$PATH" bash "$repository_root/scripts/create-project.sh" \
  "$failed_destination" --name "Failure" --outcome "No partial repository" >/dev/null 2>&1; then
  fail "creation survived an injected Git init failure"
fi
[[ ! -e "$failed_destination" ]] || fail "generation failure installed partial output"

# A caller-owned destination appearing during generation must survive intact.
late_destination="$temporary_root/late-destination"
fake_destination_git_bin="$temporary_root/fake-destination-git-bin"
mkdir "$fake_destination_git_bin"
cat > "$fake_destination_git_bin/git" <<EOF
#!/usr/bin/env bash
for argument in "\$@"; do
  if [[ "\$argument" = init ]]; then
    mkdir "$late_destination"
    printf '%s\n' 'caller-owned state' > "$late_destination/owner.txt"
  fi
done
exec "$real_git" "\$@"
EOF
chmod +x "$fake_destination_git_bin/git"
if PATH="$fake_destination_git_bin:$PATH" bash "$repository_root/scripts/create-project.sh" \
  "$late_destination" --name "Late Destination" --outcome "Keep owner state" >/dev/null 2>&1; then
  fail "creation accepted a destination introduced during generation"
fi
cmp -s "$late_destination/owner.txt" <(printf '%s\n' 'caller-owned state') ||
  fail "creation changed late owner state"
[[ "$(ls -A "$late_destination")" = owner.txt ]] || fail "creation seeded the late destination"

# Follow the retained recovery path and verify that it is actually restorable.
mv "$retained_recovery_directory" "$retained_seed"
assert_verified_seed "$retained_seed" "$retained_sha" "manual retained-seed restoration"
assert_no_transition_artifacts "$temporary_root" "final cleanup"

printf 'project template validation: PASS\n'
