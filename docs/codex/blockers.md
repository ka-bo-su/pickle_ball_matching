# Blockers

## Blocker

- Time: 2026-06-04 21:03 JST
- Item: Issue #74 `保存済みセッションを削除できるようにする` and participant-add UX fix
- Type: GitHub authentication
- Reason: Full local validation now passes and PR #75 exists, but `gh` returns `HTTP 401: Requires authentication` for GraphQL calls, so CI check inspection and GitHub Project field sync cannot be completed from this session.
- Impact: PR #75 is open with local validation evidence, but GitHub Actions status and Project fields remain pending.
- Attempted fixes: Confirmed the prior validation blocker is resolved by running escalated `scripts/codex/validate-ios.sh`; pushed the branch; created PR #75 through the GitHub connector; retried `gh pr checks 75` and received HTTP 401.
- Why autonomous progress cannot continue for this item: CI confirmation and Project sync are required before squash merge, and GitHub CLI authentication is unavailable for those operations.
- Safe next task selected: keep local fix committed and pending; do not start additional stacked feature work until the publish path is healthy.
- GitHub Project update: pending update recorded in `docs/codex/github-projects-pending-updates.md`.
- Pending update: check PR #75 CI, set Issue #74 In Review, set Validation Status Passed, add PR evidence, and squash merge if CI is green after GitHub authentication is restored.
- Human repair: run `gh auth login` or `gh auth refresh -s project` in this environment.

## Resolved Blocker

- Time: 2026-06-02 22:19 JST
- Resolved: 2026-06-04 21:03 JST
- Item: Issue #74 `保存済みセッションを削除できるようにする`
- Type: execution-environment
- Reason: Non-escalated `scripts/codex/validate-ios.sh` failed because SwiftPM could not write `~/.cache/clang/ModuleCache` and CoreSimulatorService was unavailable inside the sandbox. The required escalated rerun was rejected by Codex execution usage limit.
- Impact: Saved-session deletion is implemented locally on `codex/sbi-31-delete-saved-sessions`, but full validation, push, PR creation, and Project In Review sync cannot complete in this execution window.
- Attempted fixes: Ran the repository validation script normally; it passed SwiftLint, SwiftFormat lint, XcodeGen generation, and `xcodebuild -list`, then failed on sandbox-only SwiftPM/Simulator access. Escalated rerun was requested per policy and rejected by usage limit.
- Why autonomous progress cannot continue for this item: Retrying through another execution path after usage-limit rejection would be an indirect workaround. Publishing without full validation would violate the repository DoD.
- Safe next task selected: none requiring validation or GitHub publication; keep the local branch ready and record pending updates.
- GitHub Project update: Issue #74 label changed to `status:blocked`; Project Status/Scrum Status still need Blocked field sync, pending update recorded in `docs/codex/github-projects-pending-updates.md`.
- Pending update: rerun full validation, push branch, create PR, set Status/Scrum Status In Review, set Validation Status Passed, and add PR Evidence Link.
- Human repair: none if Codex execution quota resumes; otherwise run the pending validation and publication commands manually.
- Resolution: Escalated `scripts/codex/validate-ios.sh` passed on 2026-06-04 21:03 JST. Remaining blocker is GitHub authentication, tracked separately above.

## Resolved Blocker

- Time: 2026-06-02 17:28 JST
- Resolved: 2026-06-02 22:08 JST
- Item: SBI-031 GitHub Issue/Project creation and full validation
- Type: execution-environment
- Reason: `swift test` failed inside the sandbox because SwiftPM could not write `~/.cache/clang/ModuleCache`; the required escalated rerun was rejected because the current Codex execution usage limit is exhausted. GitHub Issue/Project creation would hit the same escalation/network constraint.
- Impact: Saved-session deletion is locally implemented and lint/format checked, but full `swift test`, xcodebuild validation, GitHub Issue creation, Project item creation, push, and PR cannot be completed until execution quota resumes.
- Attempted fixes: Ran `swift test` non-escalated, reran with escalation per sandbox policy, then ran safer local checks: SwiftLint, SwiftFormat lint, and `git diff --check`.
- Why autonomous progress cannot continue for this item: Retrying the same validation or GitHub writes through another path after usage-limit rejection would be an indirect workaround. The code can be committed locally and queued for full validation/publication.
- Safe next task selected: commit local SBI-031 and wait for GitHub/validation quota to resume before publishing; avoid additional stacked feature work unless it is small and local-only.
- GitHub Project update: pending update recorded in `docs/codex/github-projects-pending-updates.md`.
- Pending update: create Japanese Issue/Project item for `[SBI] 保存済みセッションを削除できるようにする`, run full validation, then push/create PR.
- Human repair: none required if Codex execution resumes; otherwise run the pending `gh` and validation commands manually.
- Resolution: Execution resumed. Issue #74 was created in Japanese, added to Project item `PVTI_lAHOBHYYMs4BZUKkzgufzTw`, and moved to In Progress. Fresh validation remains part of active Issue #74 work, not an environment blocker.

## Resolved Blocker

- Time: 2026-06-02 15:57 JST
- Resolved: 2026-06-02 21:58 JST
- Item: Issue #70 Project/Issue Done sync after PR #71 merge
- Type: execution-environment
- Reason: Codex escalation auto-review rejected `gh issue edit`, `gh issue close`, and `gh project item-edit` because the current Codex execution usage limit is exhausted.
- Impact: PR #71 was squash merged to `dev`, but GitHub Issue #70 and Project item remain In Review until the GitHub write commands can resume.
- Attempted fixes: Confirmed PR #71 CI pass and mergeability, squash merged PR #71, then attempted Issue/Project Done sync. The GitHub write commands were rejected by the usage limit.
- Why autonomous progress cannot continue for this item: Retrying the same GitHub writes through another network path after usage-limit rejection would be an indirect workaround. The item can be localized as a pending Project update.
- Safe next task selected: Issue #72 `大画面ボードに残り時間とラウンド状態を表示する`.
- GitHub Project update: Pending update recorded in `docs/codex/github-projects-pending-updates.md`.
- Pending update: close Issue #70 and set Project Status/Scrum Status Done after execution quota resets.
- Human repair: none required if Codex execution resumes with GitHub write access; otherwise run the commands in the pending update.
- Resolution: Issue #70 was closed with `status:done`, and Project Status/Scrum Status were set to Done.

## Resolved Blocker

- Time: 2026-06-02 16:03 JST
- Resolved: 2026-06-02 22:07 JST
- Item: Issue #72 push/PR/Project sync
- Type: execution-environment
- Reason: Non-escalated `git push -u origin codex/sbi-72-large-board-timer` failed because the sandbox could not resolve `github.com`; escalated push was rejected because the current Codex execution usage limit is exhausted.
- Impact: Issue #72 is locally implemented, validated, and committed as `1fe7687`, but the branch is not pushed and no PR exists yet.
- Attempted fixes: Ran full local validation successfully, committed locally, tried normal push, then tried escalated push per sandbox rules.
- Why autonomous progress cannot continue for this item: Retrying through REST or another network path after usage-limit rejection would be an indirect workaround. The work is localized and can resume after quota resets.
- Safe next task selected: none requiring GitHub write; continue only local docs/code work if useful.
- GitHub Project update: pending update recorded in `docs/codex/github-projects-pending-updates.md`.
- Pending update: push branch, create PR, set Validation Status Passed, set Status/Scrum Status In Review, add Evidence Link.
- Human repair: none required if Codex execution resumes with GitHub write access; otherwise run the commands in the pending update.
- Resolution: PR #73 was created, passed GitHub Actions, squash merged to `dev`, Issue #72 was closed, and Project Status/Scrum Status were set to Done.

## Resolved Blocker

- Time: 2026-06-02 09:18 JST
- Resolved: 2026-06-02 14:38 JST
- Item: PR #65 / Issue #64 `現在ラウンドのスコアと勝者を記録できるようにする`
- Type: execution-environment
- Reason: Codex escalation auto-review rejected `gh pr checks 65` and `gh run view 26790276942` because the current Codex execution usage limit is exhausted.
- Impact: PR #65 is open, branch `codex/sbi-64-match-score-entry` is pushed, and Issue #64 / Project are in In Review, but CI result confirmation, squash merge to `dev`, Issue close, and Project Done sync cannot be completed in this execution window.
- Attempted fixes: Watched `gh pr checks 65 --watch --interval 10` until the check remained pending, then attempted direct status commands. The follow-up status commands were rejected by the execution usage limit.
- Why autonomous progress cannot continue for this item: Merging without confirming PR #65 CI would break the repository's autonomous DoD discipline. Retrying through another network path would be an indirect workaround after the usage-limit rejection.
- Safe next task selected: none in this execution window; keep PR #65 localized and ready for CI follow-up.
- GitHub Project update: Issue #64 is already In Review with Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/65` and Validation Status `Passed`.
- Pending update: after execution quota resets, check PR #65 CI, squash merge if green, close Issue #64, and set Project item Done.
- Human repair: wait for Codex execution quota reset or resume in an environment where escalated GitHub CLI commands are available.
- Resolution: Execution resumed. PR #65 remote CI had passed on the previously pushed head; blocker-resolution docs were prepared before final merge follow-up.

## Resolved Blocker

- Time: 2026-06-01 23:19 JST
- Resolved: 2026-06-02 08:00 JST
- Item: Issue #56 `進行ボードで試合開始と残り時間を扱えるようにする`
- Type: execution-environment
- Reason: Codex escalation auto-review rejected `swiftformat` and SwiftLint because the current Codex execution usage limit is exhausted. Non-escalated `swift test` also failed because SwiftPM/Xcode needs sandbox behavior and cache access unavailable in the current sandbox.
- Impact: Local implementation is present, but final validation, push, PR creation, and Project transition to In Review cannot be completed in this execution window.
- Attempted fixes: Split timer UI/ViewModel files to address prior lint size warnings; attempted workspace-local SwiftPM cache path; SwiftPM still failed at `sandbox_apply`; attempted `git push`, which was rejected by the same Codex execution usage limit.
- Why autonomous progress cannot continue for this item: Publishing without validation and Project evidence would break the repository's audit/DoD discipline. The code is kept locally on `codex/sbi-56-round-timer` for the next continuation.
- Safe next task selected: none yet; keep WIP localized until Issue #56 can be validated and published.
- GitHub Project update: Issue #56 is already In Progress in Project `kanban@pickle_ball_matching`.
- Pending update: record validation, PR evidence, and In Review transition in `docs/codex/github-projects-pending-updates.md`.
- Human repair: wait for Codex execution quota reset or resume in an environment where escalated local validation and GitHub push are available.
- Resolution: Execution quota reset. `scripts/codex/validate-ios.sh` passed, and Project Validation Status was updated to `Passed`.

## Blocker Template

- Time:
- Item:
- Type:
- Reason:
- Impact:
- Attempted fixes:
- Why autonomous progress cannot continue for this item:
- Safe next task selected:
- GitHub Project update:
- Pending update:
- Human repair:
