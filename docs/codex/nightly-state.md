# Nightly State

- Started at: 2026-06-01 02:34 JST
- Current objective: Finish autonomous Codex iOS environment, then build the day-of doubles operation MVP.
- Current PBI: #16 当日運営特化ダブルス組み合わせMVP
- Current SBI: #84 参加者追加時に重複名を検出して案内する
- Active branch: codex/sbi-84-duplicate-participant-guide
- Active worktree: `/Users/kazuma/Documents/pickle_ball_matching`
- Active PR: pending
- Active GitHub Project: `kanban@pickle_ball_matching`
- Project owner: `ka-bo-su`
- Project number: `3`
- Last successful validation: 2026-06-05 15:54 JST, targeted `xcodebuild test` for Issue #84. Last full validation: 2026-06-05 15:42 JST on Issue #82 branch.
- Current blocker: Issue #84 full validation/publish is blocked by Codex execution usage limit; GitHub Project field sync is also blocked because `gh` token is invalid.
- Next action: after usage reset, rerun `scripts/codex/validate-ios.sh`, commit/push Issue #84, create PR, and keep Project pending updates until `gh` authentication is restored.
