# Parallel Issue Policy

## 概要

複数の Issue を並列で進める際のルールと安全装置を定義する。

## 並列実行の原則

```
parallel:safe     → 同時実行可能（ファイル競合なし）
parallel:review   → 要確認（ファイルが重複する可能性あり）
parallel:blocked  → 並列不可（依存関係あり）
```

## 並列 OK の条件

以下の全てを満たす場合のみ並列実行を許可する:

1. 各 Issue が **異なる worktree** で作業している
2. 各 Issue の **Allowed Paths が重複しない**
3. 各 Issue が **互いに依存していない**（Blocked by がない）
4. どちらも **Protected Files を触らない**
5. DB migration が含まれていない（migration は sequential）

## 並列実行の事前チェック

```
Issue A: src/features/brands/**
Issue B: src/features/diagnosis/**
→ paths 重複なし → parallel:safe ✅

Issue A: src/features/brands/**
Issue B: src/components/shared/**
→ shared は多くの features が使う → parallel:review ⚠️

Issue A: DB migration (brands table)
Issue B: DB migration (diagnosis table)
→ migration は sequential にする → parallel:blocked ❌
```

## Orchestrator Claude の責務

並列作業を調整するのは Orchestrator Claude の責務:

1. `select-next-issue` Skill で次の Issue を複数選ぶ
2. 各 Issue の Allowed Paths を確認・設定する
3. paths の重複がないことを確認する
4. 並列実行可能な場合のみ複数の Implementation Claude を起動する

## コンフリクトリスクの管理

### 高コンフリクトリスクファイル

以下のファイルは多くの Issue が触る可能性があるため、並列実行時に注意:

```
src/components/shared/**
src/lib/**
src/types/**
package.json
pnpm-lock.yaml
tsconfig.json
```

これらを変更する Issue は `parallel:review` ラベルを付け、Orchestrator Claude が調整する。

### package.json の変更

複数の Issue が同時に `package.json` を変更する場合:

1. 一方が先にマージされる
2. もう一方は rebase してコンフリクトを解決してから PR を更新する

## マージ順序の管理

並列で進んでいる PR はマージ順序を Orchestrator Claude が管理する:

```
Priority:
1. risk:low / risk:medium の小さい Issue を先にマージ
2. 他 Issue の依存先になっている Issue を先にマージ
3. risk:high 以上は人間承認を待つ（他はブロックしない）
```

## 並列実行の上限

推奨する同時並列数:

| 環境 | 推奨並列数 |
|------|-----------|
| 通常開発 | 2〜3 Issue |
| Sprint 初期（基盤構築） | 1 Issue（sequential） |
| Feature 追加期 | 3〜5 Issue |
| バグ修正のみ | 無制限（scope が小さい場合） |

## parallel ラベルの付け方

Orchestrator Claude または Planning Claude が Issue 作成時に設定:

```
parallel:safe    → 他 Issue と同時実行してよい
parallel:review  → Orchestrator Claude の確認が必要
parallel:blocked → 依存 Issue が完了するまで待つ
```

## コンフリクト解決

並列開発でコンフリクトが発生した場合は `docs/rules/conflict-resolution-policy.md` を参照。
