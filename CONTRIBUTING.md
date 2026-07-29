# Contributing

Thank you for helping make small technical solutions safer and easier to own.

## Before starting

1. Search existing issues and discussions.
2. Open an issue for a new shape, profile, project-skill behavior or routing,
   workflow, or public interface.
3. Create a feature or fix branch from `dev`.
4. Keep the change focused on a repeated technical need.

Do not commit a generated TanStack or Convex starter into this repository.
Create reference applications in separate repositories so they can follow the
current official scaffold.

## Development

Repository checks and the zero-dependency applicator require Node.js 20 or
newer.

```sh
npm ci
npm run check
```

For workflow validation, also run:

```sh
go run github.com/rhysd/actionlint/cmd/actionlint@v1.7.12 \
  .github/workflows/*.yml \
  delivery/github-actions/*.yml
```

## Pull requests

Open pull requests against `dev`. Include:

- the user or developer problem
- what changed and why
- checks run
- migration or compatibility notes
- screenshots only when presentation changed

Changes to shape or profile names, the canonical skill-suite interface,
applicator options, `.solution-template.json`, legacy manifest handling, or
copied file locations are public-interface changes and require a changelog
entry.

Maintainers squash focused pull requests into `dev`. Releases use a merge commit
from `dev` to `main`; do not squash or rebase the release pull request. This
keeps `dev` in production history and future release diffs focused.

By participating, you agree to follow [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).
