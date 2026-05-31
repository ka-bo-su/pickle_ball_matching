# Database Policy

## 基本方針

- Migration はバージョン管理ツール（Flyway / Liquibase / Supabase CLI / Prisma Migrate 等）で管理する
- Breaking Migration は必ず人間が実行する
- テナント分離が必要なテーブルには必ずアクセス制御を設ける

## Migration ルール

### Migration ファイルの管理

```
db/migrations/
├── 20260523000001_create_organizations.sql
├── 20260523000002_create_profiles.sql
└── ...
```

命名規則: `<timestamp>_<description>.sql`（ツールの規約に従う）

### Migration を含む Issue は risk:high

DB schema の変更は `risk:high` ラベルを付け、人間承認を必須とする。

### Breaking Migration は risk:critical

以下は `risk:critical` で人間実行必須:

- カラムの削除
- カラムの型変更（データ変換を伴う）
- テーブルの削除
- 外部キー制約の削除

### Non-Breaking Migration の例

- 新規テーブル作成
- nullable カラムの追加
- インデックスの追加
- CHECK 制約の追加（新規データのみ）

## テーブル設計の原則

### 共通カラム（全テーブル推奨）

```sql
id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
created_at  TIMESTAMPTZ DEFAULT now() NOT NULL,
updated_at  TIMESTAMPTZ DEFAULT now() NOT NULL
```

### テナント分離（マルチテナントデータには必須）

テナント（organization 等）に属するデータは必ず `tenant_id` / `organization_id` カラムを持つ:

```sql
organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
```

### Soft Delete

重要なデータは物理削除せず soft delete を使う:

```sql
deleted_at TIMESTAMPTZ DEFAULT NULL,
```

### updated_at の自動更新（PostgreSQL の例）

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_<table>_updated_at
  BEFORE UPDATE ON <table>
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## アクセス制御の必須化

テナント分離が必要な全テーブルにアクセス制御を適用すること。

詳細: `docs/rules/security-policy.md`

## インデックス設計

```sql
-- organization_id / tenant_id は必ずインデックスを張る
CREATE INDEX idx_resources_org_id ON resources(organization_id);

-- よく使うフィルタ条件
CREATE INDEX idx_resources_status ON resources(status) WHERE deleted_at IS NULL;

-- 複合インデックス（組み合わせで検索する場合）
CREATE INDEX idx_orders_org_status
  ON orders(organization_id, status);
```

## 型の使用指針（PostgreSQL）

| データ種別 | PostgreSQL 型 |
|-----------|--------------|
| ID | UUID |
| 文字列 | TEXT |
| 数値（整数） | INTEGER / BIGINT |
| 数値（小数） | NUMERIC(10,2) |
| 真偽値 | BOOLEAN |
| 日時 | TIMESTAMPTZ |
| JSON | JSONB |
| 配列 | TEXT[] / UUID[] |
| 列挙型 | TEXT + CHECK 制約 |

## 型生成

ORM / スキーマツールで型を自動生成することを推奨:

```bash
# 例: Supabase CLI の場合
pnpm supabase gen types typescript --local > src/types/database.types.ts

# 例: Prisma の場合
npx prisma generate
```

型ファイルは自動生成のため手動編集禁止。

## バックアップ・リストア

- 本番 DB のバックアップ設定を確認する（DB サービスの自動バックアップ or 手動）
- Breaking Migration 前には手動バックアップを確認する
- リストア手順は `docs/rules/deployment-policy.md` を参照

## Local 開発環境

プロジェクトで使用する DB ツールに従いローカル環境を構築する。

```bash
# 例: Docker で PostgreSQL を起動
docker compose up -d db

# Migration を適用
[DB_MIGRATE_COMMAND]

# 停止
docker compose down
```

## DB 接続の管理

- Server-side のみ: DB 接続情報（接続文字列・サービスロールキー等）はサーバーサイドに限定する
- Client-side への DB 接続情報の露出は禁止
- Admin 操作は最小限の権限を持つ専用ロールを使う
