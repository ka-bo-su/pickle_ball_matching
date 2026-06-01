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
| SBI-006 | 参加者とコート数から最初のラウンドを生成する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #22, Issue #21 |
| SBI-007 | ローカルJSON保存・復元 | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #24, Issue #23 |
| SBI-008 | 参加者状態を変更して次ラウンドに反映する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #26, Issue #25 |
| SBI-009 | 待機者との手動入れ替えと1手戻す | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #28, Issue #27 |
| SBI-010 | 現在ラウンドをCSVで共有できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #31, Issue #30 |
| SBI-011 | 参加者向け大画面ボードを表示する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #33, Issue #32 |

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
11. Issue #21 merged in PR #22 and Project item set Done.
12. Issue #23 merged in PR #24 and Project item set Done.
13. Issue #25 merged in PR #26 and Project item set Done.
14. Issue #27 merged in PR #28 and Project item set Done.
15. Issue #30 merged in PR #31 and Project item set Done.
16. Issue #32 merged in PR #33 and Project item set Done.

## Next Ready Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-012 | Snapshot/Undo履歴強化 | Backlog | swift-developer | ViewModel tests, `xcodebuild test` | pending Issue |
