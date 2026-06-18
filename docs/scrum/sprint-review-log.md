# Sprint Review Log

## 2026-06-01

- Increment: Codex autonomous operating docs/config, GitHub Project setup, SwiftPM Clean Architecture core, and XcodeGen SwiftUI app shell.
- Evidence: PR #8, Issues #1-#7, `docs/codex/*`, `docs/scrum/*`, `docs/architecture/*`, `Sources/`, `Tests/`, `App/`, `Features/`, `project.yml`.
- Validation: `scripts/codex/validate-ios.sh` passed, including `swift test`, SwiftLint, SwiftFormat lint, XcodeGen generation, `xcodebuild -list`, and iOS simulator build.
- Product Backlog adaptation: initial PBI/SBI backlog created.
- Merge result: PR #8 squash merged to `dev`; Issues #1-#7 closed; Project items #1-#7 Done.
- Risks: keep generated `.xcodeproj` ignored and regenerate from `project.yml`.

## 2026-06-01 MVP Slice Review

- Increment: First Japanese operation board slice with participant entry, court count, first round generation, waiters, JSON save/restore, and participant status changes.
- Evidence: PR #22, PR #24, Issues #16-#17, #21, #23, #25.
- Validation: `scripts/codex/validate-ios.sh` passed on `codex/sbi-25-participant-status`, including `swift test`, SwiftLint, SwiftFormat lint, XcodeGen generation, `xcodebuild build`, and `xcodebuild test`.
- Product Backlog adaptation: Issue #25 was created and selected after JSON persistence because day-of status changes are needed before manual swap/undo.
- Merge result: PR #22 and PR #24 squash merged to `dev`; Issues #21 and #23 closed; Issue #25 is implemented locally and pending PR.
- Risks: participant status UX needs human-visible review for one-hand operation; manual swap/undo remains the next gap for on-court correction.

## 2026-06-02 MVP Slice Review

- Increment: Operation modes now apply organizer-facing rule presets, and the rule settings screen explains/reapplies the active preset.
- Evidence: PR #67, Issue #66, `OperationMode.defaultRuleSet`, `RuleSettingsSection`, `OperationBoardModeSettingsTests`, `OperationModeRulePresetTests`.
- Validation: `scripts/codex/validate-ios.sh` passed locally, including `swift test`, SwiftLint 0 violations, SwiftFormat lint, XcodeGen generation, `xcodebuild build`, and `xcodebuild test`; GitHub Actions `validate` passed before merge.
- Product Backlog adaptation: Issue #66 was selected after score recording because editable rules existed but operation modes were not yet useful as presets for organizers.
- Merge result: PR #67 squash merged to `dev`; Issue #66 closed; Project item Done.
- Risks: preset values should be reviewed against real court operation feedback, especially whether `交流重視` should keep level balancing disabled.

## 2026-06-02 Round History Review

- Increment: The operation board now includes a read-only round history showing previous rounds, courts, teams, waiters, scores, and match results.
- Evidence: PR #69, Issue #68, `RoundHistoryDisplayModel`, `RoundHistorySection`, `OperationBoardRoundHistoryTests`.
- Validation: `scripts/codex/validate-ios.sh` passed locally, including `swift test`, SwiftLint 0 violations, SwiftFormat lint, XcodeGen generation, `xcodebuild build`, and `xcodebuild test`; GitHub Actions `validate` passed before merge.
- Product Backlog adaptation: Issue #68 was selected after score recording and mode presets because recorded scores need a visible history surface before more destructive session-history management.
- Merge result: PR #69 squash merged to `dev`; Issue #68 closed; Project item Done.
- Risks: the operation board is getting denser; future history improvements may need a dedicated session-history screen.
