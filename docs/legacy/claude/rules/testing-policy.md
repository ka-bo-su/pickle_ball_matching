# Testing Policy

## 基本方針

- **テストなしの PR は原則マージしない**
- 新機能には必ず対応するテストを書く
- テストは実装と同一 PR に含める
- CI が通らない状態で PR を open しない

## テスト種別と責務

### Unit Test

**対象:** Domain ロジック、Use Case、ユーティリティ関数

```typescript
// src/features/orders/__tests__/order-score.test.ts
import { describe, it, expect } from 'vitest'; // or jest, etc.
import { calculateScore } from '../domain/order-score';

describe('calculateScore', () => {
  it('returns S for scores above 85', () => {
    expect(calculateScore({ quality: 90, speed: 88 })).toBe('S');
  });
});
```

### Integration Test

**対象:** Repository 実装、API エンドポイント、サーバー処理

```typescript
// src/features/orders/__tests__/order-repository.integration.test.ts
describe('OrderRepository', () => {
  it('finds order within tenant only', async () => {
    const order = await repo.findById(orderId, tenantId);
    expect(order?.tenantId).toBe(tenantId);
  });
});
```

### DB アクセス制御テスト（テナント分離が重要な場合）

**対象:** テナント間のデータアクセス制御

```typescript
// src/__tests__/db-access/orders.test.ts
it('rejects cross-tenant access', async () => {
  const client = createClientForTenant(otherTenantId);
  const result = await client.findById(orderId);
  expect(result).toBeNull(); // アクセス制御でフィルタされる
});
```

### E2E Test

**対象:** ユーザーが使う主要フロー

```
e2e/
├── auth/
│   ├── login.spec.ts
│   └── signup.spec.ts
└── orders/
    ├── create-order.spec.ts
    └── view-orders.spec.ts
```

E2E はメインのフロー（Happy Path）のみカバー。エラーケースは Integration Test で。

## テストカバレッジ方針

| レイヤー | 目標カバレッジ |
|---------|--------------|
| Domain | 90% 以上 |
| Application（Use Case） | 80% 以上 |
| Infrastructure（Repository） | キーパスのみ |
| Feature（Server-side 処理） | 主要パス |
| UI コンポーネント | 必要な場合のみ |

カバレッジの「量」より「重要なパスを網羅しているか」を優先する。

## テストコマンド

プロジェクトのパッケージマネージャー・ツールに合わせて設定する:

```bash
[TEST_COMMAND]              # Unit + Integration テスト
[E2E_TEST_COMMAND]          # E2E テスト
[TEST_COVERAGE_COMMAND]     # カバレッジレポート付き
```

## テストファイルの命名規則

```
src/features/<feature>/__tests__/<name>.test.ts          # Unit
src/features/<feature>/__tests__/<name>.integration.test.ts  # Integration
src/__tests__/db-access/<table>.test.ts                  # DB アクセス制御
e2e/<feature>/<flow>.spec.ts                             # E2E
```

## モックの方針

### モックしてよいもの

- 外部 API（AI プロバイダー、決済サービス、メールサービス 等）
- 時刻（`new Date()`）
- ランダム値（`Math.random()`）

### モックしてはいけないもの

- **DB アクセス**（アクセス制御を含む全ての DB アクセスは実 DB を使う）
- **認証ロジック**（モックすると脆弱性を見落とす）
- Repository Interface の実装（Infrastructure テストでは実 DB）

## テストデータ管理

```typescript
// src/__tests__/helpers/seed.ts
export async function seedTestTenant() {
  const tenant = await createTenant({ name: 'Test Org' });
  const user = await createUser({ tenantId: tenant.id });
  return { tenant, user };
}
```

テスト後のクリーンアップを確実に行う:

```typescript
afterEach(async () => {
  await cleanup(tenant.id); // テナント配下の全データを削除
});
```

## CI でのテスト実行

```yaml
# .github/workflows/ci.yml
- name: Run tests
  run: |
    [DB_START_COMMAND]   # ローカル DB 起動（必要な場合）
    [TEST_COMMAND]
    [DB_STOP_COMMAND]    # ローカル DB 停止（必要な場合）
```

## テストが通らない PR

- CI が失敗している PR は Fix Claude がアサインされる
- テストを skip（`.skip`, `todo`）して PR を出すことは禁止
- 既存テストを削除して CI を通すことは禁止
