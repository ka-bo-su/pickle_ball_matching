# Progress Ledger

## Current

- Active PBI: Issue #16
- Active SBI: next selection pending
- Active Branch: dev
- Active PR: n/a
- GitHub Project Item: n/a
- Status: Selecting next work
- Next Action: select the next highest-value MVP SBI from GitHub Project and Sprint Backlog

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
| 2026-06-01 04:10 JST | Issue #9 merged | Squash merged PR #15 to `dev`; Issue #9 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/15 |
| 2026-06-01 04:12 JST | MVP backlog created | Created Japanese PBI Issues #16-#20 and SBI Issue #21, added them to Project | Issues #16-#21 |
| 2026-06-01 04:20 JST | SBI #21 local implementation | Replaced bootstrap matching shell with day-of operation domain/use case/board UI | `GenerateNextRoundUseCase`, `OperationBoardView` |
| 2026-06-01 04:31 JST | SBI #21 merged | Squash merged PR #22 to `dev`; Issue #21 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/22 |
| 2026-06-01 04:32 JST | Next SBI created | Created Issue #23 for local JSON save/restore and added it to Project as In Progress | https://github.com/ka-bo-su/pickle_ball_matching/issues/23 |
| 2026-06-01 04:38 JST | SBI #23 local implementation | Added JSON session repository, restore/autosave ViewModel wiring, and persistence tests | `JSONSessionRepository`, `OperationBoardViewModel` |
| 2026-06-01 04:40 JST | PR opened | Created PR #24 for SBI #23 and updated Project evidence | https://github.com/ka-bo-su/pickle_ball_matching/pull/24 |
| 2026-06-01 04:57 JST | SBI #23 merged | Squash merged PR #24 to `dev`; Issue #23 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/24 |
| 2026-06-01 04:58 JST | Next SBI selected | Created and selected Issue #25 for participant status changes | https://github.com/ka-bo-su/pickle_ball_matching/issues/25 |
| 2026-06-01 05:00 JST | SBI #25 local implementation | Added participant status menu, ViewModel status update, autosave, and exclusion tests | `OperationBoardView`, `OperationBoardViewModel` |
| 2026-06-01 05:08 JST | SBI #25 merged | Squash merged PR #26 to `dev`; Issue #25 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/26 |
| 2026-06-01 08:55 JST | Next SBI selected | Created and selected Issue #27 for manual waiter swap and one-step undo | https://github.com/ka-bo-su/pickle_ball_matching/issues/27 |
| 2026-06-01 09:00 JST | SBI #27 local implementation | Added waiter swap menus, one-step undo, autosave, and ViewModel tests | `OperationBoardView`, `OperationBoardViewModel` |
| 2026-06-01 09:06 JST | PR opened | Created PR #28 for SBI #27 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/28 |
| 2026-06-01 09:10 JST | SBI #27 merged | Squash merged PR #28 to `dev`; Issue #27 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/28 |
| 2026-06-01 09:18 JST | Next SBI selected | Created and selected Issue #30 for current-round CSV sharing | https://github.com/ka-bo-su/pickle_ball_matching/issues/30 |
| 2026-06-01 09:22 JST | SBI #30 local implementation | Added CSV exporter, SwiftUI ShareLink, and CSV/ViewModel tests | `CSVRoundExporter`, `OperationBoardView` |
| 2026-06-01 09:24 JST | PR opened | Created PR #31 for SBI #30 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/31 |
| 2026-06-01 09:32 JST | SBI #30 merged | Squash merged PR #31 to `dev`; Issue #30 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/31 |

## In Progress

| Item | Branch | PR | Status | Next |
|---|---|---|---|---|
| none | n/a | n/a | n/a | next SBI selection |

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
| 2026-06-01 04:18 JST | `swift test` | pass | SBI #21 core round generation tests, 5 tests |
| 2026-06-01 04:18 JST | `scripts/codex/validate-ios.sh` | fail | SBI #21 first pass caught lint tuple and DI MainActor boundary |
| 2026-06-01 04:20 JST | `scripts/codex/validate-ios.sh` | pass | SBI #21 full validation with core/app tests |
| 2026-06-01 04:34 JST | `swift test` | pass | SBI #23 core JSON persistence tests, 8 tests |
| 2026-06-01 04:35 JST | `scripts/codex/validate-ios.sh` | fail | SBI #23 first pass caught SwiftFormat lint only; xcodebuild test passed |
| 2026-06-01 04:38 JST | `scripts/codex/validate-ios.sh` | pass | SBI #23 full validation with 8 core tests and 7 app tests |
| 2026-06-01 04:58 JST | `swift test` | pass | SBI #25 core tests, 8 tests |
| 2026-06-01 04:59 JST | `scripts/codex/validate-ios.sh` | pass | SBI #25 full validation; first pass had 1 SwiftLint warning but no failures |
| 2026-06-01 05:00 JST | `scripts/codex/validate-ios.sh` | pass | SBI #25 validation with 8 core tests and 9 app tests, 0 lint failures |
| 2026-06-01 05:03 JST | `scripts/codex/validate-ios.sh` | pass | SBI #25 final validation after accessibility adjustment, 0 lint violations |
| 2026-06-01 08:58 JST | `swift test` | pass | SBI #27 core tests, 8 tests |
| 2026-06-01 09:02 JST | `scripts/codex/validate-ios.sh` | pass | SBI #27 final validation with 8 core tests and 12 app tests, 0 failures |
| 2026-06-01 09:21 JST | `swift test` | pass | SBI #30 core CSV exporter tests, 10 tests |
| 2026-06-01 09:22 JST | `scripts/codex/validate-ios.sh` | pass | SBI #30 full validation with 10 core tests and 14 app tests, 0 failures |
