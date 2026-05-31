# Autonomous Dev Loop

このドキュメントは、Claude エージェントが自律的に開発ループを回すための全体フローを定義します。

## ループの全体像

```
1. Planning Claude   → Epic / Issue / Sub-issue / 依存関係 / ラベルを作る
2. Orchestrator Claude → 次の Issue を選ぶ
3. Implementation Claude → Issue を claim し、worktree を作成して実装する
4. Implementation Claude → PR を open する
5. Review Claude     → 第三者レビューする
6. Fix Claude        → レビュー指摘・CI 失敗を修正する（必要な場合）
7. Review Claude     → 再確認する
8. Merge Readiness Check → auto-merge (Low/Medium) or human approval (High/Critical)
9. マージ後           → 自動デプロイ（設定済みの場合）
10. Orchestrator Claude → 次の Issue を選び、ループを繰り返す
```

## Step 1: Planning Phase

### Planning Claude の責務

- Epic を作成する（GitHub Issue として）
- Epic を Sub-issue に分解する
- 各 Issue に以下を設定する:
  - Parent Epic
  - 依存関係 (Blocked by / Blocks / Related)
  - File Ownership (allowed paths / forbidden paths)
  - Risk Assessment (risk:low / medium / high / critical)
  - Acceptance Criteria
  - Test Requirements
  - ラベル
- Issue 間の依存関係グラフを作成する

### 使用 Skill

- `project-planning`
- `issue-create`
- `issue-dependency-map`

## Step 2: Issue Selection

### Orchestrator Claude の責務

- `select-next-issue` Skill を実行して次の Issue を選ぶ
- 選択条件:
  - `status:ready`
  - dependencies が完了済み
  - `status:blocked` でない
  - `status:needs-human` でない
  - `risk:critical` でない（human 承認が必要）
  - parallel policy に違反しない
- Implementation Claude に Issue と worktree を割り当てる

### 自律継続のための選択方針

人間判断が必要な Issue やスコープ外変更が見つかった場合でも、Orchestrator Claude は全体の開発ループを止めず、以下の順序で進める。

1. ブロック要因が特定の変更だけなら、その変更を follow-up Issue に分離する
2. follow-up Issue には `status:needs-human` と適切な risk ラベルを付ける
3. 元 Issue は allowed paths 内で完了できる範囲まで進める
4. 元 Issue が完了不能なら `status:needs-human` を付け、次の `status:ready` Issue を選ぶ
5. `status:ready` の候補が複数ある場合は、priority、依存先、size、risk の順で選ぶ

この方針は、human decision required のルールを回避するものではない。人間判断が必要な部分を明示的に止め、判断不要な Issue を継続するための運用である。

### 使用 Skill

- `select-next-issue`
- `assign-worktree`

## Step 3: Implementation

### Implementation Claude の責務

1. `claim-issue` Skill を実行して Issue を claim する
2. `assign-worktree` Skill を実行して専用 worktree を作成する
3. 作業開始前に `check-write-permission` Skill を実行する
4. 実装を行う
5. PR 作成前に以下を実行する:
   ```bash
   pnpm lint
   pnpm typecheck
   pnpm test
   pnpm build
   ```
6. `open-pr` Skill を実行して PR を作成する

### 禁止事項

- main worktree での直接実装
- 複数 Issue の同時作業
- allowed paths 外のファイル変更
- protected files の無断変更

### 使用 Skill

- `claim-issue`
- `assign-worktree`
- `check-write-permission`
- `implement-issue`
- `open-pr`

## Step 4: Code Review

### Review Claude の責務

1. `review-pr` Skill を実行する
2. 以下の観点でレビューする:
   - Acceptance Criteria を満たしているか
   - テストが十分か
   - セキュリティリスクがないか
   - organization データ分離が守られているか
   - アクセス制御 / permission リスクがないか
   - CI が通っているか
3. 問題があれば `changes_requested` を出す
4. Follow-up Issue が必要な場合は `create-followup-issue` Skill を使う
5. 問題なければ `approved` を出す

### Review Claude は絶対にファイルを修正しない

- PR ファイルへの直接修正は禁止
- 修正指示はコメントで伝える

### 使用 Skill

- `review-pr`
- `create-followup-issue`（必要な場合）

## Step 5: Fix Phase（必要な場合）

### Fix Claude の責務

1. レビューコメントを確認する
2. `check-write-permission` Skill を実行する
3. 修正を行う（scope 内のみ）
4. CI を通す
5. `respond-to-review` Skill を実行してレビューに返信する

### 使用 Skill

- `check-write-permission`
- `fix-ci`（CI 失敗の場合）
- `respond-to-review`

## Step 6: Merge Readiness Check

### Orchestrator Claude の責務

1. `merge-readiness-check` Skill を実行する
2. auto-merge 条件を確認する:
   - `risk:low` または `risk:medium`
   - required CI が全て成功
   - Review Claude が承認
   - unresolved critical/high コメントなし
   - `status:needs-human` がない
3. 条件を満たす場合: auto-merge を有効化
4. `risk:high` / `risk:critical` の場合: `status:needs-human` を付けて人間に通知して停止

### 使用 Skill

- `merge-readiness-check`

## Step 7: Deploy（設定済みの場合）

- main ブランチへのマージ後、自動デプロイが走る
- デプロイ確認は `deployment-check` Skill を使う

## エラー・例外処理

| 状況 | 対応 |
|------|------|
| CI 失敗 | Fix Claude が `fix-ci` Skill で対応 |
| Review で changes_requested | Fix Claude が対応し Review Claude が再確認 |
| risk:high / critical | `status:needs-human` を付けて人間に通知し停止 |
| 依存 Issue が未完了 | `status:blocked` にして待機 |
| コンフリクト発生 | `resolve-merge-conflict` Skill で対応 |
| 仕様不明点 | `status:needs-human` を付けて人間に確認 |
| protected / forbidden path 変更が必要 | 対象変更だけを follow-up Issue に分離し、元 Issue はスコープ内で継続 |

## 並列実行

- `parallel:safe` の Issue は並列実行可能
- `parallel:caution` の Issue は慎重に判断
- `parallel:unsafe` の Issue は直列実行必須

詳細: `docs/rules/parallel-issue-policy.md`
