# Issue Label System

全ラベルの定義・意味・使用条件を定義する。

## Type ラベル（必須: 1つ）

| ラベル | 説明 | 使用条件 |
|--------|------|---------|
| `type:epic` | 大きな開発単位 | Epic Issue のみ |
| `type:feature` | 機能実装 | 通常の機能追加・改善 |
| `type:foundation` | 基盤整備 | インフラ・共通基盤・CI/CD |
| `type:bug` | バグ修正 | 既存動作の不具合修正 |
| `type:test` | テスト追加 | テストのみの変更 |
| `type:docs` | ドキュメント | ドキュメントのみの変更 |
| `type:refactor` | リファクタリング | 動作変更なしの内部改善 |
| `type:security` | セキュリティ対応 | セキュリティ修正・強化 |

## Area ラベル（必須: 1つ以上）

| ラベル | 説明 |
|--------|------|
| `area:auth` | 認証・認可 |
| `area:db` | DB schema / migration |
| `area:db-access` | DB アクセス制御 |
| `area:ui` | フロントエンド UI |
| `area:api` | API route / server action |
| `area:admin` | 管理画面 |
| `area:ai` | AI 機能 |
| `area:scoring` | スコアリングロジック |
| `area:pdf` | PDF 生成 |
| `area:ci` | CI/CD pipeline |
| `area:deploy` | デプロイ設定 |
| `area:observability` | ログ・監視・監査 |
| `area:docs` | ドキュメント |
| `area:testing` | テスト基盤 |

## Priority ラベル（必須: 1つ）

| ラベル | 説明 | 基準 |
|--------|------|------|
| `priority:p0` | 緊急 | サービス停止・セキュリティ穴・本番障害 |
| `priority:p1` | 高 | MVP 必須機能・ブロッカー |
| `priority:p2` | 中 | MVP 重要機能 |
| `priority:p3` | 低 | Nice to have |

## Risk ラベル（必須: 1つ）

| ラベル | 説明 | 自動マージ |
|--------|------|-----------|
| `risk:low` | 低リスク | 可能 |
| `risk:medium` | 中リスク | 可能 |
| `risk:high` | 高リスク | **人間承認必須** |
| `risk:critical` | 最高リスク | **人間承認必須** |

詳細: `docs/rules/risk-classification.md`

## Status ラベル（ライフサイクル管理）

| ラベル | 説明 | 設定者 |
|--------|------|--------|
| `status:backlog` | 未着手・検討中 | Planning Claude |
| `status:ready` | 実装可能（依存解消済み） | Orchestrator Claude |
| `status:blocked` | 依存未完了で開始不可 | Orchestrator Claude |
| `status:in-progress` | 実装中 | Implementation Claude |
| `status:needs-review` | PR open、レビュー待ち | Implementation Claude |
| `status:changes-requested` | レビューで変更要求 | Review Claude |
| `status:needs-human` | 人間判断が必要 | 任意の Claude |
| `status:ready-to-merge` | マージ可能条件を満たしている | Orchestrator Claude |
| `status:done` | 完了・マージ済み | Orchestrator Claude |

## Size ラベル（任意）

| ラベル | 目安 |
|--------|------|
| `size:xs` | 1〜2h、〜50行 |
| `size:s` | 半日、〜200行 |
| `size:m` | 1〜2日、〜500行 |
| `size:l` | 3日以上、500行超（分割推奨） |

## Parallel Safety ラベル（必須）

| ラベル | 説明 |
|--------|------|
| `parallel:safe` | 他 Issue と並列実行可能 |
| `parallel:caution` | 注意して並列実行可能 |
| `parallel:unsafe` | 並列実行禁止（直列のみ） |

詳細: `docs/rules/parallel-issue-policy.md`

## Agent ラベル（任意）

| ラベル | 説明 |
|--------|------|
| `agent:planning` | Planning Claude が担当 |
| `agent:orchestrator` | Orchestrator Claude が担当 |
| `agent:implementation` | Implementation Claude が担当 |
| `agent:review` | Review Claude が担当 |
| `agent:fix` | Fix Claude が担当 |
| `agent:release` | Release Claude が担当 |

## Review ラベル

| ラベル | 説明 |
|--------|------|
| `review:approved-by-claude` | Review Claude が承認済み |
| `review:changes-requested` | Review Claude が変更要求 |

## ラベルの組み合わせ例

```
# 通常の機能実装
type:feature, area:ui, area:api, priority:p2, risk:medium, size:m, parallel:safe

# DB migration
type:foundation, area:db, area:db-access, priority:p1, risk:high, size:m, parallel:unsafe

# セキュリティバグ
type:security, area:auth, priority:p0, risk:critical, size:s, parallel:unsafe

# ドキュメントのみ
type:docs, area:docs, priority:p3, risk:low, size:xs, parallel:safe
```

## GitHub での設定方法

ラベルは GitHub の `Settings → Labels` から作成する。
色の推奨:

| グループ | 色 |
|---------|---|
| type:* | #0075ca（青系） |
| area:* | #e4e669（黄系） |
| priority:p0 | #e11d48（赤） |
| priority:p1 | #f97316（橙） |
| priority:p2 | #84cc16（緑） |
| priority:p3 | #94a3b8（グレー） |
| risk:critical | #7f1d1d（暗赤） |
| risk:high | #dc2626（赤） |
| risk:medium | #f59e0b（黄） |
| risk:low | #22c55e（緑） |
| status:needs-human | #dc2626（赤） |
| status:* | #6366f1（紫系） |
