# Merge Policy

## ブランチ戦略

```
claude/issue-* ──PR──▶ dev   （Claude が自律的にマージ）
                              ↓
dev ────────────PR──────▶ main（人間がリリース承認）
```

- **Claude の PR はすべて `dev` ブランチへ向ける**
- `main` への PR は人間（Release Claude の補助あり）が作成・承認する
- `main` は常に "リリース可能な状態" を保つ

---

## dev へのマージ条件（Claude auto-merge）

以下を**全て満たす**場合のみ Claude が auto-merge する:

- [ ] base ブランチが `dev` である
- [ ] `risk:low` または `risk:medium` ラベルが付いている
- [ ] `risk:high` / `risk:critical` ラベルが付いていない
- [ ] `review:approved-by-claude` ラベルが付いている
- [ ] Linked Issue が存在する（`Closes #` または `Fixes #`）
- [ ] `status:needs-human` が付いていない
- [ ] `status:blocked` が付いていない
- [ ] Required CI checks が全て成功している
- [ ] Unresolved な `[BLOCK]` コメントがない

## main へのマージ条件（人間 approval）

`dev → main` の PR は常に人間が承認する。Claude は自動マージしない。

- Release Claude が changelog・release notes を作成できる
- 人間が内容を確認してマージする
- Squash merge 推奨

---

## Human Approval 必須条件（dev へも不可）

以下のいずれかに該当する場合、`dev` へのマージも人間承認が必要:

- `risk:high` または `risk:critical` ラベルが付いている
- `status:needs-human` が付いている
- Breaking DB migration が含まれる
- DB アクセス制御ポリシーの変更が含まれる
- 認証・認可ロジックの変更が含まれる
- 課金・決済関連の変更が含まれる
- CI failure がある
- Review Claude の承認がない

---

## Protected Files

以下を変更する PR は `risk:high` 以上 + `status:needs-human`:

```
db/migrations/**
src/domain/permission/**
src/application/permission/**
src/infrastructure/[db]/**
src/shared/env.ts
.github/workflows/**
.github/CODEOWNERS
src/infrastructure/payment/**
src/infrastructure/ai/**
docs/rules/security-policy.md
CLAUDE.md
```

---

## Merge 実行手順

### Claude auto-merge（dev 向け）

1. `merge-readiness-check` Skill を実行して全条件を確認
2. base が `dev` であることを確認
3. CI 通過・Review Claude 承認・ラベルを確認
4. `gh pr merge <number> --squash --delete-branch`
5. Issue を `status:done` に更新
6. worktree をクリーンアップ

### human approval（dev 向け risk:high / main 向け全PR）

1. `status:needs-human` ラベルを付ける
2. PR に人間への通知コメントを残す（理由を明記）
3. 人間が確認・承認するまで待機
4. 承認後、人間が手動でマージする

---

## マージ後の処理

1. feature branch を削除する
2. worktree をクリーンアップする
3. 依存していた Issue の `status:blocked` を解除する
4. 次の Issue 選択ループへ

## Merge Strategy

- **Squash merge** を使用する（デフォルト）
- コミット履歴をきれいに保つ
- マージコミットのメッセージ: `<PR title> (#<PR number>)`

---

## Branch Protection Rules（GitHub Settings）

### dev ブランチ

```
- Require a pull request before merging
- Require status checks to pass (CI)
- Allow auto-merge: ON
- Delete branch on merge: ON
- Require review: OFF（Claude が自律的にマージするため）
```

### main ブランチ

```
- Require a pull request before merging
- Require status checks to pass (CI)
- Require human review: 1件以上
- Allow force push: OFF
- Restrict direct pushes: ON
```
