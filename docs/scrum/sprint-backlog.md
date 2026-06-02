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
| SBI-012 | セッション名と運営条件を編集できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #35, Issue #34 |
| SBI-013 | 参加者レベルを編集して組み合わせに反映する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #37, Issue #36 |
| SBI-014 | 参加者の性別・年齢帯・メモを編集できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #39, Issue #38 |
| SBI-015 | 保存済み名簿から新規セッションを開始できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #41, Issue #40 |
| SBI-016 | 現在ラウンド内の任意プレイヤーを入れ替えられるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #43, Issue #42 |
| SBI-017 | 複数手Undo履歴で手動修正を戻せるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #45, Issue #44 |
| SBI-018 | 現在ラウンドをPDFで共有できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #47, Issue #46 |
| SBI-019 | 現在ラウンドを共有画像として出力できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #49, Issue #48 |
| SBI-020 | 過去セッションを一覧から再開できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #51, Issue #50 |
| SBI-021 | 進行ボードの現在と次アクションを見やすくする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #53, Issue #52 |
| CHORE-007 | GitHub ActionsのNode 20 deprecation警告を解消する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #55, Issue #54 |
| SBI-022 | 進行ボードで試合開始と残り時間を扱えるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #57, Issue #56 |
| SBI-023 | 同じペアの重複を減らして次ラウンドを生成する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #59, Issue #58 |
| SBI-024 | 同じ対戦相手の重複を減らして次ラウンドを生成する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #61, Issue #60 |
| SBI-025 | ルール設定を編集して組み合わせ生成に反映する | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #63, Issue #62 |
| SBI-026 | 現在ラウンドのスコアと勝者を記録できるようにする | Done | swift-developer | `scripts/codex/validate-ios.sh`, GitHub Actions | PR #65, Issue #64 |
| SBI-027 | 運営モードのプリセットをルール設定へ反映する | In Review | swift-developer | `scripts/codex/validate-ios.sh` | PR #67, Issue #66 |

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
17. Issue #34 merged in PR #35 and Project item set Done.
18. Issue #36 merged in PR #37 and Project item set Done.
19. Issue #38 merged in PR #39 and Project item set Done.
20. Issue #40 merged in PR #41 and Project item set Done.
21. Issue #42 merged in PR #43 and Project item set Done.
22. Issue #44 merged in PR #45 and Project item set Done.
23. Issue #46 merged in PR #47 and Project item set Done.
24. Issue #48 merged in PR #49 and Project item set Done.
25. Issue #50 merged in PR #51 and Project item set Done.
26. Issue #52 merged in PR #53 and Project item set Done.
27. Issue #54 merged in PR #55 and Project item set Done.
28. Issue #56 merged in PR #57 and Project item set Done.
29. Issue #58 merged in PR #59 and Project item set Done.
30. Issue #60 merged in PR #61 and Project item set Done.
31. Issue #62 merged in PR #63 and Project item set Done.
32. Issue #64 merged in PR #65 and Project item set Done.
33. Issue #66 implemented locally, validated, and opened as PR #67.

## Next Ready Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-027 | 運営モードのプリセットをルール設定へ反映する | In Review | swift-developer | `scripts/codex/validate-ios.sh` passed | PR #67, Issue #66 |
