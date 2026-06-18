# Deployment Policy

## 基本方針

- main ブランチへのマージが自動デプロイをトリガーする
- 本番デプロイは **人間の最終確認** を推奨する
- デプロイ前に全 CI が通過していること

## デプロイ環境

| 環境 | ブランチ | 用途 | 自動デプロイ |
|------|---------|------|------------|
| Production | main | 本番 | [HOSTING_PLATFORM] の設定による |
| Preview | PR branch | レビュー用 | [HOSTING_PLATFORM] のプレビュー機能（設定後） |

## デプロイ前チェックリスト

### 必須

- [ ] 全 CI checks が通過
- [ ] Review Claude が承認
- [ ] `status:needs-human` がない
- [ ] DB migration が安全であること（breaking でない）
- [ ] 環境変数の変更がある場合は事前に設定済み

### risk:high / risk:critical の場合

- [ ] 人間が内容を確認・承認
- [ ] ロールバック手順を確認
- [ ] デプロイ後の確認手順を用意

## DB Migration のデプロイ方針

1. migration はプロジェクトの DB ツール（CLI / ダッシュボード）で実行
2. breaking migration（カラム削除等）は必ず人間が実行
3. migration 前にバックアップを確認
4. migration 後にデータ整合性を確認

## ロールバック手順

デプロイ後に問題が発生した場合:

1. [HOSTING_PLATFORM] のダッシュボードから前バージョンに revert
2. DB migration の場合は down migration を手動実行（事前に準備）
3. 問題を Issue として記録

## ホスティング・CI/CD 設定

プロジェクトで使用するホスティングプラットフォームに合わせて設定する:

```
- Build command: [BUILD_COMMAND]
- Install command: [INSTALL_COMMAND]
- Environment variables: [必要な環境変数一覧]
```

## リリースノート

Release Claude がマージ後に以下を作成する:

- CHANGELOG.md の更新
- GitHub Release の作成
- リリースノートの生成

詳細: `.claude/skills/deployment-check/SKILL.md`
