# Progress Ledger

## Current

- Active PBI: app shell quality hardening
- Active SBI: Issue #9
- Active Branch: codex/issue-9-viewmodel-tests
- Active PR: pending
- GitHub Project Item: Issue #9
- Status: In Progress
- Next Action: commit Issue #9, open PR, merge to `dev`, then continue MVP domain replacement work

## Completed

| Time | Item | Result | Evidence |
|---|---|---|---|
| 2026-06-01 02:34 JST | Project resolution | Resolved `kanban@pickle_ball_matching` as `ka-bo-su` project 3 | `gh project list --owner ka-bo-su --format json` |
| 2026-06-01 02:40 JST | GitHub labels and fields | Required labels and Project fields created or confirmed | `gh label create/edit`, `gh project field-create`, `gh project field-list` |
| 2026-06-01 02:43 JST | Initial backlog | Created Japanese GitHub Issues #1-#7 and added them to Project | Issues #1-#7 |
| 2026-06-01 02:48 JST | SwiftPM core bootstrap | Added Domain/Application/Infrastructure core and XCTest | `Sources/PickleBallMatchingCore`, `Tests/PickleBallMatchingCoreTests` |
| 2026-06-01 02:49 JST | SwiftUI app shell | Added XcodeGen project and minimal SwiftUI matching screen | `project.yml`, `App/`, `Features/` |
| 2026-06-01 02:55 JST | Validation | SwiftPM, lint, format, XcodeGen, and xcodebuild validation passed | `scripts/codex/validate-ios.sh` |
| 2026-06-01 02:59 JST | PR opened | Created PR #8 to `dev` | https://github.com/ka-bo-su/pickle_ball_matching/pull/8 |
| 2026-06-01 03:00 JST | Project evidence update | Set Project items #1-#7 to In Review and Evidence Link to PR #8 | `gh project item-edit` |
| 2026-06-01 03:04 JST | PR merged | Squash merged PR #8 to `dev` | merge commit `7d4264c31ef72506dec733b95867a602c7e04754` |
| 2026-06-01 03:07 JST | Issues and Project closed | Issues #1-#7 closed, labels set `status:done`, Project items set Done | `gh issue`, `gh project item-edit` |
| 2026-06-01 03:09 JST | Next SBI created | Created Issue #9 and added it to Project as Ready | https://github.com/ka-bo-su/pickle_ball_matching/issues/9 |
| 2026-06-01 03:36 JST | Environment chores created | Created Issues #10-#13 and added them to Project | Issues #10-#13 |
| 2026-06-01 03:54 JST | Environment PR merged | Squash merged PR #14 to `dev`; Issues #10-#13 closed and Project items set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/14 |
| 2026-06-01 04:03 JST | Issue #9 local implementation | Added ViewModel state transition tests and Japanese accessibility polish | `Tests/PickleBallMatchingTests/MatchingViewModelTests.swift` |

## In Progress

| Item | Branch | PR | Status | Next |
|---|---|---|---|---|
| Issue #9 | codex/issue-9-viewmodel-tests | pending | In Progress | PR and Project evidence update |

## Blocked

| Item | Reason | Next | Project Status |
|---|---|---|---|
| none | n/a | n/a | n/a |

## Validation History

| Time | Command | Result | Notes |
|---|---|---|---|
| 2026-06-01 02:34 JST | environment probes | partial pass | Xcode/Swift/Project access available |
| 2026-06-01 02:55 JST | `scripts/codex/preflight.sh` | pass | Tuist missing only; optional |
| 2026-06-01 02:55 JST | `swift test` | pass | 2 tests, 0 failures |
| 2026-06-01 02:55 JST | `swiftlint --no-cache` | pass | 0 violations |
| 2026-06-01 02:55 JST | `swiftformat --swiftversion 6.0 --cache ignore --lint .` | pass | 0 files need formatting |
| 2026-06-01 02:55 JST | `xcodegen generate` | pass | generated local Xcode project |
| 2026-06-01 02:55 JST | `xcodebuild -list` | pass | schemes detected |
| 2026-06-01 02:55 JST | `xcodebuild build` | pass | iPhone 16 simulator destination |
| 2026-06-01 02:56 JST | `scripts/codex/nightly-summary.sh` | pass | updated `docs/codex/nightly-summary.md` |
| 2026-06-01 02:57 JST | `git diff --cached --check` | pass | legacy conflict-marker example sanitized |
| 2026-06-01 03:12 JST | `scripts/codex/validate-ios.sh` | pass | final validation on `dev` after PR #8 merge |
| 2026-06-01 03:35 JST | `scripts/codex/validate-ios.sh` | pass | environment completion branch; includes `xcodebuild test` |
| 2026-06-01 03:39 JST | `scripts/codex/bootstrap-ios.sh` | pass | generated Xcode project, ran preflight, and completed full validation |
| 2026-06-01 03:41 JST | `scripts/codex/validate-ios.sh` | pass | environment completion branch after CI Simulator fallback hardening |
| 2026-06-01 03:43 JST | GitHub Actions `validate` | fail | PR #14 fresh checkout missed empty `Shared/` source directory |
| 2026-06-01 03:48 JST | `scripts/codex/validate-ios.sh` | pass | after adding `Shared/.gitkeep` for CI XcodeGen generation |
| 2026-06-01 03:57 JST | `scripts/codex/validate-ios.sh` | fail | Issue #9 first pass caught Swift 6 Sendable boundary and unstable async test |
| 2026-06-01 04:03 JST | `scripts/codex/validate-ios.sh` | pass | Issue #9 after Sendable loader protocol and deterministic async tests |
