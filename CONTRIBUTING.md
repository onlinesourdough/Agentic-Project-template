# Contributing to APT

The generator owns new repository content in
[create-project.sh](scripts/create-project.sh) and
[foundation-content.sh](scripts/foundation-content.sh). The
[README](README.md#create-a-repository) owns the public creation and transfer
procedure; [AGENTS](AGENTS.md) owns local agent constraints.

Use a short task branch from main. Keep the CLI compatible, creation guarded,
and generated files limited to the selected kind. An ordinary code change
updates its owning documentation in the same change or explains no impact.
Do not treat a date refresh as evidence.

Validation needs Bash, Git and ripgrep; ShellCheck checks the generator scripts.
CI installs its validation tools explicitly. For generation or transfer changes, run
`bash tests/validate-project-template.sh`, inspect representative generated
instructions, review the diff and fix in-scope findings. Preserve synthetic
denial, duplicate and recovery cases. Put version-bound proof in the PR or CI
run and link it from [docs/README.md](docs/README.md) when available.
The repository's Template validation workflow runs these bounded generator and
recovery checks on PRs and manual dispatch. It does not build or deploy an app.

Keep private security reports out of public issues and PRs. Use an established
private owner channel until a verified reporting route exists.
