# Codex Audit Log

## 2026-06-01 02:34 JST

### Action

Migrated the repository direction from Claude/Web/TypeScript template toward Codex/iOS/Swift autonomous development.

### Reason

The repository must support long-running autonomous Codex development without human approval gates, while preserving traceability, testability, Clean Architecture boundaries, and GitHub Project synchronization.

### Files Changed

- Created Codex configuration, subagent definitions, Scrum docs, architecture docs, GitHub templates, validation scripts, SwiftPM core, and XcodeGen app shell.
- Moved `CLAUDE.md.template`, `SETUP.md`, and old `docs/rules/*` under `docs/legacy/claude/`.

### Commands Run

- `find . -maxdepth 4 (...)`
- `gh repo view --json owner,name,url`
- `gh project list --owner ka-bo-su --format json`
- `gh project field-list 3 --owner ka-bo-su --format json`
- `gh label list --repo ka-bo-su/pickle_ball_matching --json name,color,description --limit 200`
- local tool version probes

### GitHub Project Updates

Project resolved:

- Name: `kanban@pickle_ball_matching`
- Owner: `ka-bo-su`
- Number: `3`
- URL: `https://github.com/users/ka-bo-su/projects/3`

Initial field, label, and item updates were planned.

### Architecture Decision

Use SwiftPM for testable core and XcodeGen for the iOS SwiftUI app shell. Start with folder/protocol boundaries and avoid premature multi-module complexity.

### Validation

Pending after file creation.

### Risk

Medium. Repository structure is being changed substantially, but changes are isolated to a feature branch and can be reverted as one PR.

### Follow-up

Run validation, update GitHub Project, create PR, and continue to the next SBI.

## 2026-06-01 02:55 JST

### Action

Completed the first autonomous Codex/iOS foundation increment and synchronized local evidence.

### Reason

The repository needs an inspectable baseline before long-running Codex development can continue safely.

### Files Changed

- Added Codex agent config, Scrum docs, architecture docs, runbooks, audit/progress/nightly ledgers, GitHub templates, and validation scripts.
- Moved Claude-specific files under `docs/legacy/claude/`.
- Added SwiftPM core with Domain/Application/Infrastructure boundaries and XCTest.
- Added XcodeGen SwiftUI app shell and Composition Root.
- Replaced web/TypeScript validation assumptions with SwiftPM, SwiftLint, SwiftFormat, XcodeGen, and xcodebuild validation.

### Commands Run

- `scripts/codex/preflight.sh`
- `swiftformat --swiftversion 6.0 --cache ignore .`
- `swift test`
- `swiftlint --no-cache`
- `swiftformat --swiftversion 6.0 --cache ignore --lint .`
- `xcodegen generate`
- `xcodebuild -list -project PickleBallMatching.xcodeproj`
- `xcodebuild build -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'`
- `scripts/codex/validate-ios.sh`
- `scripts/codex/nightly-summary.sh`

### GitHub Project Updates

- Created/confirmed required labels.
- Created/confirmed required Project fields.
- Created Japanese Issues #1-#7 for the initial PBI/SBI/Chore backlog.
- Added Issues #1-#7 to Project `kanban@pickle_ball_matching`.
- Set Project metadata including Backlog Level, Scrum Status, Sprint, Role Owner, Parent PBI, Risk, Area, Architecture Impact, and initial Evidence Link.
- Updated Validation Status to `Passed` for initial Project items #1-#7.

### Architecture Decision

Use SwiftPM for the testable core and XcodeGen for the iOS app shell. Keep the generated `.xcodeproj` out of git and regenerate from `project.yml`.

### Validation

Passed: preflight, `swift test`, SwiftLint, SwiftFormat lint, XcodeGen generation, Xcode project listing, and iOS simulator build.

### Risk

Low to medium. The foundation is broad but isolated to a feature branch and structured as a small first bootstrap PR.

### Follow-up

Open PR to `dev`, attach PR evidence to Project items and Issues, then continue with the next SBI.

## 2026-06-01 02:57 JST

### Action

Replaced literal conflict-marker examples in a legacy Claude document with non-marker placeholders.

### Reason

`git diff --check` treats literal `<<<<<<<`, `=======`, and `>>>>>>>` lines as unresolved conflict markers even inside Markdown code fences. The document is legacy-only, but the bootstrap PR must remain mechanically clean.

### Files Changed

- `docs/legacy/claude/rules/conflict-resolution-policy.md`

### Commands Run

- `git diff --cached --check`

### GitHub Project Updates

No Project change required.

### Architecture Decision

None.

### Validation

`git diff --cached --check` passed after the edit.

### Risk

Low. The legacy document remains archived and no longer trips repository hygiene checks.

### Follow-up

Continue commit and PR creation.

## 2026-06-01 03:00 JST

### Action

Created PR #8 and synchronized Project evidence for the initial backlog items.

### Reason

The autonomous loop requires PR evidence and Project state updates instead of human approval gates.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/audit-log.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/scrum/sprint-backlog.md`
- `docs/scrum/sprint-review-log.md`

### Commands Run

- `git push -u origin codex-autonomous-ios-foundation`
- `gh pr view 8 --json number,state,isDraft,mergeable,mergeStateStatus,headRefName,baseRefName,commits,statusCheckRollup,url`
- `gh project item-edit ...`

### GitHub Project Updates

- Set Project items #1-#7 to `In Review`.
- Set Scrum Status for Project items #1-#7 to `In Review`.
- Set Evidence Link for Project items #1-#7 to `https://github.com/ka-bo-su/pickle_ball_matching/pull/8`.

### Architecture Decision

release-reviewer can merge PR #8 to `dev` because validation passed, PR is mergeable, and no protected operation is required.

### Validation

PR #8 mergeability: `MERGEABLE`, merge state: `CLEAN`, status checks: none configured.

### Risk

Low. Merge target is `dev`, not `main`.

### Follow-up

Squash merge PR #8 to `dev`, close/update Issues #1-#7, set Project items Done, and continue the next SBI.

## 2026-06-01 03:08 JST

### Action

Squash merged PR #8 to `dev`, closed initial Issues, and synchronized Project items to Done.

### Reason

The bootstrap increment met Definition of Done and did not require human approval. `main` was not modified.

### Files Changed

- `docs/codex/audit-log.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/next-work-search.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/scrum/sprint-review-log.md`

### Commands Run

- `gh pr view 8 --json number,state,closed,mergedAt,mergeCommit,url,baseRefName,headRefName`
- `gh project item-edit ...`
- `gh issue edit ...`
- `gh issue comment ...`
- `git fetch origin dev`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `git branch --set-upstream-to=origin/dev dev`

### GitHub Project Updates

- Project items #1-#7 set to `Done`.
- Scrum Status for Project items #1-#7 set to `Done`.
- Validation Status remains `Passed`.
- Evidence Link remains PR #8.

### Architecture Decision

Post-merge ledger updates are recorded on `dev`; `main` remains untouched. The local `dev` upstream was corrected to `origin/dev` to avoid accidentally treating `origin/main` as the integration branch.

### Validation

PR #8 merged to `dev` with merge commit `7d4264c31ef72506dec733b95867a602c7e04754`. Previous validation remains current for the merged code.

### Risk

Low. The update is bookkeeping-only after a validated merge.

### Follow-up

Select or create the next narrow SBI for ViewModel tests, accessibility polish, or the first product vertical slice.

## 2026-06-01 03:09 JST

### Action

Created the next Ready SBI as Issue #9 and added it to Project `kanban@pickle_ball_matching`.

### Reason

The autonomous loop should not end with an empty next-action queue after the bootstrap increment is Done.

### Files Changed

- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/next-work-search.md`
- `docs/codex/audit-log.md`

### Commands Run

- GitHub issue creation through GitHub connector
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/9`
- `gh project item-edit ...`

### GitHub Project Updates

- Issue #9 added as Backlog Level `SBI`.
- Status set to `Ready`.
- Scrum Status set to `Ready`.
- Role Owner set to `swift-developer`.
- Risk set to `low`.
- Area set to `UI`.
- Validation Status set to `Not Run`.

### Architecture Decision

Next work should improve Presentation testability before larger product feature expansion.

### Validation

No code changed for Issue #9 creation.

### Risk

Low. This is backlog preparation only.

### Follow-up

Implement Issue #9 in the next autonomous cycle.

## 2026-06-01 03:12 JST

### Action

Ran final validation on `dev` after PR #8 merge and post-merge ledger updates.

### Reason

The final branch state should be verified after merge and documentation bookkeeping.

### Files Changed

- `docs/codex/ios-swift-validation.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

No additional Project updates required.

### Architecture Decision

None.

### Validation

Passed on `dev`: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen generation, `xcodebuild -list`, and iOS Simulator build.

### Risk

Low.

### Follow-up

Proceed with Issue #9.

## 2026-06-01 03:35 JST

### Action

Completed the iOS development environment hardening pass.

### Reason

The repository needs repeatable local and CI validation before larger MVP development proceeds.

### Files Changed

- `.swiftformat`
- `Brewfile`
- `Makefile`
- `.github/workflows/ios-validation.yml`
- `scripts/codex/bootstrap-ios.sh`
- `scripts/codex/validate-ios.sh`
- `project.yml`
- `Tests/PickleBallMatchingTests/AppSmokeTests.swift`
- `docs/codex/local-environment.md`
- `docs/codex/ios-swift-validation.md`

### Commands Run

- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Pending environment Chore Issues and PR evidence sync.

### Architecture Decision

Use repo-local `.swiftformat`, `Brewfile`, and XcodeGen scheme/test target configuration rather than relying on per-machine defaults.

### Validation

Passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test`.

### Risk

Low. Changes are tooling/configuration only, with one smoke test target.

### Follow-up

Create environment Chore Issues, update Project, open PR, and merge to `dev`.

## 2026-06-01 03:36 JST

### Action

Created and synchronized environment completion Chore Issues #10-#13.

### Reason

Environment hardening work must be traceable through GitHub Project before MVP implementation continues.

### Files Changed

- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/next-work-search.md`
- `docs/codex/audit-log.md`

### Commands Run

- GitHub issue creation through GitHub connector
- `gh project item-add ...`
- `gh project item-edit ...`

### GitHub Project Updates

- Issues #10-#13 added to Project `kanban@pickle_ball_matching`.
- Project metadata set to Chore / In Progress / Sprint 2026-06 environment / Validation Passed.

### Architecture Decision

Complete validation/tooling before app MVP expansion.

### Validation

No source behavior changed after the previous validation run.

### Risk

Low. GitHub Actions macOS billing is documented for human review; no billing settings were changed.

### Follow-up

Open PR for environment completion and merge to `dev`.

## 2026-06-01 03:41 JST

### Action

Hardened CI/local validation and reran the full environment bootstrap path.

### Reason

GitHub Actions runners may not always expose the exact same iPhone Simulator name as the local machine. Validation should prefer `iPhone 16`, fall back to another available iPhone Simulator, and fail if no iPhone Simulator is available.

### Files Changed

- `scripts/codex/validate-ios.sh`
- `docs/codex/ios-swift-validation.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/audit-log.md`

### Commands Run

- `scripts/codex/bootstrap-ios.sh`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

No additional Project update yet. Issues #10-#13 remain In Progress until PR evidence is available.

### Architecture Decision

None. This is validation infrastructure only.

### Validation

Passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild -list`, `xcodebuild build`, and `xcodebuild test`.

### Risk

Low. The change makes CI behavior stricter by failing when no iPhone Simulator exists instead of silently skipping Xcode build/test.

### Follow-up

Commit, open PR, sync Project evidence, and merge to `dev`.

## 2026-06-01 03:47 JST

### Action

Fixed the PR #14 GitHub Actions failure by adding `Shared/.gitkeep`.

### Reason

CI runs from a fresh checkout. The XcodeGen spec includes `Shared/`, but an empty directory is not tracked by git, so `xcodegen generate` failed on GitHub Actions with a missing source directory.

### Files Changed

- `Shared/.gitkeep`
- `docs/codex/audit-log.md`

### Commands Run

- `gh run view 26721182081 --log-failed`

### GitHub Project Updates

Issues #10-#13 were moved to In Review and linked to PR #14 before the CI fix.

### Architecture Decision

Keep `Shared/` as an explicit future module boundary in the XcodeGen source list and track the empty directory with `.gitkeep`.

### Validation

GitHub Actions failed before this fix at `xcodegen generate`. Local revalidation then passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test`.

### Risk

Low. The fix adds an empty placeholder only.

### Follow-up

Amend the PR commit, push, and wait for CI again.

## 2026-06-01 03:56 JST

### Action

Merged PR #14 to `dev` and closed environment completion Issues #10-#13.

### Reason

Environment completion reached Definition of Done: local validation passed, GitHub Actions passed, Project evidence was linked, and the PR was squash merged to the integration branch.

### Files Changed

No local files changed in this checkpoint beyond the merged PR contents.

### Commands Run

- `gh pr view 14 --json mergeable,mergeStateStatus,statusCheckRollup,headRefOid,url`
- GitHub connector merge for PR #14
- `gh project item-edit ...`
- GitHub connector issue close for Issues #10-#13

### GitHub Project Updates

Issues #10-#13 moved to Done in Project `kanban@pickle_ball_matching`.

### Architecture Decision

Environment completion remains tooling-only. No production/App Store/TestFlight actions were taken.

### Validation

PR #14 GitHub Actions `validate` passed before merge.

### Risk

Low. The only ongoing human follow-up is awareness of GitHub Actions macOS runner usage.

### Follow-up

Continue with Issue #9, then create MVP Product Backlog items for the day-of operation app.

## 2026-06-01 04:03 JST

### Action

Implemented Issue #9 ViewModel state transition tests and accessibility polish.

### Reason

Before replacing the bootstrap matching shell with the day-of operation MVP, the app test target should prove it can test Presentation state transitions and keep SwiftUI accessibility labels explicit.

### Files Changed

- `Features/Matching/Presentation/MatchingViewModel.swift`
- `Features/Matching/Presentation/MatchingView.swift`
- `Tests/PickleBallMatchingTests/MatchingViewModelTests.swift`
- `project.yml`
- `docs/codex/ios-swift-validation.md`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/audit-log.md`

### Commands Run

- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #9 moved to In Progress in Project `kanban@pickle_ball_matching`.

### Architecture Decision

Introduced `MatchCandidatesLoading: Sendable` as the Presentation-side seam for ViewModel tests while keeping the concrete `LoadMatchCandidatesUseCase` as the live implementation.

### Validation

First validation caught a Swift 6 Sendable issue and an unstable async test. After fixing both, full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test`.

### Risk

Low. This is test/accessibility hardening and does not change the core matching algorithm.

### Follow-up

Open PR for Issue #9, merge to `dev`, then start the MVP domain replacement.

## 2026-06-01 04:10 JST

### Action

Merged PR #15 to `dev`, closed Issue #9, and created MVP Product Backlog Issues #16-#20 plus SBI Issue #21 in Japanese.

### Reason

The environment is now complete enough to support app development, and the MVP backlog needs to reflect the product vision before replacing the bootstrap shell.

### Files Changed

No local files changed in this checkpoint beyond the merged PR contents.

### Commands Run

- GitHub connector merge for PR #15
- GitHub connector issue creation for Issues #16-#21
- `gh project item-add ...`
- `gh project item-edit ...`

### GitHub Project Updates

- Issue #9 set Done.
- Issues #16-#20 added as PBI items.
- Issue #21 added as the selected In Progress SBI under PBI #16.

### Architecture Decision

Start the MVP with a vertical slice that includes Domain, Application, Presentation, DI, and tests instead of building a large abstract foundation.

### Validation

PR #15 GitHub Actions `validate` passed before merge.

### Risk

Medium for the next SBI because it replaces the bootstrap domain model; risk is controlled by tests and small PR scope.

### Follow-up

Implement Issue #21.

## 2026-06-01 04:20 JST

### Action

Implemented SBI #21: participants, court count, first round generation, waiters, and a Japanese operation board.

### Reason

This is the first user-visible MVP slice toward the north star: the organizer can enter participants, set court count, generate the first doubles round, and see waiters.

### Files Changed

- `Sources/PickleBallMatchingCore/Domain/Participant.swift`
- `Sources/PickleBallMatchingCore/Domain/Session.swift`
- `Sources/PickleBallMatchingCore/Domain/Round.swift`
- `Sources/PickleBallMatchingCore/Application/GenerateNextRoundUseCase.swift`
- `Tests/PickleBallMatchingCoreTests/GenerateNextRoundUseCaseTests.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- `App/CompositionRoot/DependencyContainer.swift`
- `App/PickleBallMatchingApp.swift`
- `docs/product/vision.md`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #21 remains In Progress until PR evidence is available.

### Architecture Decision

Replaced the bootstrap candidate-matching model with day-of operation entities and `GenerateNextRoundUseCase`. Presentation depends on the use case and Domain models; View does not call Infrastructure.

### Validation

First validation caught lint shape and MainActor DI boundary issues. After fixing them, full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test`.

### Risk

Medium. This is the first real product slice and removes the temporary matching shell. Tests cover round counts, unavailable participants, previous waiters, level balancing, and ViewModel actions.

### Follow-up

Open PR for Issue #21, merge to `dev`, then continue with JSON persistence or manual swap/undo.

## 2026-06-01 04:31 JST

### Action

Merged PR #22 to `dev`, closed Issue #21, and created/selected Issue #23 for local JSON save/restore.

### Reason

SBI #21 completed the first operation-board increment. The next useful MVP work is local-first persistence so the organizer does not lose the session after closing the app.

### Files Changed

No local files changed in this checkpoint beyond merged PR contents.

### Commands Run

- GitHub connector merge for PR #22
- `gh project item-edit ...` for Issue #21 Done sync
- GitHub connector issue update for Issue #21 close
- GitHub connector issue creation for Issue #23
- `gh project item-add ...`
- `gh project item-edit ...` for Issue #23 Ready/In Progress fields
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `git switch -c codex/sbi-23-json-persistence`

### GitHub Project Updates

- Issue #21 moved to In Review with PR #22 evidence, then Done after merge.
- Issue #23 added to Project as SBI, Priority P1, Role Owner swift-developer, Parent PBI #17, Validation Status Not Run, then moved to In Progress.

### Architecture Decision

Selected local JSON persistence as the next vertical slice. SwiftData and CloudKit remain future options and are not required for the MVP.

### Validation

PR #22 GitHub Actions `validate` passed before merge.

### Risk

Low for merge sync; medium for the next persistence slice because storage failures must not crash the operation board.

### Follow-up

Implement Issue #23 and validate with persistence tests plus full iOS validation.

## 2026-06-01 04:38 JST

### Action

Implemented SBI #23: JSON session save/restore, ViewModel autosave/restore wiring, and persistence tests.

### Reason

The MVP requires the session to survive app close/reopen. JSON file persistence keeps the first release local-first, testable, and independent from CloudKit or SwiftData.

### Files Changed

- `Sources/PickleBallMatchingCore/Application/SessionRepository.swift`
- `Sources/PickleBallMatchingCore/Infrastructure/JSONSessionRepository.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `App/CompositionRoot/DependencyContainer.swift`
- `Tests/PickleBallMatchingCoreTests/JSONSessionRepositoryTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swift test`
- `scripts/codex/validate-ios.sh`
- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #23 remains In Progress until PR evidence is available.

### Architecture Decision

Added `SessionRepository` in the Application layer and `JSONSessionRepository` in Infrastructure. The app Composition Root wires the concrete repository; the ViewModel depends on the protocol and does not know file-system details.

### Validation

First full validation caught SwiftFormat lint only while build/test passed. After formatting and splitting a test helper to remove a SwiftLint warning, full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test`.

### Risk

Medium. This introduces local file I/O. Risk is controlled with JSON round-trip, missing-file, broken-file, ViewModel restore, and autosave tests.

### Follow-up

Open PR for Issue #23, update Project evidence, merge to `dev`, then continue with manual swap/undo or participant status editing.

## 2026-06-01 04:40 JST

### Action

Created PR #24 for Issue #23 and moved the GitHub Project item to In Review.

### Reason

SBI #23 passed local validation and is ready for CI-backed review/merge tracking.

### Files Changed

- Local docs updated to record PR #24 and Project state.

### Commands Run

- `git add ...`
- `git diff --cached --check`
- `git commit -m "feat(persistence): save and restore operation sessions" ...`
- `git push -u origin codex/sbi-23-json-persistence`
- GitHub connector PR creation for PR #24
- `gh project item-edit ...` for Issue #23 In Review and Evidence Link
- GitHub connector issue update for Issue #23 `status:in-review`

### GitHub Project Updates

Issue #23 set to Status In review, Scrum Status In Review, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/24`.

### Architecture Decision

No new architecture decision beyond the `SessionRepository` Application boundary and JSON Infrastructure implementation.

### Validation

Local `scripts/codex/validate-ios.sh` passed before PR creation. GitHub Actions validation is pending.

### Risk

Medium until CI confirms the fresh-checkout path.

### Follow-up

Wait for PR #24 CI, merge to `dev` if clean, close Issue #23, then select the next Ready SBI.

## 2026-06-01 04:57 JST

### Action

Merged PR #24 to `dev`, closed Issue #23, created Issue #25, and selected it for implementation.

### Reason

Local JSON persistence was complete and CI passed. The next highest-value MVP slice is participant status changes because day-of operation depends on late, break, absent, and observing states affecting the next generated round.

### Files Changed

No local files changed in this checkpoint beyond merged PR contents.

### Commands Run

- GitHub connector merge for PR #24
- `gh project item-edit ...` for Issue #23 Done sync
- GitHub connector issue update for Issue #23 close
- GitHub connector issue creation for Issue #25
- `gh project item-add ...`
- `gh project item-edit ...` for Issue #25 Ready/In Progress fields
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `git switch -c codex/sbi-25-participant-status`

### GitHub Project Updates

- Issue #23 set Done with Validation Status Passed.
- Issue #25 added as SBI, Priority P1, Role Owner swift-developer, Parent PBI #16, Validation Status Not Run, then moved to In Progress.

### Architecture Decision

Participant status changes remain in Presentation/ViewModel and reuse the existing Domain status availability rule. No new Infrastructure dependency is introduced.

### Validation

PR #24 GitHub Actions `validate` passed before merge.

### Risk

Medium. The UI must make availability visible without relying on color alone, and status changes must not bypass autosave.

### Follow-up

Implement Issue #25 and validate with ViewModel tests plus full iOS validation.

## 2026-06-01 05:00 JST

### Action

Implemented SBI #25: participant status menu, ViewModel status update, autosave, and unavailable-participant exclusion tests.

### Reason

The MVP must handle normal day-of changes without making the organizer remember who is resting, absent, late, or observing.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`
- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #25 remains In Progress until PR evidence is available.

### Architecture Decision

The ViewModel mutates `Participant.status`, updates the session timestamp, and saves through `SessionRepository`. The SwiftUI row exposes a status menu with text labels and symbols; Domain continues to own availability through `ParticipantStatus.isAvailableForRound`.

### Validation

First full validation passed with one SwiftLint line-length warning. After splitting the long label line and keeping the status menu separately accessible, final full validation passed at 05:03 JST: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test`.

### Risk

Medium. Status changes directly affect round generation. Tests cover autosave and exclusion of unavailable statuses from generated matches.

### Follow-up

Open PR for Issue #25, update Project evidence, merge to `dev`, then continue with manual swap/undo.

## 2026-06-01 05:08 JST

### Action

Merged PR #26 to `dev`, closed Issue #25, and synchronized Project status to Done.

### Reason

Participant status changes passed validation and GitHub Actions. The MVP can now exclude break, absent, late, leaving, and observing participants from the next generated round without human approval gates.

### Files Changed

No local files changed in this checkpoint beyond merged PR contents.

### Commands Run

- GitHub connector merge for PR #26
- GitHub connector issue update for Issue #25 close
- `gh project item-edit ...` for Issue #25 Done and Validation Passed
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `git switch -c codex/sbi-27-manual-swap-undo`

### GitHub Project Updates

Issue #25 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #26.

### Architecture Decision

No new architecture decision. Status availability remains owned by Domain and invoked from Presentation through the ViewModel.

### Validation

PR #26 GitHub Actions `validate` passed before merge.

### Risk

Low. Merge target was `dev`; `main` was not modified.

### Follow-up

Create and implement the next SBI for manual waiter swap and one-step undo.

## 2026-06-01 08:55 JST

### Action

Created Issue #27 for manual waiter swap and one-step undo, added it to GitHub Project, and selected it for implementation.

### Reason

The product vision explicitly requires organizers to manually fix generated combinations at court-side. A narrow current-round swap plus one-step undo delivers that value without building a large editing subsystem first.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- GitHub connector issue creation for Issue #27
- `gh project item-add ...`
- `gh project item-edit ...` for Issue #27 fields
- GitHub connector issue label update for `status:in-progress`

### GitHub Project Updates

Issue #27 added as SBI, Priority P1, Role Owner `swift-developer`, Parent PBI #16, Validation Status `Not Run`, then moved to In Progress.

### Architecture Decision

Keep the first manual edit capability Presentation-local: the View calls the ViewModel, and the ViewModel updates the current `Round` and persists through `SessionRepository`. No View-to-Infrastructure dependency is introduced.

### Validation

No source validation required for issue creation.

### Risk

Medium. Manual swaps can diverge from generated fairness counters; the first increment intentionally limits scope to current-round display and persistence.

### Follow-up

Implement swap/undo with ViewModel tests and full validation.

## 2026-06-01 09:02 JST

### Action

Implemented SBI #27: waiting-player swap menus, one-step undo, autosave, and ViewModel tests.

### Reason

The organizer needs a fast way to correct generated pairings for context the algorithm cannot know, while preserving a safe undo path for court-side mistakes.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `swiftlint --no-cache`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #27 remains In Progress until PR evidence is available.

### Architecture Decision

Manual swap captures a single in-memory session snapshot before mutation. Undo restores that snapshot and autosaves it. This keeps the first implementation small and reversible; richer multi-step `Snapshot` history remains a future SBI.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 8 core tests and 12 app tests.

### Risk

Medium. The current implementation updates the current round and waiting list but does not recalculate participant fairness counters after a manual swap. This is acceptable for the first manual-edit slice and should be revisited with snapshot/history improvements.

### Follow-up

Commit, open PR for Issue #27, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 09:06 JST

### Action

Created PR #28 for Issue #27 and moved the GitHub Project item to In Review.

### Reason

SBI #27 passed local validation and now needs PR/CI evidence before autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git add ...`
- `git diff --cached --check`
- `git commit -m "feat(operation): add waiter swap and undo"`
- `git push -u origin codex/sbi-27-manual-swap-undo`
- `gh pr create ...`
- `gh project item-edit ...` for Issue #27 In Review and Evidence Link
- `gh issue edit 27 ...` for `status:in-review`
- `gh pr view 28 --json ...`

### GitHub Project Updates

Issue #27 set to Status `In review`, Scrum Status `In Review`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/28`.

### Architecture Decision

No new architecture decision. PR #28 carries the manual swap/undo implementation and the documented follow-up for fairness counter recalculation.

### Validation

Local validation passed before PR creation. GitHub Actions `validate` started for PR #28.

### Risk

Medium until CI completes. During the first PR creation attempt, shell expansion interpreted Markdown command spans and reran validation commands locally; no destructive operation occurred, and the PR was recreated with a shorter shell-safe body.

### Follow-up

Wait for PR #28 CI, merge to `dev` if clean, close Issue #27, update Project Done, and continue with the next MVP SBI.

## 2026-06-01 09:10 JST

### Action

Squash merged PR #28 to `dev`, closed Issue #27, and synchronized Project status to Done.

### Reason

Manual waiter swap and one-step undo passed local validation and GitHub Actions. The increment is small, reversible, and directly supports court-side manual correction.

### Files Changed

- Post-merge Codex/Scrum ledger docs

### Commands Run

- `gh pr checks 28 --watch --interval 10`
- `gh pr merge 28 --squash --delete-branch ...`
- `gh pr view 28 --json ...`
- `gh project item-edit ...` for Issue #27 Done and Validation Passed
- `gh issue edit 27 ...`
- `gh issue close 27 ...`
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #27 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #28.

### Architecture Decision

No new decision. The richer `Snapshot` history and fairness counter recalculation remain explicit follow-up work instead of expanding this SBI.

### Validation

PR #28 GitHub Actions `validate` passed before merge. Local validation also passed before PR creation.

### Risk

Low after merge. `dev` was updated; `main` was not modified.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are CSV export, larger progress board, or richer snapshot/undo history.
