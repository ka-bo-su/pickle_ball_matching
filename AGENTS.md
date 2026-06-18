# AGENTS.md

This repository optimizes for autonomous Codex development, but not for throwaway code. Codex must continuously deliver small vertical slices while preserving loose coupling, Clean Architecture boundaries, testability, and GitHub Project synchronization with `kanban@pickle_ball_matching`.

## Non-negotiable Rules

- Do not stop for human approval during autonomous runs.
- When uncertain, choose a small reversible implementation, document the assumption, and continue.
- Keep changes small, reviewable, and traceable.
- Do not direct-push to main.
- Do not deploy to production.
- Do not submit to App Store or TestFlight.
- Do not expose or modify secrets.
- Do not access production or customer data.
- Keep GitHub Project `kanban@pickle_ball_matching` synchronized, or record pending updates.
- Preserve Clean Architecture boundaries and loose coupling.
- Prefer vertical slices over large abstract foundations.
- Add or update tests whenever practical.
- Update audit logs and progress ledgers.

## Project Type

- iOS application
- Swift
- SwiftUI preferred unless existing architecture uses UIKit
- XCTest for tests
- Clean Architecture inspired layering

## Architecture

- Presentation -> Application -> Domain
- Infrastructure -> Domain
- App/CompositionRoot wires concrete implementations
- Domain must not depend on SwiftUI, UIKit, API clients, persistence implementations, or infrastructure details.

## Validation

Use `docs/codex/ios-swift-validation.md` as the source of truth for build/test/lint commands.

## GitHub Project

The operational source of truth is GitHub Project `kanban@pickle_ball_matching`.

## Logs

Always update:

- `docs/codex/audit-log.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/blockers.md` when blocked
- `docs/codex/github-projects-pending-updates.md` when Project updates cannot be applied

## Subagents

- `product-owner`: Product Goal, PBI ordering, Acceptance Criteria, and value hypotheses.
- `scrum-master`: SBI slicing, WIP, blocker isolation, Sprint Backlog, and next work selection.
- `swift-developer`: Swift / SwiftUI / XCTest implementation.
- `reviewer`: correctness, maintainability, security, and test coverage review.
- `architect-reviewer`: Clean Architecture boundary and DI review.
- `release-reviewer`: merge readiness, evidence, PR/project synchronization, and release notes.

## Continuous Work Search Order

1. GitHub Project `Scrum Status: In Progress`
2. Current Sprint Backlog unfinished SBI
3. GitHub Project `Scrum Status: Ready`
4. Ready GitHub Issues
5. Split PBI into SBI
6. iOS build/test/lint improvements
7. XCTest, SwiftUI Preview, accessibility, error handling, architecture, DI, refactor, docs, Project cleanup
8. Update `docs/codex/next-work-search.md`
