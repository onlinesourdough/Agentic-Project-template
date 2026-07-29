# Changelog

All notable changes are documented here. This project follows
[Semantic Versioning](https://semver.org/).

## [0.5.0] - 2026-07-29

### Added

- A focused suite for clarification, architecture, implementation, TDD,
  security, documentation, delivery, operations, and evidence-based review,
  with `develop-solution` as the broad router.
- One-question-at-a-time shape clarification covering landing pages, content
  libraries, full-stack Applications, Services, n8n Automations, Integrations,
  and Systems.
- Proportional guidance for REST/OpenAPI contracts, structured logging,
  observability, resilience, documentation, recovery, and technical handover.
- An original visual showing optional upstream context, five solution shapes,
  verification, and recovery.

### Changed

- The applicator now installs the complete project skill suite and thin Claude
  adapters for every shape.
- Clarified the boundary between AIOS agent routines, workflow orchestration,
  and separately owned technical Services and Automations.
- Made TypeScript the web-oriented default while keeping Python first-class for
  data, image, scientific, ML, and existing Python workloads.
- Pinned every external GitHub Action to a reviewed immutable commit SHA.
- Shortened the README around the actual AIOS-to-solution and standalone
  journeys.

### Compatibility

- Shapes, Application profiles, CLI options, marker detection, and manifest
  format remain compatible.
- Existing `v0.4.x` targets need `--force` to replace template-owned files and
  receive the expanded suite. Review local changes before applying.

## [0.4.0] - 2026-07-29

### Added

- A canonical, harness-neutral `develop-solution` project skill for technical
  setup, implementation, readiness checks, deployment, and recovery.
- A progressive technical-readiness reference covering inputs, accountable
  roles, architecture, stack, security, quality, deployment, observability,
  operations, handover, and exit.
- Thin Codex UI and Claude adapters without duplicated workflow logic.
- Explicit deployment and activation guidance for every shape and Application
  profile.

### Changed

- Repositioned the template as a fully standalone technical project foundation.
  AIOS is an optional upstream context and transition path, not the owner of
  project skills or technical workflow.
- Expanded shape and profile guidance only where responsibility, architecture,
  or deployment evidence would otherwise be ambiguous.
- The applicator now installs the project-local skill and adapters for every
  shape.

### Compatibility

- Shape names, Application profiles, CLI options, project markers, workflow
  selection, and `.solution-template.json` remain compatible.
- Applying with `--force` is required when updating previously customized
  template-owned files; review conflicts before replacing them.

## [0.3.0] - 2026-07-28

### Changed

- Reduced the applied bundle to `AGENTS.md`, one shape guide, an optional
  Application profile, relevant workflows, and the provenance manifest.
- Made AIOS the documented home base for business context, priorities, task
  routing, and learning while keeping project-specific technical truth in the
  target repository.
- Shortened all shape and profile guides to the decisions and evidence their
  selected repository actually owns.
- Simplified the README around one natural-language AIOS journey and the
  standalone applicator interface.

### Removed

- `LIFECYCLE.md`, shared `ARCHITECTURE.md`, and `delivery/README.md`.
- The 842-line Application architecture guide.
- Specialist agent-capability, existing-application, digital-product, and case
  study documentation from the technical core.
- Discovery, adoption, business-feedback, and branch-model instructions from
  files copied into customer projects.

### Migration

- Applying `v0.3.0` does not delete files previously copied by `v0.2.x`.
  Existing projects may remove obsolete files under `docs/solution-template/`
  after checking that they contain no local decisions.
- Shape names, Application profile names, command options, workflows, and
  `.solution-template.json` remain compatible.

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
