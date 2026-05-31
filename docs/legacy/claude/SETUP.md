# 新プロジェクトへのセットアップ手順

## Step 1: ファイルをコピー

```bash
PROJECT_DIR=/path/to/your/project
TEMPLATE_DIR=/Users/kazuma/Documents/claude_auto_develop

# Skills
cp -r $TEMPLATE_DIR/.claude/skills $PROJECT_DIR/.claude/

# Rules
mkdir -p $PROJECT_DIR/docs/rules
cp $TEMPLATE_DIR/docs/rules/*.md $PROJECT_DIR/docs/rules/

# GitHub テンプレート
cp -r $TEMPLATE_DIR/.github $PROJECT_DIR/
```

## Step 2: CLAUDE.md を作成

```bash
cp $TEMPLATE_DIR/CLAUDE.md.template $PROJECT_DIR/CLAUDE.md
```

以下のプレースホルダーを埋める:

| プレースホルダー | 内容 |
|----------------|------|
| `[PROJECT_NAME]` | プロジェクト名 |
| `[PROJECT_DESCRIPTION]` | 一行説明 |
| `[DEVELOPER / ORGANIZATION]` | 開発者・組織名 |
| `[CORE_VALUE]` | プロダクトの核心価値 |
| `[MVP_PRINCIPLE]` | MVP の方針 |
| `[FEATURE_1..3]` | MVP 優先機能 |
| `[DEFERRED_1..2]` | MVP 後回し機能 |
| `[PROJECT_SPECIFIC_HUMAN_GATES]` | プロジェクト固有の人間判断ゲート |
| `[LIST_PROTECTED_FILES]` | 保護ファイルパス |
| `[LINT/TYPECHECK/TEST/BUILD_COMMAND]` | CI コマンド |
| `[DATE]` | 作成日 |

## Step 3: GitHub ラベルを作成

以下のラベルを GitHub リポジトリに作成する（`docs/rules/issue-labels.md` 参照）:

```bash
# type ラベル
gh label create "type:feature" --color "0052cc" --repo OWNER/REPO
gh label create "type:bug" --color "d73a4a" --repo OWNER/REPO
gh label create "type:refactor" --color "e4e669" --repo OWNER/REPO
gh label create "type:docs" --color "0075ca" --repo OWNER/REPO
gh label create "type:test" --color "e4e669" --repo OWNER/REPO
gh label create "type:security" --color "ee0701" --repo OWNER/REPO
gh label create "type:foundation" --color "5319e7" --repo OWNER/REPO

# priority ラベル
gh label create "priority:p0" --color "b60205" --repo OWNER/REPO
gh label create "priority:p1" --color "d93f0b" --repo OWNER/REPO
gh label create "priority:p2" --color "f9d0c4" --repo OWNER/REPO
gh label create "priority:p3" --color "fef2c0" --repo OWNER/REPO

# status ラベル
gh label create "status:todo" --color "e4e669" --repo OWNER/REPO
gh label create "status:ready" --color "0e8a16" --repo OWNER/REPO
gh label create "status:in-progress" --color "0075ca" --repo OWNER/REPO
gh label create "status:review-needed" --color "fbca04" --repo OWNER/REPO
gh label create "status:approved" --color "0e8a16" --repo OWNER/REPO
gh label create "status:changes-requested" --color "d93f0b" --repo OWNER/REPO
gh label create "status:done" --color "6f42c1" --repo OWNER/REPO
gh label create "status:needs-human" --color "b60205" --repo OWNER/REPO
gh label create "status:blocked" --color "e11d48" --repo OWNER/REPO

# risk ラベル
gh label create "risk:low" --color "0e8a16" --repo OWNER/REPO
gh label create "risk:medium" --color "fbca04" --repo OWNER/REPO
gh label create "risk:high" --color "d93f0b" --repo OWNER/REPO
gh label create "risk:critical" --color "b60205" --repo OWNER/REPO

# size ラベル
gh label create "size:xs" --color "c2e0c6" --repo OWNER/REPO
gh label create "size:s" --color "c2e0c6" --repo OWNER/REPO
gh label create "size:m" --color "f9d0c4" --repo OWNER/REPO
gh label create "size:l" --color "f9d0c4" --repo OWNER/REPO
gh label create "size:xl" --color "fef2c0" --repo OWNER/REPO

# area ラベル（プロジェクトに合わせて変更）
gh label create "area:frontend" --color "f9d0c4" --repo OWNER/REPO
gh label create "area:backend" --color "f9d0c4" --repo OWNER/REPO
gh label create "area:db" --color "f9d0c4" --repo OWNER/REPO
gh label create "area:auth" --color "f9d0c4" --repo OWNER/REPO
gh label create "area:api" --color "f9d0c4" --repo OWNER/REPO
```

## Step 4: ブランチ構成を確認

```bash
# dev ブランチを作成（まだなければ）
git checkout -b dev
git push -u origin dev

# dev をデフォルトブランチに設定（GitHub UI から設定）
# Settings > Branches > Default branch → dev
```

## Step 5: CI ワークフローを追加

プロジェクトのビルド・テスト用 `ci.yml` を `.github/workflows/` に追加する。
`pr-policy.yml` と `issue-policy.yml` はコピー済みなので、そのまま使える。

`pr-policy.yml` 内の以下を確認・調整:
- `base_branch: dev` → プロジェクトのデフォルト PR ターゲット
- ラベル名がプロジェクトのラベルと一致しているか

## Step 6: worktrees ディレクトリを準備

```bash
# プロジェクトの親ディレクトリに worktrees 用ディレクトリを作成
mkdir -p /path/to/parent/PROJECT_NAME-wt
```

## Step 7: 動作確認

```bash
# 最初の Issue を作成して自律ループをテスト
# Claude Code に以下を指示:
# "select-next-issue Skill を実行して、次に実装すべき Issue を選んで"
```

---

## よくある調整ポイント

### worktree パスが違う場合
`CLAUDE.md` と `docs/rules/worktree-policy.md` の worktree パス規則を修正する。

### PR を main に直接向けたい場合
`docs/rules/merge-policy.md` と `CLAUDE.md` の Branch Strategy セクション、
および `.github/workflows/pr-policy.yml` の `base_branch` を修正する。

### Supabase / PostgreSQL RLS を使う場合
`docs/rules/database-policy.md` の「アクセス制御」セクションを Supabase 向けに具体化し、`docs/rules/rls-policy.md` として追加することを推奨する。

### プロジェクト固有の AI 機能ポリシーが必要な場合
`ai-feature-policy.md` を参考にプロジェクト固有版を作成し `docs/rules/` に追加する。
