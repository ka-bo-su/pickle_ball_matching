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
| SBI-005 | Matching ViewModel状態遷移テストとアクセシビリティ補強 | In Progress | swift-developer | `scripts/codex/validate-ios.sh` passed locally | Issue #9 |

## Plan

1. Create Codex docs/config/subagents.
2. Migrate legacy Claude docs.
3. Create Project labels/fields/issues. Done.
4. Validate SwiftPM core. Done.
5. Generate and validate Xcode project. Done.
6. Commit, PR, update Project evidence. Done.
7. Squash merge to `dev`, set Project items Done. Done.
8. Environment completion merged in PR #14; Issues #10-#13 Done.
9. Issue #9 selected and implemented locally; PR is next.

## Next Ready Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-006 | 当日運営Domainモデルへ移行 | Backlog | swift-developer | `swift test`, `xcodebuild test` | pending Issue |
| SBI-007 | 参加者入力とコート数設定 | Backlog | swift-developer | ViewModel tests, `xcodebuild test` | pending Issue |
| SBI-008 | 次ラウンド生成と待機者表示 | Backlog | swift-developer | algorithm tests, `xcodebuild test` | pending Issue |
