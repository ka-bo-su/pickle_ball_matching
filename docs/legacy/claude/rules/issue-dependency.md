# Issue Dependency Policy

## 依存関係の定義

各 Issue は以下の3種類の依存関係を持てる。

| フィールド | 意味 |
|----------|------|
| `Blocked by` | このIssueを開始するには、先にこのIssueが完了している必要がある |
| `Blocks` | このIssueが完了しないと、このIssueを開始できない |
| `Related` | 依存はないが、関連して参照すべきIssue |

## 依存関係の記載方法

Issue 本文の `## Dependencies` セクションに記載する。

```markdown
## Dependencies

### Blocked by
- #12 (Database Schema)
- #15 (Auth Setup)

### Blocks
- #25 (Brand CRUD)
- #26 (Competitor CRUD)

### Related
- #30 (Evidence Management)
```

## 依存関係チェックルール

### Issue 選択時

`select-next-issue` Skill は以下を確認する:

1. `Blocked by` に記載された Issue が全て `status:done` であること
2. `status:blocked` ラベルが付いていないこと
3. `status:needs-human` が付いていないこと

### 実装開始前

Implementation Claude は作業開始前に以下を確認する:

1. 全ての依存 Issue が完了している
2. 自分の worktree が依存する変更を含んでいる（または main に取り込まれている）

## 典型的な依存グラフ

```
Epic 3 (DB Schema)
  └── #03-01 DB enum types
  └── #03-02 Core tables (organizations, profiles)
  └── #03-03 Brand/Competitor tables    ← blocked by #03-02
  └── #03-04 Diagnosis tables           ← blocked by #03-03
  └── #03-05 Access control policies    ← blocked by #03-04

Epic 4 (Auth)                           ← blocked by Epic 3
Epic 5 (Brand CRUD)                     ← blocked by Epic 3, Epic 4
Epic 6 (Diagnosis Workflow)             ← blocked by Epic 5
```

## 循環依存の禁止

循環依存（A → B → A）は禁止。
Planning Claude が依存グラフ作成時に検証すること。

## 依存関係の更新

実装中に依存関係が変わった場合:

1. Issue 本文の Dependencies を更新する
2. 影響を受ける Issue の `status:blocked` / `status:ready` を更新する
3. Orchestrator Claude に通知する

## ラベルでの状態管理

| ラベル | 意味 |
|--------|------|
| `status:blocked` | 依存 Issue が未完了で開始できない |
| `status:ready` | 依存が解消されて実装可能 |
| `status:in-progress` | 実装中 |
| `status:needs-review` | PR open、レビュー待ち |
| `status:done` | 完了・マージ済み |
