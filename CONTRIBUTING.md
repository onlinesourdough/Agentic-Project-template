# Contributing

Thank you for helping make small products cheaper, safer, and easier to own.

## Before starting

1. Search existing issues and discussions.
2. Open an issue for a new profile, public interface, or architectural change.
3. Create a feature or fix branch from `dev`.
4. Keep the change focused on a real product boundary.

Do not commit a generated TanStack or Convex starter into this repository.
Create reference applications in separate repositories so they can follow the
current official scaffold.

## Development

Repository checks require Node.js 22 or newer. The zero-dependency applicator
itself remains compatible with Node.js 20 or newer.

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

Changes to profile names, bootstrap options, `.app-template.json`, or copied
file locations are public-interface changes and require a changelog entry.

By participating, you agree to follow [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md).
