# Pickle Ball Matching

This repository is an iOS/Swift app workspace optimized for long-running autonomous Codex development.

Codex should deliver small vertical slices while preserving loose coupling, Clean Architecture boundaries, testability, and synchronization with GitHub Project `kanban@pickle_ball_matching`.

## Current Stack

- iOS application
- Swift and SwiftUI
- Swift Package Manager for testable core code
- XcodeGen for the generated Xcode project
- XCTest, SwiftLint, and SwiftFormat for local validation

## Operational Source of Truth

GitHub Project:

- Name: `kanban@pickle_ball_matching`
- Owner: `ka-bo-su`
- Project number: `3`
- URL: `https://github.com/users/ka-bo-su/projects/3`

Local docs mirror Project state for readability, but GitHub Project items remain the operational source of truth for PBI / SBI / Task / Bug / Chore tracking.

## Autonomous Development

Read [AGENTS.md](AGENTS.md) first. The key rule is simple: Codex does not stop for human approval during autonomous runs. It records assumptions, blockers, validation evidence, and GitHub Project updates so a human can audit the work later.

Useful entry points:

- [Codex autonomy policy](docs/codex/autonomy-policy.md)
- [Continuous runbook](docs/codex/continuous-runbook.md)
- [Nightly runbook](docs/codex/nightly-runbook.md)
- [Scrum operating model](docs/codex/scrum-operating-model.md)
- [iOS validation](docs/codex/ios-swift-validation.md)
- [Clean Architecture](docs/architecture/clean-architecture.md)

## Bootstrap

```bash
scripts/codex/preflight.sh
swift test
xcodegen generate
xcodebuild -list
scripts/codex/validate-ios.sh
```

If Xcode build or Simulator validation fails, continue with Swift source, tests, docs, GitHub Project, and issue organization work, then record the blocker in [docs/codex/blockers.md](docs/codex/blockers.md).

## Long-Running Launch

```bash
codex features enable goals
gh auth status
caffeinate -dimsu codex \
  --cd . \
  --sandbox workspace-write \
  --ask-for-approval never \
  --search
```

Do not use `danger-full-access`, `--dangerously-bypass-approvals-and-sandbox`, or `--yolo` as the normal operating mode.
