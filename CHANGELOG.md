# Changelog

All notable changes are documented here. This project follows
[Semantic Versioning](https://semver.org/).

## [0.2.1] - 2026-07-28

### Added

- A shared Solution Lifecycle guide that places the template at the technical
  edge of Plan, through Build, and into the technical side of Adoption.
- Entry and exit gates covering baseline, shared intent, acceptance, adoption,
  operations, recovery, documentation, and handover.
- An optional lightweight `DESIGN.md` pattern without introducing a required
  brief, schema, or AIOS handoff.

### Changed

- The applicator now copies `docs/solution-template/LIFECYCLE.md` for every
  solution shape.
- Agent and delivery guidance now treats deployment as a checkpoint rather than
  completion.
- Clarified that AIOS may route to a separate project repository while project
  truth and unattended execution remain in that repository.
- Defined merge commits for `dev` to `main` releases so long-lived branch
  ancestry and future release diffs remain correct.

## [0.2.0] - 2026-07-27

### Added

- Application, Service, Automation, Integration, and System solution shapes.
- Shared AI-native architecture for ownership, contracts, trust, validation,
  operations, recovery, and handover.
- Shape-aware bootstrap support for repositories without `package.json`.
- Framework-neutral specialist guidance for agent-capable and existing
  solutions.
- A retrospective CryptoClub multi-shape case study.

### Changed

- Renamed the public product from AI-first App Template to AI-native Solution
  Template.
- Renamed the package to `@arcitai/solution-template`.
- Limited static Pages, Cloudflare-native, Convex, and external profiles to the
  Application shape.
- Reduced copied guidance to shared architecture, one shape, delivery, and an
  optional Application profile.
- Renamed the generated manifest to `.solution-template.json`.
- Kept AIOS and Solution Template independent while documenting their
  principle-level relationship.

### Removed

- Automatic delivery of agent-capability and existing-application specialist
  guides to every target.
- The assumption that every target is a Node application with `package.json`.
- Any public reference to or dependency on third-party agent frameworks.

### Migration

- Add `--shape application` to existing profile-based commands. Profile-only
  commands continue to work during the `v0.x` preview with a warning.
- Read new state from `.solution-template.json`. Existing
  `.app-template.json` files are preserved and never removed automatically.
- Update copied documentation paths from `docs/app-template/` to
  `docs/solution-template/`.

## [0.1.0] - 2026-07-23

### Added

- Public AI-first App Template positioning and quickstart.
- Static Pages, Cloudflare-native, Convex, and external backend profiles.
- Safe profile application tool with dry-run and conflict detection.
- GitHub Pages, Cloudflare, Convex, and CI workflow templates.
- Public repository governance, security, roadmap, and contribution files.
- Online Sourdough Resources case study and digital-product guidance.

### Stability

This was the first public preview. Profile identifiers and the apply manifest
were introduced as pre-`1.0.0` interfaces.
