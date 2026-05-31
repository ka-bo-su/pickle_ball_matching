# Write Permission Policy

## 概要

実装コードを Write できるのは、**Issue を claim した Implementation Claude または Fix Claude のみ**。

## Write 許可条件（全て満たすこと）

```
Write is allowed ONLY when ALL of the following are true:
  1. Agent role is Implementation Claude or Fix Claude
  2. Agent has claimed exactly one Issue
  3. Agent is working in an assigned git worktree (not main worktree)
  4. Branch name matches the Issue: claude/issue-<number>-<slug>
  5. Files to be modified are within the allowed paths of the Issue
  6. Files are NOT in the protected files list (or human approval obtained)
  7. Change does not introduce security vulnerabilities
  8. Change does not affect other organizations' data access
```

## Write 前チェック（必須）

`check-write-permission` Skill を実行すること。

```bash
# 現在の状態を確認
git branch --show-current   # ブランチ名確認
pwd                          # worktree パス確認
git status                   # 変更ファイルの確認
```

## Protected Files（Write 禁止）

以下のファイルは人間の承認なしに Write してはいけない。

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
```

Protected files を変更する必要がある場合:
1. `status:needs-human` を Issue に付ける
2. 変更内容と理由を Issue/PR にコメント
3. 人間の承認を待つ

## Allowed Paths の設定

Issue ごとに実装担当の Claude は以下のような Allowed Paths を持つ。

```markdown
## Allowed Paths
- src/features/brands/**
- src/app/app/brands/**
- src/components/brands/**
```

Orchestrator Claude が Issue を割り当てる際に設定する。

## ロール別 Write 権限

| ロール | Write 権限 |
|--------|-----------|
| Planning Claude | `docs/` および planning ファイルのみ |
| Orchestrator Claude | ❌ |
| Implementation Claude | claim した Issue の allowed paths のみ |
| Fix Claude | 対象 PR の allowed paths のみ |
| Review Claude | ❌ |
| Release Claude | `CHANGELOG.md`, release notes のみ |

## セキュリティチェック

Write 前に以下を確認すること:

- [ ] SQL injection が発生しないか
- [ ] XSS が発生しないか
- [ ] 他 organization のデータに触れないか
- [ ] secret / credential をコードに含めていないか
- [ ] DB アクセス制御によるデータ分離が維持されるか
- [ ] 認証チェックが適切に実装されているか

## Write 違反の対処

違反が発生した場合（誤って protected file を変更した等）:

1. 変更を即座に `git checkout -- <file>` で戻す
2. 変更が commit/push されていた場合は Orchestrator Claude に報告
3. Orchestrator Claude が人間に通知する

詳細: `docs/rules/security-policy.md`
