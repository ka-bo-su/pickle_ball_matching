# Issue Lifecycle

## 状態遷移図

```
[作成] → backlog → ready → in-progress → needs-review → ready-to-merge → done
                     ↓                        ↓
                  blocked              changes-requested
                     ↓                        ↓
                  ready (依存解消)       in-progress (Fix)
                                              ↓
                                       needs-human (必要な場合)
                                              ↓
                                         (人間判断待ち)
```

## 各状態の定義と遷移条件

### `status:backlog`

- **意味**: 作成済みだが未着手・未整備
- **遷移先**: `status:ready`（依存解消・優先度決定後）
- **担当**: Planning Claude / Orchestrator Claude

### `status:blocked`

- **意味**: 依存 Issue が未完了のため開始不可
- **遷移先**: `status:ready`（依存 Issue が `status:done` になったとき）
- **担当**: Orchestrator Claude が自動監視

### `status:ready`

- **意味**: 実装開始可能。依存解消済み
- **条件**:
  - 全 `Blocked by` Issue が `status:done`
  - `status:needs-human` がない
  - Acceptance Criteria が明確
  - File Ownership が設定済み
  - Risk Assessment が設定済み
- **遷移先**: `status:in-progress`
- **担当**: Orchestrator Claude が設定

### `status:in-progress`

- **意味**: Implementation Claude が claim して実装中
- **遷移条件**: Implementation Claude が `claim-issue` Skill を実行
- **遷移先**: `status:needs-review`（PR open 後）
- **注意**: 同一 Issue を複数の Claude が同時に claim しない

### `status:needs-review`

- **意味**: PR が open されレビュー待ち
- **遷移先**:
  - `status:changes-requested`（Review Claude が変更要求）
  - `status:ready-to-merge`（Review Claude が承認 + CI 通過）
  - `status:needs-human`（risk:high / risk:critical の場合）

### `status:changes-requested`

- **意味**: Review Claude がレビューコメントで変更要求
- **遷移先**: `status:needs-review`（Fix Claude が修正後）
- **担当**: Fix Claude が対応

### `status:needs-human`

- **意味**: 人間の判断・承認が必要
- **遷移先**: `status:ready-to-merge` または `status:changes-requested`（人間が判断後）
- **トリガー条件**:
  - `risk:high` または `risk:critical`
  - Breaking DB migration
  - DB アクセス制御 / 認証 / 課金の変更
  - その他 `docs/rules/human-decision-policy.md` 参照

### `status:ready-to-merge`

- **意味**: 全マージ条件を満たしている
- **条件**: `merge-readiness-check` Skill 参照
- **遷移先**: `status:done`（マージ後）

### `status:done`

- **意味**: マージ済み・完了
- **副作用**:
  - このIssueを `Blocked by` に持つ Issue の `status:blocked` を解除
  - Orchestrator Claude が次の Issue を選択

## Issue Claim ルール

1. `claim-issue` Skill を実行する
2. Issue にコメントを残す: `Claimed by Implementation Claude [session-id]`
3. `status:in-progress` ラベルを付ける
4. 誰かがすでに claim している場合は claim しない

## Issue Unclaim ルール

作業を中断する場合:

1. Issue にコメントを残す: `Unclaimed by Implementation Claude [session-id] - Reason: ...`
2. `status:in-progress` を `status:ready` に戻す
3. worktree の状態をコメントに記録する

## Done 定義（Definition of Done）

以下を全て満たした場合のみ `status:done` にする:

- [ ] Acceptance Criteria を全て満たしている
- [ ] PR がマージされている
- [ ] CI が全て通過している
- [ ] Review Claude が承認している
- [ ] テストが追加されている（type:test 以外の全 Issue）
- [ ] ドキュメントが更新されている（必要な場合）
- [ ] Follow-up Issue が作成されている（課題が残っている場合）
