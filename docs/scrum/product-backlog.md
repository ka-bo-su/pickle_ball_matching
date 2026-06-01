# Product Backlog

Product Goal: Deliver a local-first Japanese iOS app that lets a day-of organizer create the first pickleball doubles round within 3 minutes and show participants where to play next.

GitHub Project `kanban@pickle_ball_matching` is the source of truth. This file mirrors the initial backlog for local readability.

| ID | Type | Title | Priority | Status | Notes |
|---|---|---|---|---|---|
| PBI-001 | PBI | Codex自律Scrum/iOS開発システムへの移行 | P0 | Done | PR #8 で `dev` にmerge済み |
| SBI-001 | SBI | Codex文書・設定・subagent・runbook作成 | P0 | Done | PR #8 |
| SBI-002 | SBI | GitHub Project fields・labels・templates整備 | P0 | Done | PR #8 |
| SBI-003 | SBI | SwiftPM Clean Architecture core bootstrap | P0 | Done | PR #8 |
| SBI-004 | SBI | XcodeGen最小SwiftUI app shell | P1 | Done | PR #8 |
| CHORE-001 | Chore | Legacy Claude文書の退避 | P1 | Done | PR #8 |
| CHORE-002 | Chore | ローカル検証スクリプトとnightly summary自動化 | P1 | Done | PR #8 |
| SBI-005 | SBI | Matching ViewModel状態遷移テストとアクセシビリティ補強 | P1 | Done | PR #15, Issue #9 |
| CHORE-003 | Chore | SwiftFormatとツールバージョン固定 | P0 | Done | PR #14, Issue #10 |
| CHORE-004 | Chore | xcodebuild test対応 | P0 | Done | PR #14, Issue #11 |
| CHORE-005 | Chore | GitHub Actions CI追加 | P0 | Done | PR #14, Issue #12 |
| CHORE-006 | Chore | bootstrap-ios script整備 | P0 | Done | PR #14, Issue #13 |
| PBI-002 | PBI | 当日運営特化ダブルス組み合わせMVP | P0 | Ready | Issue #16 |
| PBI-003 | PBI | ローカルファースト保存・復元 | P1 | Ready | Issue #17 |
| PBI-004 | PBI | 進行ボードと大画面表示 | P0 | Ready | Issue #18 |
| PBI-005 | PBI | 共有・エクスポート | P2 | Ready | Issue #19 |
| PBI-006 | PBI | Pro制限とStoreKit準備 | P2 | Ready | Issue #20 |
| SBI-006 | SBI | 参加者とコート数から最初のラウンドを生成する | P0 | Done | PR #22, Issue #21 |
| SBI-007 | SBI | セッションをJSONで保存・復元する | P1 | Done | PR #24, Issue #23 |
| SBI-008 | SBI | 参加者状態を変更して次ラウンドに反映する | P1 | Done | PR #26, Issue #25 |
| SBI-009 | SBI | 待機者との手動入れ替えと1手戻す | P1 | Done | PR #28, Issue #27 |
