# File Ownership Policy

## 概要

各 Issue が変更してよいファイル範囲（Allowed Paths）と変更禁止ファイル（Protected Files）を定義する。

## Allowed Paths の設定ルール

### Feature Issue の場合

```
src/features/<feature-name>/**    # ドメイン機能
src/app/app/<route>/**            # App Router ページ
src/components/<feature-name>/**  # Feature 専用コンポーネント
```

例: Brand 機能の Issue

```markdown
## Allowed Paths
- src/features/brands/**
- src/app/app/brands/**
- src/components/brands/**
```

### API / Server-side Issue の場合

```
src/app/api/<route>/**
src/features/<feature-name>/actions/**
src/features/<feature-name>/queries/**
```

### Test Issue の場合

```
src/features/<feature-name>/__tests__/**
src/features/<feature-name>/*.test.ts
e2e/<feature-name>/**
```

### Foundation / Infrastructure Issue の場合

Orchestrator Claude または人間が明示的に設定する。Protected Files が含まれる場合は人間承認必須。

## Protected Files（変更禁止 - 人間承認なし）

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

## Shared Files（変更時は `parallel:review`）

複数の Feature Issue が触る可能性があるファイル群。並列実行時はコンフリクトに注意。

```
src/components/shared/**
src/components/ui/**       # UI コンポーネントライブラリ
src/lib/**
src/types/**
src/hooks/**
package.json
pnpm-lock.yaml
tsconfig.json
tailwind.config.ts
```

## ファイル所有権の競合

2つの Issue が同じファイルを Allowed Paths に含めている場合:

1. Orchestrator Claude が先に検出する
2. どちらが先にマージするかを決定する
3. 後からマージする Issue は rebase 義務あり

## CODEOWNERS との対応

`.github/CODEOWNERS` と Allowed Paths は整合していること。

```
# .github/CODEOWNERS（例）
db/migrations/ @humans
src/infrastructure/payment/ @humans
.github/ @humans
```

## Allowed Paths 外の変更

実装中に Allowed Paths 外のファイルを変更する必要が生じた場合:

1. Orchestrator Claude に報告する
2. Orchestrator Claude が Allowed Paths を拡張するか判断する
3. Protected Files であれば `status:needs-human` で人間判断を仰ぐ
4. Orchestrator Claude の承認なしに Allowed Paths 外を変更しない

## Issue への Allowed Paths 記載形式

```markdown
## File Ownership

### Allowed Paths
- src/features/brands/**
- src/app/app/brands/**
- src/components/brands/**

### Forbidden Paths（一部抜粋）
- db/migrations/**
- src/domain/permission/**
- .github/**
```
