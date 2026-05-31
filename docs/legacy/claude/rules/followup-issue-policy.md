# Follow-up Issue Policy

## 概要

レビュー中・実装中に発見した「今の PR スコープ外の課題」は Follow-up Issue として記録する。

今の PR に含めず、別 Issue として管理することで PR のスコープを守る。

## Follow-up Issue を作成すべきケース

- 今の PR の scope 外だが対応すべき技術的負債
- レビューで発見した将来の改善点
- 実装中に気づいたパフォーマンス問題
- テストが不足しているが今の PR に追加すると大きくなりすぎる場合
- セキュリティ強化（緊急でない場合）
- ドキュメント更新が必要だが今の PR の目的外
- 今後のリファクタリング候補

## 今の PR に含めるべきケース

- 今の PR の Acceptance Criteria を満たすために必要な変更
- セキュリティ脆弱性（緊急の場合）
- データ整合性の問題
- CI を通すために必要な修正

## Follow-up Issue の作成方法

`create-followup-issue` Skill を使う。

### 必須フィールド

```markdown
## Type
type:feature / type:refactor / type:security / type:test / type:docs

## Parent Epic
#<epic番号>（関連する Epic）

## Goal
（この Follow-up Issue で何を達成するか）

## Context
（なぜこの Issue が必要か、どの PR/Issue から派生したか）
**Source PR**: #<PR番号>
**Discovered during**: レビュー / 実装 / テスト

## Dependencies
### Blocked by
- #<source-pr の Issue>（この PR がマージされてから）

## Risk Assessment
Risk level: risk:?
Human decision required: Yes / No

## Labels
type:?, area:?, priority:?, risk:?, size:?
```

## Follow-up Issue の優先度

| 種別 | 推奨優先度 |
|------|-----------|
| セキュリティ問題 | priority:p0 または priority:p1 |
| 機能的バグ | priority:p1 |
| テスト追加 | priority:p2 |
| パフォーマンス改善 | priority:p2 |
| リファクタリング | priority:p3 |
| ドキュメント | priority:p3 |

## PR での記録

PR template の `## Follow-up Issues` セクションに記録する:

```markdown
## Follow-up Issues

- #45 - アクセス制御ポリシーのテストを追加する
- #46 - 一覧のページネーションを実装する
```

## Review Claude の責務

Review Claude は以下の観点で Follow-up Issue を提案する:

- 「今の PR に入れるほどではないが対応すべき」課題を発見した場合
- PR コメントに `[FOLLOWUP]` を付けて提案する
- 同意が得られた場合に `create-followup-issue` Skill を実行する
