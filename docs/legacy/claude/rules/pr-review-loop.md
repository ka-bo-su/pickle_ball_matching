# PR Review Loop

## レビューループの全体フロー

```
Implementation Claude → [PR open] → Review Claude → [approved / changes_requested]
                                          ↓
                               changes_requested の場合
                                          ↓
                              Fix Claude → [修正] → Review Claude → [re-review]
                                          ↓
                                      approved
                                          ↓
                              Merge Readiness Check
                                          ↓
                          auto-merge (Low/Medium) or human approval (High/Critical)
```

## Review Claude の責務

Review Claude は **実装者とは別の Claude セッション** として振る舞い、第三者の視点でレビューする。

### レビュー観点

1. **Acceptance Criteria**: 全て満たしているか
2. **テスト**: 十分なテストが追加されているか
3. **セキュリティ**: 脆弱性・データ露出リスクがないか
4. **Organization 分離**: 他 organization のデータにアクセスしていないか
5. **アクセス制御/Permission**: 適切な権限チェックがあるか
6. **型安全性**: TypeScript / Zod が適切に使われているか
7. **CI**: 全ての CI チェックが通っているか
8. **スコープ**: Issue のスコープ外の変更がないか
9. **Protected files**: 無断で protected files を変更していないか
10. **AI output**: AI 出力が Zod で検証されているか（AI 機能の場合）

### Block 条件（必ず changes_requested を出す）

- CI が失敗している
- linked Issue がない
- Acceptance Criteria が未達
- テストが不足または不適切
- organization データ分離が壊れている
- secrets がコードに含まれている
- unsafe な DB migration がある
- アクセス制御 / permission リスクが未解決
- critical / high の unresolved コメントがある

### Warning 条件（コメントで指摘するが block しない）

- テストカバレッジが低い
- コードが複雑すぎる
- ドキュメント更新が望ましい
- Follow-up Issue を作成すべき課題がある

### Follow-up Issue の作成

レビュー中に以下を発見した場合は `create-followup-issue` Skill を使う:

- 今の PR スコープ外の改善点
- 将来対応すべき技術的負債
- パフォーマンス改善
- セキュリティ強化

## Fix Claude の責務

### 修正スコープ

Fix Claude は以下のみ修正できる:

- Review Claude のコメントに対応する修正
- CI 失敗の修正
- Issue のスコープ内の変更

Fix Claude は以下をしてはいけない:

- スコープ外のリファクタリング
- 新機能の追加
- 関係ないファイルの変更

### 修正後の対応

1. `check-write-permission` を実行する
2. 修正を push する
3. Review Claude のコメントに返信する（`respond-to-review` Skill）
4. 全ての CI が通過していることを確認する

## Review コメントの分類

| Severity | 意味 | Fix Claude の対応 |
|----------|------|-----------------|
| `[BLOCK]` | マージ不可、必ず修正 | 必須対応 |
| `[SUGGEST]` | 推奨、対応推奨 | 対応推奨 |
| `[FOLLOWUP]` | 今の PR 外で対応 | Follow-up Issue 作成 |
| `[NIT]` | 細かい指摘、任意 | 任意対応 |

## Re-review のトリガー

Fix Claude が修正を push した後:

1. PR に re-review request コメントを残す
2. Review Claude が再度レビューする
3. 全ての `[BLOCK]` コメントが resolve されていることを確認する
4. 問題なければ approve する

## レビューが長引く場合

3回以上のレビューループが発生した場合:

1. `status:needs-human` を付ける
2. 人間に状況を報告する
3. 次のアクションについて指示を仰ぐ
