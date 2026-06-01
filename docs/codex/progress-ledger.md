# Progress Ledger

## Current

- Active PBI: Issue #17
- Active SBI: Issue #50
- Active Branch: codex/sbi-50-session-history
- Active PR: none
- GitHub Project Item: PVTI_lAHOBHYYMs4BZUKkzguXOGc
- Status: In Progress
- Next Action: commit, push, open PR, and move Project item to In Review

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
| 2026-06-01 10:00 JST | Next SBI selected | Created and selected Issue #32 for participant-facing large board display | https://github.com/ka-bo-su/pickle_ball_matching/issues/32 |
| 2026-06-01 10:05 JST | SBI #32 local implementation | Added large board navigation, adaptive display view, and display model tests | `OperationBoardView`, `OperationBoardViewModel` |
| 2026-06-01 10:14 JST | PR opened | Created PR #33 for SBI #32 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/33 |
| 2026-06-01 10:20 JST | SBI #32 merged | Squash merged PR #33 to `dev`; Issue #32 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/33 |
| 2026-06-01 10:24 JST | Next SBI selected | Created and selected Issue #34 for editable session settings | https://github.com/ka-bo-su/pickle_ball_matching/issues/34 |
| 2026-06-01 10:35 JST | SBI #34 local implementation | Added session settings editing, blank new-session start, split presentation views, and ViewModel tests | `SessionSettingsSection`, `OperationBoardViewModel` |
| 2026-06-01 10:38 JST | PR opened | Created PR #35 for SBI #34 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/35 |
| 2026-06-01 10:47 JST | SBI #34 merged | Squash merged PR #35 to `dev`; Issue #34 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/35 |
| 2026-06-01 10:50 JST | Next SBI selected | Created and selected Issue #36 for participant skill level editing | https://github.com/ka-bo-su/pickle_ball_matching/issues/36 |
| 2026-06-01 10:54 JST | SBI #36 local implementation | Added participant skill level menu, autosave ViewModel method, and tests | `OperationBoardView`, `OperationBoardViewModel` |
| 2026-06-01 10:56 JST | PR opened | Created PR #37 for SBI #36 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/37 |
| 2026-06-01 11:04 JST | SBI #36 merged | Squash merged PR #37 to `dev`; Issue #36 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/37 |
| 2026-06-01 11:07 JST | Next SBI selected | Created and selected Issue #38 for participant gender, age group, and memo editing | https://github.com/ka-bo-su/pickle_ball_matching/issues/38 |
| 2026-06-01 11:15 JST | SBI #38 local implementation | Added participant detail editor, participant list split, ViewModel update method, and autosave tests | `ParticipantDetailEditorView`, `ParticipantListSection`, `OperationBoardViewModel` |
| 2026-06-01 11:17 JST | PR opened | Created PR #39 for SBI #38 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/39 |
| 2026-06-01 11:26 JST | SBI #38 merged | Squash merged PR #39 to `dev`; Issue #38 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/39 |
| 2026-06-01 11:34 JST | Next SBI selected | Created and selected Issue #40 for starting a new session while reusing the saved roster | https://github.com/ka-bo-su/pickle_ball_matching/issues/40 |
| 2026-06-01 11:40 JST | SBI #40 local implementation | Added roster-carryover new-session action, reset logic, and ViewModel test | `SessionSettingsSection`, `OperationBoardViewModel` |
| 2026-06-01 11:42 JST | PR opened | Created PR #41 for SBI #40 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/41 |
| 2026-06-01 11:49 JST | SBI #40 merged | Squash merged PR #41 to `dev`; Issue #40 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/41 |
| 2026-06-01 11:55 JST | Next SBI selected | Created and selected Issue #42 for swapping any current-round participant | https://github.com/ka-bo-su/pickle_ball_matching/issues/42 |
| 2026-06-01 12:02 JST | SBI #42 local implementation | Generalized manual swap to any current-round participant and added ViewModel tests | `OperationBoardView`, `OperationBoardViewModel` |
| 2026-06-01 12:04 JST | PR opened | Created PR #43 for SBI #42 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/43 |
| 2026-06-01 14:19 JST | SBI #42 merged | Squash merged PR #43 to `dev`; Issue #42 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/43 |
| 2026-06-01 14:24 JST | Next SBI selected | Created and selected Issue #44 for multi-step undo history | https://github.com/ka-bo-su/pickle_ball_matching/issues/44 |
| 2026-06-01 14:29 JST | SBI #44 local implementation | Added bounded multi-step undo history, undo count UI, reset rules, and ViewModel tests | `OperationBoardViewModel`, `OperationBoardView` |
| 2026-06-01 14:31 JST | PR opened | Created PR #45 for SBI #44 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/45 |
| 2026-06-01 14:41 JST | SBI #44 merged | Squash merged PR #45 to `dev`; Issue #44 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/45 |
| 2026-06-01 15:33 JST | Next SBI selected | Created and selected Issue #46 for current-round PDF sharing | https://github.com/ka-bo-su/pickle_ball_matching/issues/46 |
| 2026-06-01 15:42 JST | SBI #46 local implementation | Added PDF exporter, Transferable document, PDF ShareLink, and PDF tests | `PDFRoundExporter`, `RoundPDFDocument`, `OperationBoardView` |
| 2026-06-01 15:43 JST | PR opened | Created PR #47 for SBI #46 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/47 |
| 2026-06-01 18:34 JST | SBI #46 merged | Squash merged PR #47 to `dev`; Issue #46 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/47 |
| 2026-06-01 18:43 JST | Next SBI selected | Created and selected Issue #48 for current-round image sharing | https://github.com/ka-bo-su/pickle_ball_matching/issues/48 |
| 2026-06-01 18:49 JST | SBI #48 local implementation | Added PNG exporter, Transferable image document, image ShareLink, and image tests | `ImageRoundExporter`, `RoundImageDocument`, `OperationBoardView` |
| 2026-06-01 18:51 JST | PR opened | Created PR #49 for SBI #48 and moved Project item to In Review | https://github.com/ka-bo-su/pickle_ball_matching/pull/49 |
| 2026-06-01 19:05 JST | SBI #48 merged | Squash merged PR #49 to `dev`; Issue #48 closed and Project item set Done | https://github.com/ka-bo-su/pickle_ball_matching/pull/49 |
| 2026-06-01 19:10 JST | Next SBI selected | Created and selected Issue #50 for reopening saved sessions from history | https://github.com/ka-bo-su/pickle_ball_matching/issues/50 |
| 2026-06-01 19:19 JST | SBI #50 local implementation | Added JSON session history, ViewModel reopen flow, settings menu, and repository/ViewModel tests | `JSONSessionRepository`, `SessionSettingsSection`, `OperationBoardViewModel` |

## In Progress

| Item | Branch | PR | Status | Next |
|---|---|---|---|---|
| Issue #50 | codex/sbi-50-session-history | pending | In Progress | Open PR after commit |

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
| 2026-06-01 10:03 JST | `swift test` | pass | SBI #32 core tests, 10 tests |
| 2026-06-01 10:05 JST | `scripts/codex/validate-ios.sh` | pass | SBI #32 full validation with 10 core tests and 17 app tests, 0 failures |
| 2026-06-01 10:18 JST | GitHub Actions `validate` | pass | PR #33 passed before squash merge |
| 2026-06-01 10:35 JST | `scripts/codex/validate-ios.sh` | pass | SBI #34 full validation with 10 core tests and 21 app tests, 0 lint violations |
| 2026-06-01 10:46 JST | GitHub Actions `validate` | pass | PR #35 passed before squash merge |
| 2026-06-01 10:54 JST | `scripts/codex/validate-ios.sh` | pass | SBI #36 full validation with 10 core tests and 22 app tests, 0 lint violations |
| 2026-06-01 11:03 JST | GitHub Actions `validate` | pass | PR #37 passed before squash merge |
| 2026-06-01 11:15 JST | `scripts/codex/validate-ios.sh` | pass | SBI #38 full validation with 10 core tests and 24 app tests, 0 lint violations |
| 2026-06-01 11:25 JST | GitHub Actions `validate` | pass | PR #39 passed before squash merge |
| 2026-06-01 11:40 JST | `scripts/codex/validate-ios.sh` | pass | SBI #40 full validation with 10 core tests and 25 app tests, 0 lint violations |
| 2026-06-01 11:49 JST | GitHub Actions `validate` | pass | PR #41 passed before squash merge |
| 2026-06-01 12:02 JST | `scripts/codex/validate-ios.sh` | pass | SBI #42 full validation with 10 core tests and 27 app tests, 0 lint violations |
| 2026-06-01 14:16 JST | GitHub Actions `validate` | pass | PR #43 passed before squash merge |
| 2026-06-01 14:27 JST | `swift test` | pass | SBI #44 core tests, 10 tests |
| 2026-06-01 14:29 JST | `scripts/codex/validate-ios.sh` | pass | SBI #44 full validation with 10 core tests and 29 app tests, 0 lint violations |
| 2026-06-01 14:38 JST | GitHub Actions `validate` | pass | PR #45 passed before squash merge |
| 2026-06-01 15:37 JST | `swift test` | pass | SBI #46 core tests, 12 tests |
| 2026-06-01 15:42 JST | `scripts/codex/validate-ios.sh` | pass | SBI #46 full validation with 12 core tests and 31 app tests, 0 lint violations |
| 2026-06-01 18:32 JST | GitHub Actions `validate` | pass | PR #47 passed before squash merge |
| 2026-06-01 18:46 JST | `swift test` | pass | SBI #48 core tests, 14 tests |
| 2026-06-01 18:49 JST | `scripts/codex/validate-ios.sh` | pass | SBI #48 full validation with 14 core tests and 33 app tests, 0 lint violations |
| 2026-06-01 19:02 JST | GitHub Actions `validate` | pass | PR #49 passed before squash merge |
| 2026-06-01 19:14 JST | `swift test` | pass | SBI #50 core tests, 15 tests |
| 2026-06-01 19:19 JST | `scripts/codex/validate-ios.sh` | pass | SBI #50 full validation with 15 core tests and 35 app tests, 0 lint violations |
