# Security Policy

## 基本原則

1. **テナントデータ分離**: 他テナント（organization 等）のデータには絶対にアクセスしない
2. **最小権限**: 必要なデータのみ取得・変更する
3. **認証必須**: 全ての非パブリック API に認証チェックを入れる
4. **入力バリデーション**: 全外部入力をバリデーションする（Zod 等のスキーマライブラリ推奨）
5. **Secret 管理**: secret/credential をコードやログに含めない

## 認証・認可

### 認証チェック（全 API エンドポイント / サーバー処理に必須）

```typescript
// 例: 認証ミドルウェアのパターン
export async function requireAuth(request: Request) {
  const token = extractToken(request);
  const user = await verifyToken(token);

  if (!user) {
    throw new UnauthorizedError('Authentication required');
  }

  const tenantId = await getTenantId(user.id);
  return { user, tenantId };
}
```

### 認可チェック（権限が必要な操作）

```typescript
// 例: 権限チェックのパターン
import { requirePermission } from '@/application/permission/check';

await requirePermission(user, 'resource:action', tenantId);
```

### DB アクセス制御の必須化

テナント分離が必要な全テーブルに行レベルのアクセス制御を適用すること。

```sql
-- 例: PostgreSQL RLS を使う場合
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation" ON resources
  USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```

詳細はプロジェクトの DB 設定に従う。

## SQL インジェクション対策

**ORM / クエリビルダー経由のみ許可。生 SQL の動的組み立ては禁止。**

```typescript
// ✅ 安全: ORM/クエリビルダー経由
const records = await db
  .selectFrom('resources')
  .where('id', '=', resourceId)
  .execute();

// ❌ 危険: 生 SQL にユーザー入力を直接埋め込む（禁止）
const records = await db.raw(`SELECT * FROM resources WHERE id = '${resourceId}'`);
```

## XSS 対策

- テンプレートエンジン・UI フレームワークの自動エスケープを活用する
- ユーザー入力を HTML に直接レンダリングしない（`dangerouslySetInnerHTML` 等は禁止）
- sanitize 済みコンテンツのみ例外を許容する

## CSRF 対策

- サーバーサイドの処理には CSRF トークン検証またはフレームワークの保護機能を使用する
- 外部から呼び出される Webhook は署名検証を必須とする

## 環境変数・Secret

```typescript
// ✅ 安全: 環境変数管理モジュール経由でアクセス
import { env } from '@/shared/env';
const key = env.EXTERNAL_API_KEY;

// ❌ 禁止: process.env 直接アクセス（検証なし）
const key = process.env.EXTERNAL_API_KEY;

// ❌ 絶対禁止: コードに直接記述
const key = 'secret-key-...';
```

### Client-side に公開してはいけない環境変数

以下はサーバーサイドのみで使用し、クライアントに渡さない:

```
EXTERNAL_API_KEY
DB_SERVICE_ROLE_KEY
PAYMENT_SECRET_KEY
EMAIL_API_KEY
```

## ログのセキュリティ

```typescript
// ❌ 禁止: secret をログに含める
console.log('API call with key:', apiKey);
console.log('User data:', JSON.stringify(userData));

// ✅ 安全: ID のみログに残す
console.log('Processing resource:', resourceId, 'for tenant:', tenantId);
```

## ファイルアップロード

- アップロードするファイルの MIME type を検証する
- ファイルサイズ制限を設ける
- ファイル名をサニタイズする（パストラバーサル防止）
- ストレージのアクセス制御でテナント分離を保証する

## 依存関係のセキュリティ

- `npm audit` / `pnpm audit` を定期実行する
- 既知の脆弱性のあるパッケージを使用しない
- 新しいパッケージを追加する際はセキュリティ履歴を確認する（risk:high の確認事項）

## セキュリティインシデント対応

Secret が漏洩した場合:

1. **即座にローテーションする**（各サービスのダッシュボード / 管理画面で）
2. 漏洩した secret を使用したアクセスログを確認する
3. Orchestrator Claude および人間に報告する
4. インシデントを Issue として記録する

Sub-agent が secret を出力した場合:

1. 即座に出力を破棄する
2. secret をローテーションする
3. インシデントとして記録する

## セキュリティレビュー

以下の変更は `security-review` Skill による確認が必須:

- 認証・認可ロジックの変更
- DB アクセス制御ポリシーの変更
- 外部 API の呼び出し追加
- ファイルアップロード機能
- Webhook の実装

詳細: `.claude/skills/security-review/SKILL.md`
