# Clean Architecture Policy

## 概要

このプロジェクトは **厳格な Clean Architecture** を採用する。
層の責務と依存方向を厳守し、疎結合・テスト容易性・変更容易性を保証する。

---

## レイヤー構造

```
src/
├── domain/               # ドメイン層（最内層・外部依存ゼロ）
│   ├── models/           # Entity / Value Object
│   ├── repositories/     # Repository Interface（抽象のみ）
│   ├── services/         # Domain Service（純粋なビジネスロジック）
│   └── events/           # Domain Event（任意）
│
├── application/          # アプリケーション層
│   ├── use-cases/        # Use Case（1クラス1ユースケース）
│   ├── dto/              # Input DTO / Output DTO（Use Case ごとに定義）
│   └── ports/            # 外部サービスの Interface（DB 以外: メール・AI・決済等）
│
├── infrastructure/       # インフラ層（外部依存の実装）
│   ├── repositories/     # Repository 実装（DB アクセス）
│   ├── services/         # Port 実装（外部 API クライアント等）
│   └── di/               # Composition Root（依存関係の組み立て）
│
└── presentation/         # プレゼンテーション層
    ├── controllers/      # リクエスト処理・DTO へのマッピング
    └── view-models/      # レスポンス整形（任意）
```

---

## 依存方向のルール（厳守）

```
presentation → application → domain
infrastructure → application → domain
```

**禁止パターン（絶対に違反しない）:**

```
domain → application          ❌ 内側が外側に依存しない
domain → infrastructure       ❌
domain → presentation         ❌
application → infrastructure  ❌ Use Case が具体実装を知ってはならない
application → presentation    ❌
infrastructure → presentation ❌
presentation → domain         ❌ ドメインオブジェクトをそのまま扱わない
```

---

## DTO の強制

**ドメインオブジェクト（Entity / Value Object）は application 層の外に出さない。**

Use Case の入出力は必ず DTO とする。これにより：
- ドメインモデルの変更がプレゼンテーション層に波及しない
- Use Case のインターフェースが安定する

```typescript
// application/dto/create-order.dto.ts
export interface CreateOrderInput {
  productId: string;
  quantity: number;
  buyerId: string;
}

export interface CreateOrderOutput {
  orderId: string;
  totalPrice: number;
  status: 'pending';
}

// application/use-cases/CreateOrderUseCase.ts
export class CreateOrderUseCase {
  async execute(input: CreateOrderInput): Promise<CreateOrderOutput> {
    const order = Order.create(input); // ← ドメインオブジェクトはここで完結
    await this.orderRepo.save(order);
    return { orderId: order.id, totalPrice: order.total, status: 'pending' }; // ← DTO で返す
  }
}
```

```typescript
// ❌ 禁止: domain オブジェクトをそのまま返す
async execute(input): Promise<Order> { ... }

// ❌ 禁止: presentation 層で domain 型を直接扱う
const order: Order = await createOrderUseCase.execute(input);
```

---

## Repository Pattern（厳格版）

interface は **domain 層**に、実装は **infrastructure 層**に置く。
Use Case は interface しか知らない。

```typescript
// domain/repositories/OrderRepository.ts（interface のみ）
export interface OrderRepository {
  findById(id: string, tenantId: string): Promise<Order | null>;
  save(order: Order): Promise<void>;
  delete(id: string): Promise<void>;
}

// infrastructure/repositories/DbOrderRepository.ts（実装）
export class DbOrderRepository implements OrderRepository {
  async findById(id: string, tenantId: string): Promise<Order | null> {
    // DB アクセスの具体実装はここだけ
  }
}
```

---

## Port Pattern（外部サービス）

DB 以外の外部サービス（メール・AI・決済等）も同様に **application/ports/** に interface を定義し、実装は infrastructure 層に置く。

```typescript
// application/ports/NotificationPort.ts
export interface NotificationPort {
  sendOrderConfirmation(to: string, orderId: string): Promise<void>;
}

// infrastructure/services/EmailNotificationService.ts
export class EmailNotificationService implements NotificationPort {
  async sendOrderConfirmation(to: string, orderId: string): Promise<void> {
    // メール送信の具体実装
  }
}
```

---

## Dependency Injection（依存関係の組み立て）

**`new ConcreteImplementation()` を呼んでよい場所は Composition Root のみ。**
Use Case やドメインサービスの中で具体クラスを `new` することは禁止。

```typescript
// infrastructure/di/container.ts（Composition Root）
export function buildCreateOrderUseCase(): CreateOrderUseCase {
  const orderRepo = new DbOrderRepository(db);
  const notifier = new EmailNotificationService(emailClient);
  return new CreateOrderUseCase(orderRepo, notifier); // ← ここだけで組み立て
}

// application/use-cases/CreateOrderUseCase.ts
export class CreateOrderUseCase {
  constructor(
    private readonly orderRepo: OrderRepository,     // ← interface
    private readonly notifier: NotificationPort,     // ← interface
  ) {}
}
```

---

## プレゼンテーション層の責務

Controller / Server Action の責務は3つだけ：

1. リクエストをパース・バリデーションして **Input DTO** に変換する
2. Use Case を呼び出す
3. **Output DTO** をレスポンス形式にマッピングして返す

```typescript
// presentation/controllers/OrderController.ts
export async function createOrderHandler(request: Request) {
  // 1. バリデーション → Input DTO
  const input = CreateOrderInputSchema.parse(await request.json());

  // 2. Use Case 呼び出し（Composition Root から取得）
  const useCase = buildCreateOrderUseCase();
  const output = await useCase.execute(input);

  // 3. Output DTO → レスポンス
  return Response.json({ id: output.orderId, total: output.totalPrice });
}
```

**禁止:**
- Controller が Repository や DB を直接呼ぶ
- Controller がビジネスロジックを含む
- Controller がドメインオブジェクトを直接参照する

---

## Value Object の使用

ドメイン概念を持つデータは primitive ではなく Value Object として定義する。

```typescript
// domain/models/Money.ts
export class Money {
  private constructor(
    private readonly amount: number,
    private readonly currency: string,
  ) {}

  static of(amount: number, currency: string): Money {
    if (amount < 0) throw new DomainError('Amount must be non-negative');
    return new Money(amount, currency);
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) throw new DomainError('Currency mismatch');
    return Money.of(this.amount + other.amount, this.currency);
  }
}
```

Value Object の条件：
- イミュータブル（変更不可）
- 等値比較は値で行う（参照ではない）
- ドメインのバリデーションロジックを内包する

---

## テストのレイヤー別方針

| レイヤー | テスト種別 | モック方針 |
|---------|-----------|-----------|
| Domain | Unit Test | モック不要（外部依存ゼロ） |
| Application（Use Case） | Unit Test | Repository / Port を **interface のモック** で代替 |
| Infrastructure | Integration Test | 実 DB・実サービスを使う |
| Presentation | Integration / E2E | 実 Use Case を使う（インフラはモック可） |

- Domain と Application のテストは高速・外部依存ゼロで実行できること
- Infrastructure テストでモックを使うと実際の挙動との乖離が生まれるため避ける

---

## 違反検出チェックリスト

新機能実装・レビュー時に確認する:

- [ ] `domain/` が外部ライブラリ・フレームワーク・環境変数を import していないか
- [ ] Use Case のコンストラクタ引数がすべて interface / abstract 型か（具体クラスを受け取っていないか）
- [ ] Use Case が DTO を返しているか（domain オブジェクトをそのまま返していないか）
- [ ] `new ConcreteClass()` が Composition Root 以外で呼ばれていないか
- [ ] DB 以外の外部サービスが `application/ports/` の interface 経由で呼ばれているか
- [ ] Controller / Server Action がビジネスロジックを含んでいないか
- [ ] プレゼンテーション層が domain 型を直接参照していないか
