# Changelog

All notable changes are documented here. This project follows
[Semantic Versioning](https://semver.org/).

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
