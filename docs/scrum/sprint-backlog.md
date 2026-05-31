# Sprint Backlog

## Sprint Goal

Create the first inspectable autonomous Codex iOS development increment: Codex operating docs/config plus a testable SwiftPM core and XcodeGen app shell.

## Selected Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-001 | Codex文書・設定・subagent・runbook作成 | Done | scrum-master | docs review, preflight | PR #8 |
| SBI-002 | GitHub Project fields・labels・templates整備 | Done | scrum-master | gh field/label commands | PR #8, Issues #1-#7 |
| SBI-003 | SwiftPM Clean Architecture core bootstrap | Done | swift-developer | `swift test` passed | PR #8 |
| SBI-004 | XcodeGen最小SwiftUI app shell | Done | swift-developer | `xcodegen generate`, `xcodebuild build` passed | PR #8 |
| CHORE-003 | SwiftFormatとツールバージョン固定 | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #14, Issue #10 |
| CHORE-004 | xcodebuild test対応 | Done | swift-developer | `xcodebuild test` | PR #14, Issue #11 |
| CHORE-005 | GitHub Actions CI追加 | Done | swift-developer | GitHub Actions `validate` passed | PR #14, Issue #12 |
| CHORE-006 | bootstrap-ios script整備 | Done | swift-developer | `scripts/codex/bootstrap-ios.sh` | PR #14, Issue #13 |
| SBI-005 | Matching ViewModel状態遷移テストとアクセシビリティ補強 | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #15, Issue #9 |
| SBI-006 | 参加者とコート数から最初のラウンドを生成する | In Progress | swift-developer | `scripts/codex/validate-ios.sh` passed locally | Issue #21 |

## Plan

1. Create Codex docs/config/subagents.
2. Migrate legacy Claude docs.
3. Create Project labels/fields/issues. Done.
4. Validate SwiftPM core. Done.
5. Generate and validate Xcode project. Done.
6. Commit, PR, update Project evidence. Done.
7. Squash merge to `dev`, set Project items Done. Done.
8. Environment completion merged in PR #14; Issues #10-#13 Done.
9. Issue #9 merged in PR #15 and Project item set Done.
10. MVP PBI Issues #16-#20 created in Japanese and added to Project.
11. Issue #21 selected and implemented locally; PR is next.

## Next Ready Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-007 | ローカルJSON保存・復元 | Backlog | swift-developer | persistence tests, `xcodebuild test` | pending Issue |
| SBI-008 | 手動入れ替えとUndoの土台 | Backlog | swift-developer | ViewModel tests, `xcodebuild test` | pending Issue |
| SBI-009 | 共有CSV出力 | Backlog | swift-developer | exporter tests, `xcodebuild test` | pending Issue |
