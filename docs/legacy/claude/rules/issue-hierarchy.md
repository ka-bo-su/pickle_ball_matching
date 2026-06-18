# Issue Hierarchy

## 階層構造

```
Epic
└── Sub-issue (Feature / Foundation / Bug / Security / Test / Docs)
    └── 1 PR per Sub-issue（原則）
```

## Epic

大きな開発単位。複数の Sub-issue をまとめる。

- GitHub Issue として作成する
- タイトル: `[Epic] <タイトル>`
- ラベル: `type:epic`
- Sub-issue 一覧表を本文に含める
- 完了条件: 全 Sub-issue が `status:done`

### Epic 一覧（初期ロードマップ）

| # | タイトル |
|---|---------|
| Epic 1 | Autonomous Development Foundation |
| Epic 2 | Project Setup & CI/CD |
| Epic 3 | Database Schema & Access Control |
| Epic 4 | Auth & Organization |
| Epic 5 | Brand / Competitor / Evidence |
| Epic 6 | Diagnosis Order Workflow |
| Epic 7 | Admin Diagnosis Management |
| Epic 8 | Snapshot & Scoring |
| Epic 9 | Report Dashboard & PDF |
| Epic 10 | Tasks & Improvement Workflow |
| Epic 11 | AI Feature Layer |
| Epic 12 | Observability / Audit / Operations |
| Epic 13 | Deployment & Release Automation |

## Sub-issue Types

| Type | 説明 | テンプレート |
|------|------|------------|
| `type:feature` | 通常機能実装 | feature.md |
| `type:foundation` | 基盤・インフラ整備 | foundation.md |
| `type:bug` | バグ修正 | bug.md |
| `type:security` | セキュリティ対応 | security.md |
| `type:test` | テスト追加 | test.md |
| `type:docs` | ドキュメント | docs.md |
| `type:refactor` | リファクタリング | feature.md |

## Sub-issue 粒度

- **1 PR で完了できる粒度** にする
- 目安: 1〜3 日で実装可能
- 大きすぎる場合は分割する
- `size:xs` / `size:s` / `size:m` / `size:l` でサイズを示す

| Size | 目安工数 | PR 規模 |
|------|---------|--------|
| `size:xs` | 1〜2h | 〜50 行 |
| `size:s` | 半日 | 〜200 行 |
| `size:m` | 1〜2 日 | 〜500 行 |
| `size:l` | 3 日+ | 500 行以上（分割推奨） |

## Issue 作成時の必須フィールド

全ての Non-trivial Issue に以下を含めること:

```markdown
## Parent Epic
#<epic-issue-number>

## Goal
（1〜2 文で目的）

## Acceptance Criteria
- [ ] ...
- [ ] ...

## Dependencies
### Blocked by
- #...
### Blocks
- #...

## File Ownership
### Allowed paths
- ...
### Forbidden paths without human approval
- ...

## Risk Assessment
Risk level: risk:low / risk:medium / risk:high / risk:critical
Human decision required: Yes / No

## Labels
type:?, area:?, priority:?, risk:?, size:?
```

詳細: `docs/rules/issue-labels.md`
