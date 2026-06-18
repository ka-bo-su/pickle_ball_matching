# Sub-agent Policy

## 概要

Sub-agent（サブエージェント）は、Orchestrator Claude または Implementation Claude から起動される補助 Claude セッションです。

**Sub-agent はデフォルトで read-only です。**

## Sub-agent がやってよいこと

- コードベースの調査・読み取り
- 関連ファイルの確認
- 設計案の作成
- テスト方針の作成
- セキュリティ観点の洗い出し
- アーキテクチャ影響の確認
- Follow-up Issue の提案
- PR レビュー（Review Claude として）
- ドキュメントの読み取り・分析
- Issue の分析・依存関係の確認

## Sub-agent がやってはいけないこと（デフォルト）

- リポジトリファイルへの Write
- git commit / push
- PR の作成
- Issue のステータス変更
- 本番環境への変更
- シークレットの読み取り・出力

## Sub-agent が Write できる条件（例外）

以下の全てを満たす場合のみ Write が許可される:

1. 明示的に **Implementation Claude** または **Fix Claude** として割り当てられている
2. **exactly 1 つの Issue** を claim している
3. **専用 worktree** が割り当てられている
4. **branch 名**が Issue に対応している（`claude/issue-<N>-<slug>`）
5. File Ownership の **allowed paths** 内のファイルのみ変更する
6. Protected files でない（または human 承認済み）

## Sub-agent 起動時のコンテキスト渡し

Orchestrator Claude が Sub-agent を起動する際は以下を渡すこと:

```markdown
## Agent Role
Implementation Claude / Fix Claude / Review Claude など

## Claimed Issue
#<issue-number>: <title>

## Worktree Path
../[PROJECT_NAME]-wt/issue-<N>-<slug>

## Branch
claude/issue-<N>-<slug>

## Allowed Paths
- src/features/brands/**
- src/app/app/brands/**

## Forbidden Paths
- src/domain/permission/**
- db/migrations/**
- .github/**

## Task
<具体的なタスク>
```

## Review Sub-agent

Review Claude として起動される Sub-agent は:

- 必ず **実装者とは別のセッション** として振る舞う
- PR の diff のみを読む
- 実装コードを修正しない
- コメントのみで指摘する

## セキュリティ

Sub-agent に渡してはいけないもの:

- production の secret / credentials
- DB / BaaS のサービスロールキー（production）
- 決済サービスの secret key（production）
- その他の本番環境認証情報

Sub-agent が意図せず secret を出力した場合:

1. 即座に出力を破棄する
2. secret をローテーションする
3. インシデントとして記録する
