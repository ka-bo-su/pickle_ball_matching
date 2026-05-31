# Conflict Resolution Policy

## 概要

並列開発中に発生するマージコンフリクトを安全に解決するためのルールを定義する。

## コンフリクトの種類

### 1. Git コンフリクト（ファイル内容の衝突）

同一ファイルの同一箇所を複数の branch が変更した場合に発生。

### 2. 論理的コンフリクト（依存関係の衝突）

ファイルは変更されていないが、動作が変わる変更の組み合わせ。例: API の interface 変更 + それを使う component の変更。

### 3. 依存コンフリクト（package.json 衝突）

複数の branch が異なるパッケージを追加・更新した場合。

## Git コンフリクトの解決手順

### Step 1: main を取り込む

```bash
# worktree 内で実行
git fetch origin
git rebase origin/main
```

### Step 2: コンフリクトを確認する

```bash
git status
# Unmerged paths: を確認
```

### Step 3: コンフリクトを解決する

```
BEGIN CONFLICT EXAMPLE: HEAD（現在の branch）
const foo = 'new value';
CONFLICT SEPARATOR
const foo = 'other value';
END CONFLICT EXAMPLE: origin/main
```

**解決原則:**

- 両方の変更が必要な場合: マージして両立させる
- 片方のみが正しい場合: 正しい方を採用する
- 判断できない場合: Orchestrator Claude に報告し、人間判断を仰ぐ

### Step 4: 解決後の確認

```bash
git add <resolved-file>
git rebase --continue

# テストが通ること
pnpm lint
pnpm typecheck
pnpm test
```

## package.json コンフリクトの解決

```bash
# 両方の変更を確認する
git diff HEAD origin/main -- package.json

# 両方のパッケージを含むように手動マージ
# pnpm-lock.yaml は再生成する
pnpm install
git add package.json pnpm-lock.yaml
```

## コンフリクトが解決できない場合

1. `git rebase --abort` でリベースを中止する
2. Orchestrator Claude に状況を報告する
3. Orchestrator Claude が人間に通知するか判断する
4. 場合によっては `status:needs-human` を付けて停止する

## 論理的コンフリクトの検出

自動検出は難しいため、以下を手動で確認する:

- PR の変更が既存の API interface と整合しているか
- マージ後に型エラーが出ないか (`pnpm typecheck`)
- マージ後にテストが通るか (`pnpm test`)

## 並列開発によるコンフリクト予防

1. Issue 作成時に Allowed Paths の重複を確認する
2. `parallel:review` ラベルの Issue は Orchestrator Claude が調整する
3. Shared Files（`src/lib/`, `src/types/` 等）は変更前に他 Issue の状況を確認する
4. `package.json` の変更は PR に明記し、Orchestrator Claude が調整する

## 強制 push の禁止

コンフリクト解決のために `git push --force` を使うことを禁止する。

代わりに:

```bash
git push --force-with-lease  # 他の変更がなければ許可（慎重に）
```

ただし PR branch（`claude/issue-<N>-<slug>`）への force-with-lease は Orchestrator Claude の承認後のみ許可する。
