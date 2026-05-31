# Worktree Policy

## 基本原則

**1 Issue = 1 branch = 1 worktree = 1 Implementation Claude**

## ブランチ命名規則

```
claude/issue-<issue-number>-<short-slug>
```

例:

```
claude/issue-018-scoring-logic
claude/issue-024-brand-form
claude/issue-031-rls-policy
```

slug は Issue タイトルから派生した kebab-case（3〜5語）を使う。

## Worktree パス規則

```
../scrumy-ai-search-wt/issue-<issue-number>-<short-slug>
```

例:

```
../scrumy-ai-search-wt/issue-018-scoring-logic
../scrumy-ai-search-wt/issue-024-brand-form
```

## Worktree 作成手順

```bash
# 1. main worktree を最新にする
git fetch origin
git pull origin main

# 2. worktree を作成してブランチを切る
git worktree add ../scrumy-ai-search-wt/issue-<N>-<slug> -b claude/issue-<N>-<slug>

# 3. worktree に移動して確認
cd ../scrumy-ai-search-wt/issue-<N>-<slug>
git status
git branch --show-current
pwd
```

## 作業開始前の確認（必須）

```bash
git status        # 変更がない状態であること
git branch --show-current  # 正しいブランチであること
pwd               # 正しい worktree パスであること
```

## Worktree 解放手順

PR マージ後:

```bash
# main worktree で実行
git worktree remove ../scrumy-ai-search-wt/issue-<N>-<slug>
git branch -d claude/issue-<N>-<slug>
git push origin --delete claude/issue-<N>-<slug>  # remote branch も削除
```

## 並列 Worktree の管理

複数の Issue を並列で進める場合、それぞれ独立した worktree を使う。

```
../scrumy-ai-search-wt/issue-018-scoring-logic/   # Implementation Claude A
../scrumy-ai-search-wt/issue-024-brand-form/      # Implementation Claude B
../scrumy-ai-search-wt/issue-031-rls-policy/      # Implementation Claude C（human 承認必要）
```

詳細: `docs/rules/parallel-issue-policy.md`

## Worktree 一覧確認

```bash
git worktree list
```

## 禁止事項

| 禁止行為 | 理由 |
|---------|------|
| main worktree で直接実装 | main を汚染する |
| 複数 Issue を同じ worktree で作業 | スコープ混在・コンフリクトリスク |
| 他 Claude の worktree に Write | 所有権侵害 |
| Review Claude が worktree に Write | Review は読み取り専用 |
| Orchestrator Claude が worktree に Write | Orchestrator は読み取り専用 |
| `.` や `..` で worktree を作成 | パス規則違反 |

## Worktree が壊れた場合

```bash
# worktree の状態確認
git worktree list

# 壊れた worktree を強制削除
git worktree remove --force ../scrumy-ai-search-wt/issue-<N>-<slug>

# または lock されている場合
git worktree unlock ../scrumy-ai-search-wt/issue-<N>-<slug>
git worktree remove ../scrumy-ai-search-wt/issue-<N>-<slug>
```

## PR を open する際の確認

```bash
# 正しい worktree のブランチから push されていること
git log --oneline main..HEAD  # main との差分 commit を確認
git diff --stat main          # 変更ファイルを確認
```
