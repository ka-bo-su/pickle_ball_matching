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

## 2026-06-01 09:18 JST

### Action

Created Issue #30 for current-round CSV sharing, added it to GitHub Project, and selected it for implementation.

### Reason

The MVP includes lightweight sharing/export. CSV is the smallest useful export increment because it is local-first, server-free, and testable without App Store or external services.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh issue create ...`
- `gh project item-add ...`
- `gh project item-edit ...`
- `gh issue edit 30 ...`
- `git switch -c codex/sbi-30-csv-export`

### GitHub Project Updates

Issue #30 added as SBI, Priority P2, Role Owner `swift-developer`, Parent PBI #19, Validation Status `Not Run`, then moved to In Progress.

### Architecture Decision

Implement CSV generation through an Application-layer `RoundExporting` protocol and Infrastructure `CSVRoundExporter`, then expose it through Presentation without adding server or CloudKit dependencies.

### Validation

No source validation required for issue creation.

### Risk

Medium. Export formats can spread UI assumptions if not isolated; this is controlled by putting CSV generation behind a core exporter.

### Follow-up

Implement CSV exporter, SwiftUI sharing, tests, validation, PR, and Project evidence sync.

## 2026-06-01 09:22 JST

### Action

Implemented SBI #30: current-round CSV exporter, SwiftUI `ShareLink`, CSV escaping tests, and ViewModel export tests.

### Reason

Organizers need a quick way to share the current round without manually copying court assignments. CSV text sharing is the smallest local-first export increment.

### Files Changed

- `Sources/PickleBallMatchingCore/Application/RoundExporting.swift`
- `Sources/PickleBallMatchingCore/Infrastructure/CSVRoundExporter.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `App/CompositionRoot/DependencyContainer.swift`
- `Tests/PickleBallMatchingCoreTests/CSVRoundExporterTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #30 remains In Progress until PR evidence is available.

### Architecture Decision

`RoundExporting` lives in Application and `CSVRoundExporter` lives in Infrastructure. The app Composition Root injects the concrete exporter into the ViewModel. SwiftUI receives already-generated CSV text and does not know export formatting rules.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 14 app tests.

### Risk

Medium. `ShareLink` currently shares CSV as text, not as a named `.csv` file. This is acceptable for the first export slice; file-based CSV/PDF/image export can be a follow-up.

### Follow-up

Commit, open PR for Issue #30, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 09:24 JST

### Action

Created PR #31 for Issue #30 and moved the GitHub Project item to In Review.

### Reason

SBI #30 passed local validation and now needs PR/CI evidence before autonomous merge to `dev`.

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
- `git commit -m "feat(export): share current round as csv"`
- `git push -u origin codex/sbi-30-csv-export`
- `gh pr create ...`
- `gh project item-edit ...` for Issue #30 In Review and Evidence Link
- `gh issue edit 30 ...` for `status:in-review`

### GitHub Project Updates

Issue #30 set to Status `In review`, Scrum Status `In Review`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/31`.

### Architecture Decision

No new decision. PR #31 carries the CSV export Application/Infrastructure boundary and text sharing implementation.

### Validation

Local validation passed before PR creation. GitHub Actions `validate` started for PR #31.

### Risk

Medium until CI completes.

### Follow-up

Wait for PR #31 CI, merge to `dev` if clean, close Issue #30, update Project Done, and continue with the next MVP SBI.

## 2026-06-01 09:32 JST

### Action

Squash merged PR #31 to `dev`, closed Issue #30, and synchronized Project status to Done.

### Reason

Current-round CSV sharing passed local validation and GitHub Actions. This completes the first small sharing/export increment without server, login, CloudKit, App Store, or billing dependencies.

### Files Changed

- Post-merge Codex/Scrum ledger docs

### Commands Run

- `gh pr checks 31 --watch --interval 10`
- `gh pr merge 31 --squash --delete-branch ...`
- `gh pr view 31 --json ...`
- `gh project item-edit ...` for Issue #30 Done and Validation Passed
- `gh issue edit 30 ...`
- `gh issue close 30 ...`
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #30 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #31.

### Architecture Decision

No new decision. CSV text sharing is accepted as the smallest export increment; file-based CSV/PDF/image export remains follow-up work.

### Validation

PR #31 GitHub Actions `validate` passed before merge. Local validation also passed before PR creation.

### Risk

Low after merge. `dev` was updated; `main` was not modified.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are larger board display or richer snapshot/undo history.

## 2026-06-01 10:00 JST

### Action

Created Issue #32 for participant-facing large board display, added it to GitHub Project, and selected it for implementation.

### Reason

The MVP north star requires participants to understand the next match without repeated organizer explanation. After CSV export, the highest-value next slice is a large, readable board display.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh issue create ...`
- `gh project item-add ...`
- `gh project item-edit ...`
- `gh issue edit 32 ...`
- `git switch -c codex/sbi-32-large-board-display`

### GitHub Project Updates

Issue #32 added as SBI, Priority P1, Role Owner `swift-developer`, Parent PBI #18, Validation Status `Not Run`, then moved to In Progress.

### Architecture Decision

Keep this slice in Presentation. Add a display model in the ViewModel and a SwiftUI `LargeBoardView`; no Infrastructure dependency is introduced.

### Validation

No source validation required for issue creation.

### Risk

Medium. The board must remain readable on iPhone and iPad and must not rely on color alone.

### Follow-up

Implement large board navigation, adaptive display, accessibility labels, tests, validation, PR, and Project evidence sync.

## 2026-06-01 10:05 JST

### Action

Implemented SBI #32: large board navigation, adaptive participant-facing display, no-round guidance, and display model tests.

### Reason

Participants need to read current courts, teams, waiters, and round information from a shared iPad or external display without asking the organizer.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`
- `swiftlint --no-cache`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #32 remains In Progress until PR evidence is available.

### Architecture Decision

`LargeBoardDisplayModel` and `LargeBoardCourtDisplay` are Presentation display models derived from Domain `Session` and `Round`. `LargeBoardView` observes the existing ViewModel and does not call repositories, exporters, or use cases directly.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 17 app tests.

### Risk

Medium. UI readability still benefits from later manual device/screenshot review, but automated build/test/lint coverage and display model tests passed.

### Follow-up

Commit, open PR for Issue #32, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 10:14 JST

### Action

Pushed `codex/sbi-32-large-board-display`, opened PR #33 for Issue #32, and moved the GitHub Project item to In Review.

### Reason

SBI #32 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-32-large-board-display`
- GitHub connector create PR
- `gh project item-edit ...` for Issue #32 In Review, Validation Passed, and Evidence Link

### GitHub Project Updates

Issue #32 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #33.

### Architecture Decision

No new decision. The PR keeps the large board display in Presentation.

### Validation

PR #33 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Low to medium. Automated validation passed; remaining risk is real device readability on iPad or external display.

### Follow-up

Wait for PR #33 CI, squash merge to `dev` if it passes, then set Issue #32 and Project item Done.

## 2026-06-01 10:20 JST

### Action

Squash merged PR #33 to `dev`, closed Issue #32, and set the GitHub Project item to Done.

### Reason

PR #33 passed GitHub Actions `validate`, met the SBI acceptance criteria, and preserved the Presentation-only architecture boundary.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh pr checks 33 --watch --interval 10`
- `gh pr merge 33 --squash --delete-branch ...`
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `gh project item-edit ...` for Issue #32 Done and Validation Passed

### GitHub Project Updates

Issue #32 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #33.

### Architecture Decision

No new decision. The merged increment keeps large board rendering inside Presentation and does not add Infrastructure coupling.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining UX risk is real-world readability on iPad or external display, tracked as a future validation concern.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are richer snapshot/undo history or session creation UI.

## 2026-06-01 10:24 JST

### Action

Created Issue #34 for editable session settings, added it to GitHub Project, and selected it for implementation.

### Reason

After PR #33, the highest-value next slice is helping the organizer start today's session with the correct name, round duration, and operation mode instead of relying on a fixed default state.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- GitHub connector create issue
- `gh project item-add ...`
- `gh project item-edit ...`
- `git switch -c codex/sbi-34-session-settings`

### GitHub Project Updates

Issue #34 added as SBI, Priority P0, Role Owner `swift-developer`, Parent PBI #16, Validation Status `Not Run`, and moved to In Progress.

### Architecture Decision

Keep the slice in Presentation/ViewModel. Session edits mutate Domain `Session` values and use the existing `SessionRepository` save path; no new Infrastructure dependency is introduced.

### Validation

No source validation required for issue creation.

### Risk

Medium. New session start clears local in-memory session state, so the UI uses a confirmation dialog.

### Follow-up

Implement session name, round duration, operation mode, blank new-session start, tests, validation, PR, and Project evidence sync.

## 2026-06-01 10:35 JST

### Action

Implemented SBI #34: editable session settings, blank new-session start, autosave coverage, and presentation file split to keep SwiftLint clean.

### Reason

Organizers need to quickly configure today's session without hidden sample data or fixed session settings.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/LargeBoardView.swift`
- `Features/OperationBoard/Presentation/SessionSettingsSection.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #34 remains In Progress until PR evidence is available.

### Architecture Decision

`SessionSettingsSection` is a Presentation subview observing the existing `OperationBoardViewModel`. It does not call repositories directly. `LargeBoardView` was split out to keep `OperationBoardView` from becoming a large UI object.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 21 app tests with 0 lint violations.

### Risk

Medium. The destructive new-session action is guarded by a confirmation dialog; further UX review can refine wording and placement.

### Follow-up

Commit, open PR for Issue #34, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 10:38 JST

### Action

Pushed `codex/sbi-34-session-settings`, opened PR #35 for Issue #34, and moved the GitHub Project item to In Review.

### Reason

SBI #34 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-34-session-settings`
- GitHub connector create PR
- `gh project item-edit ...` for Issue #34 In Review, Validation Passed, and Evidence Link

### GitHub Project Updates

Issue #34 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #35.

### Architecture Decision

No new decision. The PR keeps session settings in Presentation/ViewModel and uses the existing repository boundary.

### Validation

PR #35 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The UI now has a destructive new-session action, mitigated by confirmation dialog and test coverage.

### Follow-up

Wait for PR #35 CI, squash merge to `dev` if it passes, then set Issue #34 and Project item Done.

## 2026-06-01 10:47 JST

### Action

Squash merged PR #35 to `dev`, closed Issue #34, and set the GitHub Project item to Done.

### Reason

PR #35 passed GitHub Actions `validate`, met the SBI acceptance criteria, and preserved the Presentation/ViewModel architecture boundary.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/LargeBoardView.swift`
- `Features/OperationBoard/Presentation/SessionSettingsSection.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh pr checks 35 --watch --interval 10`
- `gh pr merge 35 --squash --delete-branch ...`
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `gh project item-edit ...` for Issue #34 Done and Validation Passed

### GitHub Project Updates

Issue #34 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #35.

### Architecture Decision

No new decision. The merged increment keeps session settings in Presentation/ViewModel and does not introduce direct Infrastructure usage from SwiftUI.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining UX risk is whether a blank first session needs more onboarding, tracked as a future product refinement concern.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are richer snapshot/undo history or participant editing details.

## 2026-06-01 10:50 JST

### Action

Created Issue #36 for participant skill level editing, added it to GitHub Project, and selected it for implementation.

### Reason

The MVP requires level-aware matching, but organizers could not manually set levels from the current participant list.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- GitHub connector create issue
- `gh project item-add ...`
- `gh project item-edit ...`
- `git switch -c codex/sbi-36-participant-skill-editing`

### GitHub Project Updates

Issue #36 added as SBI, Priority P0, Role Owner `swift-developer`, Parent PBI #16, Validation Status `Not Run`, and moved to In Progress.

### Architecture Decision

Keep the slice in Presentation/ViewModel. Participant level edits mutate Domain `Participant` values and use the existing `SessionRepository` save path.

### Validation

No source validation required for issue creation.

### Risk

Medium. The UI needs to stay compact while adding another per-participant control.

### Follow-up

Implement participant skill level menu, ViewModel autosave method, tests, validation, PR, and Project evidence sync.

## 2026-06-01 10:54 JST

### Action

Implemented SBI #36: participant skill level menu, ViewModel skill update/autosave method, and test coverage.

### Reason

Level balancing only becomes useful when the organizer can adjust participant levels at the venue.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #36 remains In Progress until PR evidence is available.

### Architecture Decision

No new protocol or infrastructure change. SwiftUI calls ViewModel, ViewModel mutates Domain values and autosaves via the existing repository boundary.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 22 app tests with 0 lint violations.

### Risk

Low to medium. Extra participant-row control may need later UI tuning, but it is compact and accessibility-labeled.

### Follow-up

Commit, open PR for Issue #36, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 10:56 JST

### Action

Pushed `codex/sbi-36-participant-skill-editing`, opened PR #37 for Issue #36, and moved the GitHub Project item to In Review.

### Reason

SBI #36 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-36-participant-skill-editing`
- GitHub connector create PR
- `gh project item-edit ...` for Issue #36 In Review, Validation Passed, and Evidence Link

### GitHub Project Updates

Issue #36 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #37.

### Architecture Decision

No new decision. The PR keeps participant skill edits in Presentation/ViewModel and uses existing Domain values.

### Validation

PR #37 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. Participant row has multiple menus; later participant detail editing can reduce row density.

### Follow-up

Wait for PR #37 CI, squash merge to `dev` if it passes, then set Issue #36 and Project item Done.

## 2026-06-01 11:04 JST

### Action

Squash merged PR #37 to `dev`, closed Issue #36, and set the GitHub Project item to Done.

### Reason

PR #37 passed GitHub Actions `validate`, met the SBI acceptance criteria, and preserved the Presentation/ViewModel architecture boundary.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh pr checks 37 --watch --interval 10`
- `gh pr merge 37 --squash --delete-branch ...`
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`
- `gh project item-edit ...` for Issue #36 Done and Validation Passed

### GitHub Project Updates

Issue #36 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #37.

### Architecture Decision

No new decision. The merged increment keeps participant skill edits in Presentation/ViewModel and does not introduce direct Infrastructure usage from SwiftUI.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining UX risk is participant row density, tracked as a future refinement concern.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are richer snapshot/undo history or participant detail editing.

## 2026-06-01 11:15 JST

### Action

Created and implemented Issue #38 for participant gender, age group, and memo editing.

### Reason

The MVP requires organizers to capture optional participant context during day-of operations without external notes. Gender, age group, and memo also prepare the model for later rule weights such as mixed priority and beginner protection while keeping the current change small.

### Files Changed

- `Features/OperationBoard/Presentation/ParticipantDetailEditorView.swift`
- `Features/OperationBoard/Presentation/ParticipantListSection.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardParticipantEditingTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #38 was added to Project `kanban@pickle_ball_matching` and set to In Progress with Role Owner `swift-developer`, Backlog Level `SBI`, Priority `P1`, Parent PBI `#16 当日運営特化ダブルス組み合わせMVP`, and Validation Status `Not Run`.

### Architecture Decision

No new infrastructure or persistence boundary was added. SwiftUI uses `ParticipantDetailEditorView`, the participant list is split into `ParticipantListSection`, and `OperationBoardViewModel` mutates Domain `Participant` fields before autosaving through the existing `SessionRepository` boundary.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 24 app tests with 0 lint violations.

### Risk

Medium. The profile fields are editable and persisted, but the generation algorithm does not yet use gender or age group. This is acceptable for the SBI because the immediate user value is on-site participant context capture.

### Follow-up

Commit, open PR for Issue #38, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 11:17 JST

### Action

Pushed `codex/sbi-38-participant-details`, opened PR #39 for Issue #38, and moved the GitHub Project item to In Review.

### Reason

SBI #38 passed local validation and now needs CI-backed review evidence before autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-38-participant-details`
- `gh pr create ...`
- `gh issue edit 38 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #38 In Review, Validation Passed, and Evidence Link

### GitHub Project Updates

Issue #38 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #39.

### Architecture Decision

No new decision. The PR keeps participant detail editing in Presentation/ViewModel and uses existing Domain/Persistence boundaries.

### Validation

PR #39 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The UI adds another participant edit path; CI and review focus on keeping the row readable and maintaining accessibility labels.

### Follow-up

Wait for PR #39 CI, squash merge to `dev` if it passes, then set Issue #38 and Project item Done.

## 2026-06-01 11:26 JST

### Action

Squash merged PR #39 to `dev`, closed Issue #38, and set the GitHub Project item to Done.

### Reason

PR #39 passed GitHub Actions `validate`, met the SBI acceptance criteria, and preserved the Presentation/ViewModel architecture boundary.

### Files Changed

- `Features/OperationBoard/Presentation/ParticipantDetailEditorView.swift`
- `Features/OperationBoard/Presentation/ParticipantListSection.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardParticipantEditingTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh pr checks 39 --watch --interval 10`
- `gh pr merge 39 --squash --delete-branch ...`
- `gh issue edit 38 --remove-label status:in-review --add-label status:done`
- `gh issue comment 38 ...`
- `gh issue close 38 --reason completed`
- `gh project item-edit ...` for Issue #38 Done and Validation Passed
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #38 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #39.

### Architecture Decision

No new decision. The merged increment keeps participant detail editing in Presentation/ViewModel and does not introduce direct Infrastructure usage from SwiftUI.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining UX risk is participant row density and edit discoverability, tracked as future refinement if needed.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are richer snapshot/undo history or roster reuse.

## 2026-06-01 11:40 JST

### Action

Created and implemented Issue #40 for starting a new session while keeping the saved roster.

### Reason

Recurring circles should not re-enter the same participant list every session. This SBI directly reduces setup time and advances the 3-minute north star without introducing a full roster management screen yet.

### Files Changed

- `Features/OperationBoard/Presentation/SessionSettingsSection.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardSessionReuseTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh issue create ...`
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/40`
- `gh project item-edit ...` for Issue #40 In Progress metadata
- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #40 was added to Project `kanban@pickle_ball_matching` and set to In Progress with Role Owner `swift-developer`, Backlog Level `SBI`, Priority `P1`, Parent PBI `#17 ローカルファースト保存・復元`, and Validation Status `Not Run`.

### Architecture Decision

No new repository or persistence type was introduced. The first roster reuse increment keeps the behavior in `OperationBoardViewModel`, reuses the existing `SessionRepository` autosave boundary, and leaves multi-roster management for a later SBI.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 25 app tests with 0 lint violations.

### Risk

Medium. This keeps one saved roster path only and does not yet support multiple named rosters. That is acceptable for MVP because it removes the repeated-input pain with a reversible UI change.

### Follow-up

Commit, open PR for Issue #40, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 11:42 JST

### Action

Pushed `codex/sbi-40-roster-reuse`, opened PR #41 for Issue #40, and moved the GitHub Project item to In Review.

### Reason

SBI #40 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-40-roster-reuse`
- `gh pr create ...`
- `gh issue edit 40 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #40 In Review, Validation Passed, and Evidence Link

### GitHub Project Updates

Issue #40 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #41.

### Architecture Decision

No new decision. The PR keeps roster reuse in Presentation/ViewModel and uses existing persistence boundaries.

### Validation

PR #41 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The implementation intentionally handles only a single carried-over roster and leaves multi-roster management for later.

### Follow-up

Wait for PR #41 CI, squash merge to `dev` if it passes, then set Issue #40 and Project item Done.

## 2026-06-01 11:49 JST

### Action

Squash merged PR #41 to `dev`, closed Issue #40, and set the GitHub Project item to Done.

### Reason

PR #41 passed GitHub Actions `validate`, met the SBI acceptance criteria, and preserved the Presentation/ViewModel architecture boundary.

### Files Changed

- `Features/OperationBoard/Presentation/SessionSettingsSection.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardSessionReuseTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh pr checks 41 --watch --interval 10`
- `gh pr merge 41 --squash --delete-branch ...`
- `gh issue edit 40 --remove-label status:in-review --add-label status:done`
- `gh issue comment 40 ...`
- `gh issue close 40 --reason completed`
- `gh project item-edit ...` for Issue #40 Done and Validation Passed
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #40 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #41.

### Architecture Decision

No new decision. The merged increment keeps roster reuse in Presentation/ViewModel and does not introduce a separate repository before multiple roster use cases exist.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining product scope risk is lack of multiple saved rosters, which should be addressed only after the single-roster MVP flow proves useful.

### Follow-up

Select the next MVP SBI from Project/Sprint Backlog. Good candidates are richer snapshot/undo history or PDF/image export.

## 2026-06-01 12:02 JST

### Action

Created and implemented Issue #42 for swapping any participant within the current round.

### Reason

The MVP promises that organizers can manually correct generated pairings. The app already supported swapping a playing participant with a waiter; this increment removes the next obvious limitation by allowing swaps with other playing participants too.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardManualSwapTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh issue create ...`
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/42`
- `gh project item-edit ...` for Issue #42 In Progress metadata
- `swiftformat --cache ignore .`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #42 was added to Project `kanban@pickle_ball_matching` and set to In Progress with Role Owner `swift-developer`, Backlog Level `SBI`, Priority `P1`, Parent PBI `#16 当日運営特化ダブルス組み合わせMVP`, and Validation Status `Not Run`.

### Architecture Decision

No new infrastructure or persistence boundary was added. Manual swapping remains in Presentation/ViewModel, and the existing `SessionRepository` autosave boundary is reused.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 27 app tests with 0 lint violations.

### Risk

Medium. The menu now lists all current-round participants, so future UX may need a dedicated manual-edit screen for dense events.

### Follow-up

Commit, open PR for Issue #42, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 12:04 JST

### Action

Pushed `codex/sbi-42-round-player-swap`, opened PR #43 for Issue #42, and moved the GitHub Project item to In Review.

### Reason

SBI #42 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-42-round-player-swap`
- `gh pr create ...`
- `gh issue edit 42 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #42 In Review, Validation Passed, and Evidence Link

### GitHub Project Updates

Issue #42 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #43.

### Architecture Decision

No new decision. The PR keeps manual swap behavior in Presentation/ViewModel and uses existing persistence boundaries.

### Validation

PR #43 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The current menu-based UI is still acceptable for MVP but may need a dedicated editor once court/player counts grow.

### Follow-up

Wait for PR #43 CI, squash merge to `dev` if it passes, then set Issue #42 and Project item Done.

## 2026-06-01 12:10 JST

### Action

Added a GitHub REST push fallback runbook and script.

### Reason

The autonomous loop needs a documented fallback when normal `git push` fails due to Git transport, credential, or branch ref update issues. The fallback must remain narrow and auditable.

### Files Changed

- `scripts/codex/push-via-github-api.sh`
- `docs/codex/continuous-runbook.md`
- `docs/codex/github-projects-policy.md`

### Commands Run

- `chmod +x scripts/codex/push-via-github-api.sh`

### GitHub Project Updates

No Project item change required. This is operational tooling for the active autonomous loop.

### Architecture Decision

REST fallback is limited to fast-forward GitHub ref updates for `codex/*` branches. `main`, force updates, production/App Store/secret paths, and Codex usage-limit/policy-rejection workarounds remain prohibited.

### Validation

Pending local script dry-run and shell syntax check.

### Risk

Medium. Direct ref updates can bypass normal Git transport, so the script verifies branch naming, target SHA, and `force=false`.

### Follow-up

Run dry-run validation, commit the fallback tooling, and push with normal `git push` first. Use REST fallback only if the normal push path fails for allowed reasons.

## 2026-06-01 14:19 JST

### Action

Squash merged PR #43 to `dev`, closed Issue #42, and set the GitHub Project item to Done.

### Reason

Issue #42 passed local validation and GitHub Actions. The manual-edit MVP increment was complete enough to merge without human approval under the autonomous run policy.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh pr checks 43 --watch --interval 10`
- `gh pr merge 43 --squash --delete-branch ...`
- `gh issue edit 42 --remove-label status:in-review --add-label status:done`
- `gh issue comment 42 ...`
- `gh issue close 42 --reason completed`
- `gh project item-edit ...` for Issue #42 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #42 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #43. The issue is closed.

### Architecture Decision

No new product architecture decision. The REST push fallback added in PR #43 is operational tooling only and is limited to non-main `codex/*` branch ref updates with `force=false`.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` passed before PR creation with 10 core tests, 27 app tests, and 0 lint violations.

### Risk

Low after merge. Normal `git push` succeeded for PR #43, so the REST fallback was not used; it remains a documented contingency.

### Follow-up

Create/select SBI-017 for richer snapshot/undo history and continue the autonomous loop.

## 2026-06-01 14:30 JST

### Action

Created and implemented Issue #44 for multi-step undo history.

### Reason

The product vision treats Snapshot/Undo as a core on-site safety feature. After PR #43 enabled arbitrary current-round swaps, the next reversible vertical slice was to let organizers undo multiple manual corrections one by one.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/LargeBoardDisplayModel.swift`
- `Tests/PickleBallMatchingTests/OperationBoardManualSwapTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh issue create ...` for Issue #44
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/44`
- `gh project item-edit ...` for Issue #44 In Progress metadata
- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #44 was added to Project `kanban@pickle_ball_matching` and set to Status `In progress`, Scrum Status `In Progress`, Backlog Level `SBI`, Priority `P1`, Role Owner `swift-developer`, Risk `medium`, Area `UI`, Parent PBI `#16 当日運営特化ダブルス組み合わせMVP`, and Validation Status `Passed`.

### Architecture Decision

Multi-step undo is implemented as a bounded in-memory stack in `OperationBoardViewModel`. It remains a Presentation concern for manual corrections and does not add Infrastructure or persistence coupling. New session starts, roster reuse starts, non-manual session edits, participant edits, and round generation clear the undo history to avoid reverting unrelated state.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 10 core tests and 29 app tests with 0 lint violations.

### Risk

Medium. Undo history is intentionally not persisted yet, so it protects the active session runtime but does not survive app relaunch. Persistent operation history remains a follow-up SBI.

### Follow-up

Commit, open PR for Issue #44, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 14:31 JST

### Action

Pushed `codex/sbi-44-multi-undo`, opened PR #45 for Issue #44, and moved the GitHub Project item to In Review.

### Reason

SBI #44 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-44-multi-undo`
- `gh pr create ...`
- `gh issue edit 44 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #44 In Review and Evidence Link

### GitHub Project Updates

Issue #44 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #45.

### Architecture Decision

No new decision. The PR keeps undo history in Presentation/ViewModel and does not introduce persistent operation history yet.

### Validation

PR #45 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. Runtime-only undo history is acceptable for the MVP slice; persistent history remains a follow-up.

### Follow-up

Wait for PR #45 CI, squash merge to `dev` if it passes, then set Issue #44 and Project item Done.

## 2026-06-01 14:41 JST

### Action

Squash merged PR #45 to `dev`, closed Issue #44, and set the GitHub Project item to Done.

### Reason

Issue #44 passed local validation and GitHub Actions. The multi-step undo MVP increment was complete enough to merge without human approval under the autonomous run policy.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh pr checks 45 --watch --interval 10`
- `gh pr merge 45 --squash --delete-branch ...`
- `gh issue edit 44 --remove-label status:in-review --add-label status:done`
- `gh issue comment 44 ...`
- `gh issue close 44 --reason completed`
- `gh project item-edit ...` for Issue #44 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #44 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #45. The issue is closed.

### Architecture Decision

No new decision after PR merge. Runtime-only multi-step undo remains a Presentation/ViewModel concern. Persistent operation history is still intentionally deferred.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining undo risk is that history is not persisted across relaunch, which is documented as a follow-up.

### Follow-up

Select the next MVP SBI, with PDF/image export or board usability as likely candidates.

## 2026-06-01 15:42 JST

### Action

Created and implemented Issue #46 for current-round PDF sharing.

### Reason

MVP sharing already had CSV, but the product vision asks for PNG, PDF, CSV, or a share image. PDF is a useful local-first export because organizers can share, AirDrop, print, or project it without server work.

### Files Changed

- `Sources/PickleBallMatchingCore/Application/RoundPDFExporting.swift`
- `Sources/PickleBallMatchingCore/Infrastructure/PDFRoundExporter.swift`
- `Features/OperationBoard/Presentation/RoundPDFDocument.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `App/CompositionRoot/DependencyContainer.swift`
- `Tests/PickleBallMatchingCoreTests/PDFRoundExporterTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh issue create ...` for Issue #46
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/46`
- `gh project item-edit ...` for Issue #46 In Progress metadata
- `swiftformat --cache ignore .`
- `swift test`
- `xcodebuild build -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16' IDEPackageSupportUseBuiltinSCM=YES | xcbeautify`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #46 was added to Project `kanban@pickle_ball_matching` and set to Status `In progress`, Scrum Status `In Progress`, Backlog Level `SBI`, Priority `P2`, Role Owner `swift-developer`, Risk `medium`, Area `Infrastructure`, Parent PBI `#19 共有・エクスポート`, Architecture Impact, and Validation Status `Passed`.

### Architecture Decision

PDF generation is an Infrastructure adapter behind the new Application protocol `RoundPDFExporting`. Presentation receives PDF bytes through `OperationBoardViewModel` and shares them via a `Transferable` wrapper. This keeps SwiftUI away from PDF drawing details.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 12 core tests and 31 app tests with 0 lint violations.

### Risk

Medium. The PDF layout is intentionally simple and local-first. Richer visual design, image export, and multi-round PDFs should be follow-up SBIs.

### Follow-up

Commit, open PR for Issue #46, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 15:43 JST

### Action

Pushed `codex/sbi-46-pdf-export`, opened PR #47 for Issue #46, and moved the GitHub Project item to In Review.

### Reason

SBI #46 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-46-pdf-export`
- `gh pr create ...`
- `gh issue edit 46 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #46 In Review and Evidence Link

### GitHub Project Updates

Issue #46 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #47.

### Architecture Decision

No new decision. The PR keeps PDF generation behind `RoundPDFExporting` and `PDFRoundExporter`.

### Validation

PR #47 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The PDF is useful but visually basic; image export and PDF polish remain follow-ups.

### Follow-up

Wait for PR #47 CI, squash merge to `dev` if it passes, then set Issue #46 and Project item Done.

## 2026-06-01 18:34 JST

### Action

Merged PR #47, closed Issue #46, and set the GitHub Project item to Done.

### Reason

Issue #46 passed local validation and GitHub Actions. The PDF sharing increment satisfies a local-first MVP export path without requiring server, CloudKit, App Store, TestFlight, billing, or secrets.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/next-work-search.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh pr view 47 --json ...`
- `gh issue edit 46 --remove-label status:in-review --add-label status:done`
- `gh issue comment 46 ...`
- `gh issue close 46 --reason completed`
- `gh project item-edit ...` for Issue #46 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #46 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #47. The issue is closed.

### Architecture Decision

No new decision after merge. PDF generation remains an Infrastructure adapter behind `RoundPDFExporting`, and SwiftUI only receives a `Transferable` document.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining export risk is visual polish and image export coverage, which are better handled as separate small SBIs.

### Follow-up

Select the next MVP SBI. The current highest-value candidate is sharing the current round as a participant-friendly image.

## 2026-06-01 18:49 JST

### Action

Created and implemented Issue #48 for current-round PNG image sharing.

### Reason

The MVP export requirement includes image/PDF/CSV. CSV and PDF now exist, but a participant-readable image is the most convenient format for LINE, AirDrop, photos, and quick projection at a venue.

### Files Changed

- `Sources/PickleBallMatchingCore/Application/RoundImageExporting.swift`
- `Sources/PickleBallMatchingCore/Infrastructure/ImageRoundExporter.swift`
- `Features/OperationBoard/Presentation/RoundImageDocument.swift`
- `Features/OperationBoard/Presentation/RoundParticipantSwap.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `App/CompositionRoot/DependencyContainer.swift`
- `Tests/PickleBallMatchingCoreTests/ImageRoundExporterTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh issue create ...` for Issue #48
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/48`
- `gh project item-edit ...` for Issue #48 In Progress metadata
- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #48 was added to Project `kanban@pickle_ball_matching` and set to Status `In progress`, Scrum Status `In Progress`, Backlog Level `SBI`, Priority `P2`, Role Owner `swift-developer`, Risk `medium`, Area `UI`, Parent PBI `#19 共有・エクスポート`, Architecture Impact, and Validation Status `Passed`.

### Architecture Decision

PNG generation is an Infrastructure adapter behind the new Application protocol `RoundImageExporting`. Presentation shares a `RoundImageDocument` `Transferable`, keeping SwiftUI away from CoreGraphics/ImageIO rendering details. Manual-swap helper logic was split into `RoundParticipantSwap.swift` to keep the ViewModel under SwiftLint file-length limits.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 14 core tests and 33 app tests with 0 lint violations.

### Risk

Medium. The generated image is intentionally simple and readable. Visual polish, multiple layouts, and multi-round image exports remain follow-up SBIs.

### Follow-up

Commit, open PR for Issue #48, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 18:51 JST

### Action

Pushed `codex/sbi-48-image-export`, opened PR #49 for Issue #48, and moved the GitHub Project item to In Review.

### Reason

SBI #48 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-48-image-export`
- `gh pr create ...`
- `gh issue edit 48 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #48 In Review and Evidence Link

### GitHub Project Updates

Issue #48 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #49.

### Architecture Decision

No new decision. The PR keeps PNG generation behind `RoundImageExporting` and `ImageRoundExporter`.

### Validation

PR #49 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The share image is useful but visually basic; richer image layouts should remain follow-up SBIs.

### Follow-up

Wait for PR #49 CI, squash merge to `dev` if it passes, then set Issue #48 and Project item Done.

## 2026-06-01 19:05 JST

### Action

Merged PR #49, closed Issue #48, and set the GitHub Project item to Done.

### Reason

Issue #48 passed local validation and GitHub Actions. The PNG image sharing increment satisfies the MVP image export path while preserving local-first operation and avoiding server, CloudKit, App Store, billing, and secrets.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/next-work-search.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh pr checks 49 --watch --interval 10`
- `gh run view 26747878506 --json ...`
- `gh pr merge 49 --squash --delete-branch ...`
- `gh issue edit 48 --remove-label status:in-review --add-label status:done`
- `gh issue comment 48 ...`
- `gh issue close 48 --reason completed`
- `gh project item-edit ...` for Issue #48 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #48 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #49. The issue is closed.

### Architecture Decision

No new decision after merge. PNG generation remains an Infrastructure adapter behind `RoundImageExporting`, and SwiftUI only receives a `Transferable` document.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Remaining export risk is visual polish and additional image layouts, which are follow-up SBIs.

### Follow-up

Select the next MVP SBI. The current highest-value candidate is a local session history/reopen flow.

## 2026-06-01 19:19 JST

### Action

Created and implemented Issue #50 for reopening saved sessions from local history.

### Reason

The app could auto-restore the latest session, but recurring circles need to choose from multiple saved sessions. This advances the local-first save/restore PBI without adding CloudKit, server sync, App Store, billing, or secrets.

### Files Changed

- `Sources/PickleBallMatchingCore/Application/SessionRepository.swift`
- `Sources/PickleBallMatchingCore/Infrastructure/JSONSessionRepository.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/SessionSettingsSection.swift`
- `Tests/PickleBallMatchingCoreTests/JSONSessionRepositoryTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardSessionHistoryTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Scrum/Codex ledger docs

### Commands Run

- `gh issue create ...` for Issue #50
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/50`
- `gh project item-edit ...` for Issue #50 In Progress metadata
- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #50 was added to Project `kanban@pickle_ball_matching` and set to Status `In progress`, Scrum Status `In Progress`, Backlog Level `SBI`, Priority `P1`, Role Owner `swift-developer`, Risk `medium`, Area `Infrastructure`, Parent PBI `#17 ローカルファースト保存・復元`, Architecture Impact, and Validation Status `Passed`.

### Architecture Decision

`SessionRepository` now exposes `loadSavedSessions()` with a default latest-session fallback. `JSONSessionRepository` persists both `latest-session.json` and ID-addressed history files under `sessions/`. Presentation reopens history through `OperationBoardViewModel`, preserving the repository boundary.

### Validation

Full validation passed: `swift test`, SwiftLint, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 15 core tests and 35 app tests with 0 lint violations.

### Risk

Medium. The history UI is intentionally compact inside the session settings section. Delete/search/full history screens should be follow-up SBIs.

### Follow-up

Commit, open PR for Issue #50, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 19:20 JST

### Action

Pushed `codex/sbi-50-session-history`, opened PR #51 for Issue #50, and moved the GitHub Project item to In Review.

### Reason

SBI #50 passed local validation and is ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-50-session-history`
- `gh pr create ...`
- `gh issue edit 50 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #50 In Review and Evidence Link

### GitHub Project Updates

Issue #50 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #51.

### Architecture Decision

No new decision. The PR keeps session history behind `SessionRepository` and `JSONSessionRepository`.

### Validation

PR #51 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. The history list is compact and delete/search are deferred.

### Follow-up

Wait for PR #51 CI, squash merge to `dev` if it passes, then set Issue #50 and Project item Done.

## 2026-06-01 19:32 JST

### Action

Merged PR #51, closed Issue #50, and set the GitHub Project item to Done.

### Reason

Issue #50 passed local validation and GitHub Actions. The session history/reopen increment strengthens local-first recurring use without requiring CloudKit, server sync, App Store, billing, or secrets.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/next-work-search.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh pr checks 51 --watch --interval 10`
- `gh run view 26749158598 --json ...`
- `gh pr merge 51 --squash --delete-branch ...`
- `gh issue edit 50 --remove-label status:in-review --add-label status:done`
- `gh issue comment 50 ...`
- `gh issue close 50 --reason completed`
- `gh project item-edit ...` for Issue #50 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #50 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #51. The issue is closed.

### Architecture Decision

No new decision after merge. Session history remains behind `SessionRepository` and `JSONSessionRepository`.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. Deleting/searching session history remains a separate follow-up because deletion is more destructive than reopen.

### Follow-up

Select the next MVP SBI. The current safest candidate is board usability/readability polish.

## 2026-06-01 22:26 JST

### Action

Created Issue #52, added it to GitHub Project `kanban@pickle_ball_matching`, selected it as the next SBI, implemented board current-state and next-action guidance, and ran full local validation.

### Reason

After session history/reopen, the safest high-value next work was a non-destructive Presentation improvement: helping organizers see whether they need to add participants, generate the first round, adjust the current round, or proceed to the next round.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardSummaryModel.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Tests/PickleBallMatchingTests/OperationBoardSummaryModelTests.swift`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/next-work-search.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh issue create ...`
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/52`
- `gh project item-edit ...` for Issue #52 In Progress and Validation Passed
- `gh issue edit 52 --remove-label status:ready --add-label status:in-progress`
- `git switch -c codex/sbi-52-board-guidance`
- `swiftformat --cache ignore .`
- `swiftlint --no-cache`
- `swift test`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #52 was added to Project `kanban@pickle_ball_matching` and set to Status `In progress`, Scrum Status `In Progress`, Backlog Level `SBI`, Priority `P1`, Role Owner `swift-developer`, Risk `medium`, Area `UI`, Parent PBI `#18 進行ボードと大画面表示`, Architecture Impact, and Validation Status `Passed`.

### Architecture Decision

The change is Presentation-only. `OperationBoardSummaryModel` and a ViewModel computed property derive display text from existing `Session` and `Round` state without adding Domain/Application/Infrastructure dependencies.

### Validation

Full validation passed: `swift test`, SwiftLint with 0 violations, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator. The Xcode test suite passed 15 core tests and 38 app tests.

### Risk

Medium. The added summary could crowd the board on small iPhone screens, but it is text-based, accessible, and reversible. Human review should check screen density after PR merge.

### Follow-up

Commit, open PR for Issue #52, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 22:28 JST

### Action

Pushed `codex/sbi-52-board-guidance`, opened PR #53 for Issue #52, and moved the GitHub Project item to In Review with PR evidence.

### Reason

The local implementation passed validation and was ready for CI-backed review and autonomous merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/sbi-52-board-guidance`
- `gh pr create ...`
- `gh issue edit 52 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #52 In Review and Evidence Link

### GitHub Project Updates

Issue #52 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #53.

### Architecture Decision

No new decision. The PR remains Presentation-only.

### Validation

PR #53 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Medium. Screen density should be checked after merge.

### Follow-up

Wait for PR #53 CI, squash merge to `dev` if it passes, then set Issue #52 and Project item Done.

## 2026-06-01 22:34 JST

### Action

Merged PR #53, closed Issue #52, and set the GitHub Project item to Done.

### Reason

Issue #52 passed local validation and GitHub Actions. The board summary increment improves organizer clarity without changing architecture boundaries.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh run watch 26758066914 --interval 10`
- `gh pr merge 53 --squash --delete-branch ...`
- `gh issue edit 52 --remove-label status:in-review --add-label status:done`
- `gh issue comment 52 ...`
- `gh issue close 52 --reason completed`
- `gh project item-edit ...` for Issue #52 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #52 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #53. The issue is closed.

### Architecture Decision

No new decision after merge. The board summary remains Presentation-only.

### Validation

GitHub Actions `validate` passed before merge. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge. CI emitted a Node.js 20 deprecation annotation for `actions/checkout@v4`; this is a follow-up environment chore candidate, not a blocker for PR #53.

### Follow-up

Select the next MVP or environment SBI. The strongest immediate candidate is resolving the GitHub Actions Node 20 deprecation warning.

## 2026-06-01 22:48 JST

### Action

Created Issue #54, added it to GitHub Project `kanban@pickle_ball_matching`, selected it as the next environment Chore, updated `actions/checkout` from v4 to v6, and ran full local validation.

### Reason

PR #53 CI passed but emitted a Node.js 20 deprecation annotation for `actions/checkout@v4`. Keeping CI warning-free protects the autonomous development loop before runner defaults change.

### Files Changed

- `.github/workflows/ios-validation.yml`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh api repos/actions/checkout/releases/latest --jq ...`
- `gh api repos/actions/checkout/git/ref/tags/v6 --jq ...`
- `gh api repos/actions/checkout/releases/tags/v6.0.0 --jq ...`
- `gh issue create ...`
- `gh project item-add 3 --owner ka-bo-su --url https://github.com/ka-bo-su/pickle_ball_matching/issues/54`
- `gh project item-edit ...` for Issue #54 In Progress and Validation Passed
- `gh issue edit 54 --remove-label status:ready --add-label status:in-progress`
- `git switch -c codex/chore-54-actions-node24`
- `scripts/codex/validate-ios.sh`

### GitHub Project Updates

Issue #54 was added to Project `kanban@pickle_ball_matching` and set to Status `In progress`, Scrum Status `In Progress`, Backlog Level `Chore`, Priority `P1`, Role Owner `swift-developer`, Risk `low`, Area `Infrastructure`, Architecture Impact, and Validation Status `Passed`.

One initial Role Owner field update used the option name instead of option id and failed with a GraphQL option mismatch. It was immediately retried with option id `abd38c90` and succeeded.

### Architecture Decision

No app architecture change. This is CI infrastructure only. GitHub API confirmed `actions/checkout` latest release `v6.0.2`, the `v6` major tag exists, and the v6.0.0 release notes mention Node.js 24 support details.

### Validation

Full local validation passed: `swift test`, SwiftLint with 0 violations, SwiftFormat lint, XcodeGen, `xcodebuild build`, and `xcodebuild test` on iPhone 16 Simulator.

### Risk

Low. The only runtime change is GitHub Actions checkout behavior in CI. PR CI will validate the workflow update.

### Follow-up

Commit, open PR for Issue #54, update Project evidence to In Review, and merge to `dev` if CI passes.

## 2026-06-01 22:50 JST

### Action

Pushed `codex/chore-54-actions-node24`, opened PR #55 for Issue #54, and moved the GitHub Project item to In Review with PR evidence.

### Reason

The local workflow update passed validation and is ready for GitHub Actions to verify the checkout version change in CI.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git push -u origin codex/chore-54-actions-node24`
- `gh pr create ...`
- `gh issue edit 54 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Issue #54 In Review and Evidence Link

### GitHub Project Updates

Issue #54 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link PR #55.

### Architecture Decision

No app architecture impact.

### Validation

PR #55 will run GitHub Actions. Local validation already passed before PR creation.

### Risk

Low. If `actions/checkout@v6` has unexpected runner compatibility issues, PR CI will fail before merge.

### Follow-up

Wait for PR #55 CI, squash merge to `dev` if it passes, then set Issue #54 and Project item Done.

## 2026-06-01 23:00 JST

### Action

Merged PR #55, closed Issue #54, and set the GitHub Project item to Done.

### Reason

Issue #54 passed local validation and GitHub Actions. The checkout action now uses `actions/checkout@v6`; PR #55 did not emit the prior Node.js 20 deprecation annotation.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `gh run watch 26759202053 --interval 10`
- `gh pr merge 55 --squash --delete-branch ...`
- `gh issue edit 54 --remove-label status:in-review --add-label status:done`
- `gh issue comment 54 ...`
- `gh issue close 54 --reason completed`
- `gh project item-edit ...` for Issue #54 Done
- `git fetch origin`
- `git switch dev`
- `git merge --ff-only origin/dev`

### GitHub Project Updates

Issue #54 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #55. The issue is closed.

### Architecture Decision

No app architecture change. CI infrastructure now uses `actions/checkout@v6`.

### Validation

GitHub Actions `validate` passed before merge and did not report the Node.js 20 deprecation annotation. Local `scripts/codex/validate-ios.sh` also passed before PR creation.

### Risk

Low after merge.

### Follow-up

Select the next MVP SBI. The strongest candidate is progress-board start and remaining-time flow.

## 2026-06-01 23:19 JST

### Action

Implemented the local Issue #56 round timer slice on `codex/sbi-56-round-timer` and recorded the validation/publish blocker.

### Reason

The MVP progress board needs explicit match start, remaining-time display, and round finish controls so organizers can run an active session without external timers or verbal coordination.

### Files Changed

- `Sources/PickleBallMatchingCore/Domain/Round.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/OperationBoardExports.swift`
- `Features/OperationBoard/Presentation/OperationBoardRoundTimingActions.swift`
- `Features/OperationBoard/Presentation/OperationBoardRoundTimingModel.swift`
- `Features/OperationBoard/Presentation/RoundTimingSection.swift`
- `Tests/PickleBallMatchingCoreTests/RoundTimingTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardRoundTimingTests.swift`
- Codex/Scrum status docs

### Commands Run

- `swiftformat --cache ignore .` (blocked by Codex execution usage limit)
- `swiftlint --no-cache` (blocked by Codex execution usage limit)
- `swift test` (blocked by SwiftPM/Xcode sandbox restrictions in non-escalated execution)
- `git push -u origin codex/sbi-56-round-timer` (blocked by Codex execution usage limit)

### GitHub Project Updates

Issue #56 is already In Progress in Project `kanban@pickle_ball_matching`. PR evidence, Validation Status `Passed`, and In Review transition are pending in `docs/codex/github-projects-pending-updates.md`.

### Architecture Decision

Round timing is modeled in Domain as optional `startedAt` / `finishedAt` timestamps and derived `RoundStatus`. Presentation owns timer display and start/end commands through ViewModel methods; Infrastructure remains unchanged.

### Validation

Not completed in this execution window. Prior full validation for `dev` remains PR #55 / GitHub Actions at 2026-06-01 22:59 JST.

### Risk

Medium until validation runs. Code changes are localized and reversible, but the branch must pass SwiftFormat, SwiftLint, SwiftPM tests, XcodeGen, and xcodebuild before PR creation.

### Follow-up

After execution quota resets, rerun `scripts/codex/validate-ios.sh`, push `codex/sbi-56-round-timer`, open the Issue #56 PR, update Project evidence, and merge only after CI passes. REST push was not attempted because the normal push was explicitly rejected by the execution approval layer.

## 2026-06-02 08:00 JST

### Action

Resolved the Issue #56 execution blocker by running full local iOS validation and updating Project Validation Status to `Passed`.

### Reason

The previous blocker was caused by Codex execution quota and sandbox restrictions, not by known code failure. Once execution resumed, the branch needed full verification before push and PR creation.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/blockers.md`
- `docs/codex/github-projects-pending-updates.md`
- `docs/codex/ios-swift-validation.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `scripts/codex/validate-ios.sh`
- `gh project item-edit ... Validation Status Passed`

### GitHub Project Updates

Issue #56 Project item `PVTI_lAHOBHYYMs4BZUKkzguYuXg` was updated to Validation Status `Passed`.

### Architecture Decision

No additional architecture change beyond the Issue #56 round timing boundary already recorded.

### Validation

Passed: `swift test` 19 core tests, SwiftLint 0 violations, SwiftFormat lint 0 files, XcodeGen generation, `xcodebuild build`, and `xcodebuild test` with 19 core tests and 43 app tests.

### Risk

Medium until PR CI passes; local validation is clean.

### Follow-up

Push the branch, open the Issue #56 PR, move Project status to In Review, and watch CI before merge.

## 2026-06-02 08:02 JST

### Action

Pushed `codex/sbi-56-round-timer`, opened PR #57 for Issue #56, and moved the GitHub Project item to In Review with PR evidence.

### Reason

Issue #56 passed local validation and is ready for CI/release-reviewer merge readiness checks.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-pending-updates.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `git push -u origin codex/sbi-56-round-timer`
- `gh pr create --base dev --head codex/sbi-56-round-timer ...`
- `gh issue edit 56 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Status `In review`, Scrum Status `In Review`, and Evidence Link PR #57

### GitHub Project Updates

Issue #56 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/57`.

### Architecture Decision

No additional architecture change. PR #57 preserves Domain/Presentation separation for round timing.

### Validation

Local validation passed before PR creation. GitHub Actions is pending.

### Risk

Medium until PR #57 CI passes.

### Follow-up

Watch PR #57 CI, squash merge to `dev` if it passes, close Issue #56, and set the Project item Done.

## 2026-06-02 08:08 JST

### Action

Merged PR #57, closed Issue #56, and set the GitHub Project item to Done.

### Reason

PR #57 passed local validation and GitHub Actions. The round timer/start-end flow meets the Issue #56 acceptance criteria and is ready as a Done increment on `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr checks 57 --watch --interval 10`
- `gh pr merge 57 --squash --delete-branch ...`
- `gh issue edit 56 --remove-label status:in-review --add-label status:done`
- `gh project item-edit ...` for Status `Done`
- `gh project item-edit ...` for Scrum Status `Done`
- `gh issue comment 56 ...`
- `gh issue close 56 --reason completed`

### GitHub Project Updates

Issue #56 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #57. The issue is closed.

### Architecture Decision

No additional architecture change after PR merge. Round timing remains Domain-derived and Presentation-rendered.

### Validation

GitHub Actions `validate` passed for PR #57 before merge.

### Risk

Low after merge.

### Follow-up

Select the next MVP SBI. Candidate areas are score/result capture, session history cleanup, or further timer visibility polish.

## 2026-06-02 08:14 JST

### Action

Created and selected Issue #58, added it to Project `kanban@pickle_ball_matching`, and implemented repeated-pair avoidance in local round generation.

### Reason

The MVP fairness promise includes reducing repeated pairs. Existing generation handled availability, waiting fairness, and level balance, but did not score teammate history.

### Files Changed

- `Sources/PickleBallMatchingCore/Application/GenerateNextRoundUseCase.swift`
- `Tests/PickleBallMatchingCoreTests/GenerateNextRoundUseCaseTests.swift`
- Codex/Scrum status docs

### Commands Run

- `gh issue create ...`
- `gh project item-add ...`
- `gh project item-edit ...`
- `git switch -c codex/sbi-58-avoid-repeat-pairs`
- `swiftformat --cache ignore .`
- `swift test`

### GitHub Project Updates

Issue #58 added to Project as SBI, Status `In progress`, Scrum Status `In Progress`, Priority `P0`, Role Owner `swift-developer`, Risk `medium`, Area `Application`, Validation Status `Not Run`, Parent PBI `#16`, and Sprint `Sprint 2026-06 MVP`.

### Architecture Decision

Repeated-pair scoring stays inside `GenerateNextRoundUseCase`. Domain entities remain framework-free and no Infrastructure dependency is added.

### Validation

Partial validation passed: `swift test` with 21 core tests.

### Risk

Medium. Pairing behavior changes, so full iOS validation and CI are required before merge.

### Follow-up

Run `scripts/codex/validate-ios.sh`, commit, push, open PR, and update Project evidence.

## 2026-06-02 08:16 JST

### Action

Ran full local validation for Issue #58 and updated Project Validation Status to `Passed`.

### Reason

The round-generation algorithm changed, so the branch needed full SwiftPM/lint/Xcode validation before commit and PR creation.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `scripts/codex/validate-ios.sh`
- `gh project item-edit ... Validation Status Passed`

### GitHub Project Updates

Issue #58 Project item `PVTI_lAHOBHYYMs4BZUKkzgubhfs` was updated to Validation Status `Passed`.

### Architecture Decision

No additional architecture decision. The pairing-history logic remains inside Application use case code.

### Validation

Passed: `swift test` 21 core tests, SwiftLint 0 violations, SwiftFormat lint 0 files, XcodeGen generation, `xcodebuild build`, and `xcodebuild test` with 21 core tests and 43 app tests.

### Risk

Medium until PR CI passes.

### Follow-up

Commit, push, open PR, and move Issue #58 to In Review with PR evidence.

## 2026-06-02 08:17 JST

### Action

Pushed `codex/sbi-58-avoid-repeat-pairs`, opened PR #59 for Issue #58, and moved the Project item to In Review with PR evidence.

### Reason

Issue #58 passed full local validation and is ready for GitHub Actions and merge readiness checks.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `git push -u origin codex/sbi-58-avoid-repeat-pairs`
- `gh pr create --base dev --head codex/sbi-58-avoid-repeat-pairs ...`
- `gh issue edit 58 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Status `In review`, Scrum Status `In Review`, and Evidence Link PR #59

### GitHub Project Updates

Issue #58 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/59`.

### Architecture Decision

No additional architecture change beyond the Application-layer pairing-history scoring.

### Validation

Local validation passed before PR creation. GitHub Actions is pending.

### Risk

Medium until PR #59 CI passes.

### Follow-up

Watch PR #59 CI, squash merge to `dev` if it passes, close Issue #58, and set the Project item Done.

## 2026-06-02 08:22 JST

### Action

Merged PR #59, closed Issue #58, and set the GitHub Project item to Done.

### Reason

PR #59 passed local validation and GitHub Actions. Repeated-pair avoidance meets the Issue #58 acceptance criteria and is ready as a Done increment on `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr checks 59 --watch --interval 10`
- `gh pr merge 59 --squash --delete-branch ...`
- `gh issue edit 58 --remove-label status:in-review --add-label status:done`
- `gh project item-edit ...` for Status `Done`
- `gh project item-edit ...` for Scrum Status `Done`
- `gh issue comment 58 ...`
- `gh issue close 58 --reason completed`

### GitHub Project Updates

Issue #58 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #59. The issue is closed.

### Architecture Decision

No additional architecture change after PR merge. Pairing-history scoring remains in Application and does not introduce UI or Infrastructure dependencies.

### Validation

GitHub Actions `validate` passed for PR #59 before merge.

### Risk

Low after merge.

### Follow-up

Select the next MVP SBI. Candidate areas are same-opponent avoidance, score/result capture, or rule setting UI.

## 2026-06-02 08:29 JST

### Action

Created and selected Issue #60, added it to Project `kanban@pickle_ball_matching`, implemented repeated-opponent avoidance, and completed full local validation.

### Reason

After repeated-pair avoidance, repeated-opponent avoidance is the next fairness gap in the MVP pairing algorithm and can reuse the pairing-history scoring structure.

### Files Changed

- `Sources/PickleBallMatchingCore/Domain/Session.swift`
- `Sources/PickleBallMatchingCore/Application/GenerateNextRoundUseCase.swift`
- `Tests/PickleBallMatchingCoreTests/GenerateNextRoundUseCaseTests.swift`
- `Tests/PickleBallMatchingCoreTests/JSONSessionRepositoryTests.swift`
- Codex/Scrum status docs

### Commands Run

- `gh issue create ...`
- `gh project item-add ...`
- `gh project item-edit ...`
- `git switch -c codex/sbi-60-avoid-repeat-opponents`
- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`
- `gh project item-edit ... Validation Status Passed`

### GitHub Project Updates

Issue #60 added to Project as SBI, Status `In progress`, Scrum Status `In Progress`, Priority `P0`, Role Owner `swift-developer`, Risk `medium`, Area `Application`, Validation Status `Passed`, Parent PBI `#16`, and Sprint `Sprint 2026-06 MVP`.

### Architecture Decision

`SessionRuleSet` gains `avoidsRepeatedOpponents` with backward-compatible decoding. Opponent-history scoring stays in `GenerateNextRoundUseCase`; no UI or Infrastructure dependency is introduced.

### Validation

Full validation passed: `swift test` 24 core tests, SwiftLint 0 violations, SwiftFormat lint 0 files, XcodeGen generation, `xcodebuild build`, and `xcodebuild test` with 24 core tests and 43 app tests.

### Risk

Medium until PR CI passes. The change affects pairing selection and JSON decoding behavior, but both are covered by tests.

### Follow-up

Commit, push, open PR, and move Issue #60 to In Review with PR evidence.

## 2026-06-02 08:32 JST

### Action

Opened PR #61 for Issue #60 and moved the GitHub Project item to In Review.

### Reason

Repeated-opponent avoidance is implemented, locally validated, and ready for autonomous review through GitHub Actions before squash merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `git commit -m "feat(rounds): reduce repeated opponents"`
- `git push -u origin codex/sbi-60-avoid-repeat-opponents`
- `gh pr create ...`
- `gh issue edit 60 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Status `In review`, Scrum Status `In Review`, Evidence Link PR #61, and Validation Status `Passed`

### GitHub Project Updates

Issue #60 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/61`.

### Architecture Decision

No additional architecture change beyond the Application-layer opponent-history scoring and backward-compatible `SessionRuleSet` decoding.

### Validation

Local validation passed before PR creation. GitHub Actions is running.

### Risk

Medium until PR #61 CI passes.

### Follow-up

Watch PR #61 CI, squash merge to `dev` if it passes, close Issue #60, and set the Project item Done.

## 2026-06-02 08:38 JST

### Action

Merged PR #61, closed Issue #60, and set the GitHub Project item to Done.

### Reason

PR #61 passed both local validation and GitHub Actions. Repeated-opponent avoidance meets the Issue #60 acceptance criteria and is ready as a Done increment on `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr checks 61 --watch --interval 10`
- `gh pr merge 61 --squash --delete-branch ...`
- `gh issue edit 60 --remove-label status:in-review --add-label status:done`
- `gh project item-edit ...` for Status `Done`
- `gh project item-edit ...` for Scrum Status `Done`
- `gh issue comment 60 ...`
- `gh issue close 60 --reason completed`

### GitHub Project Updates

Issue #60 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #61. The issue is closed.

### Architecture Decision

No additional architecture change after PR merge. Opponent-history scoring remains in Application and does not introduce UI or Infrastructure dependencies.

### Validation

GitHub Actions `validate` passed for PR #61 before merge.

### Risk

Low after merge.

### Follow-up

Select the next MVP SBI. Rule-setting UI is the strongest candidate because the fairness rules now exist in Domain/Application and need organizer-facing control.

## 2026-06-02 08:46 JST

### Action

Created and selected Issue #62, added it to Project `kanban@pickle_ball_matching`, implemented organizer-facing rule settings UI, and completed full local validation.

### Reason

After repeated-pair and repeated-opponent avoidance were implemented, `SessionRuleSet` contained organizer-relevant rules without a visible control surface. A rule settings UI is the next small vertical slice that lets organizers adapt fairness behavior without changing code.

### Files Changed

- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Features/OperationBoard/Presentation/OperationBoardRuleSettings.swift`
- `Features/OperationBoard/Presentation/OperationBoardViewModel.swift`
- `Features/OperationBoard/Presentation/RuleSettingsSection.swift`
- `Tests/PickleBallMatchingTests/OperationBoardRuleSettingsTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardViewModelTests.swift`
- Codex/Scrum status docs

### Commands Run

- `gh issue create ...`
- `gh project item-add ...`
- `gh project item-edit ...`
- `git switch -c codex/sbi-62-rule-settings-ui`
- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`
- `gh project item-edit ... Validation Status Passed`

### GitHub Project Updates

Issue #62 added to Project as SBI, Status `In progress`, Scrum Status `In Progress`, Priority `P1`, Role Owner `swift-developer`, Risk `medium`, Area `UI`, Validation Status `Passed`, Parent PBI `#16`, and Sprint `Sprint 2026-06 MVP`.

### Architecture Decision

Presentation adds `RuleSettingsSection` and an `OperationBoardViewModel` extension for `SessionRuleSet` updates. The View still talks only to the ViewModel, persistence remains behind `SessionRepository`, and Domain remains framework-free.

### Validation

Full validation passed: `swift test` 24 core tests, SwiftLint 0 violations, SwiftFormat lint 0 files, XcodeGen generation, `xcodebuild build`, and `xcodebuild test` with 24 core tests and 45 app tests.

### Risk

Medium until PR CI passes. The change affects on-screen settings and session autosave behavior, with ViewModel tests covering rule update and no-op save behavior.

### Follow-up

Commit, push, open PR, and move Issue #62 to In Review with PR evidence.

## 2026-06-02 08:49 JST

### Action

Opened PR #63 for Issue #62 and moved the GitHub Project item to In Review.

### Reason

Rule settings UI is implemented, locally validated, and ready for autonomous review through GitHub Actions before squash merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `git commit -m "feat(settings): edit pairing rules"`
- `git push -u origin codex/sbi-62-rule-settings-ui`
- `gh pr create ...`
- `gh issue edit 62 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Status `In review`, Scrum Status `In Review`, and Evidence Link PR #63

### GitHub Project Updates

Issue #62 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/63`.

### Architecture Decision

No additional architecture change beyond the Presentation/ViewModel rule settings boundary.

### Validation

Local validation passed before PR creation. GitHub Actions is running.

### Risk

Medium until PR #63 CI passes.

### Follow-up

Watch PR #63 CI, squash merge to `dev` if it passes, close Issue #62, and set the Project item Done.

## 2026-06-02 08:58 JST

### Action

Merged PR #63, closed Issue #62, and set the GitHub Project item to Done.

### Reason

PR #63 passed local validation and GitHub Actions. Rule settings UI meets the Issue #62 acceptance criteria and is ready as a Done increment on `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr checks 63 --watch --interval 10`
- `gh pr merge 63 --squash --delete-branch ...`
- `gh issue edit 62 --remove-label status:in-review --add-label status:done`
- `gh project item-edit ...` for Status `Done`
- `gh project item-edit ...` for Scrum Status `Done`
- `gh issue comment 62 ...`
- `gh issue close 62 --reason completed`

### GitHub Project Updates

Issue #62 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #63. The issue is closed.

### Architecture Decision

No additional architecture change after PR merge. Rule settings remain Presentation/ViewModel scoped and persistence remains behind `SessionRepository`.

### Validation

GitHub Actions `validate` passed for PR #63 before merge.

### Risk

Low after merge.

### Follow-up

Select the next MVP SBI. Candidate areas are score/result capture, rule presets, or Pro boundary work.

## 2026-06-02 09:12 JST

### Action

Created and locally implemented Issue #64 for current-round score and winner recording.

### Reason

The MVP flow needs a simple way for organizers to record round outcomes without leaving the progress board. This is a small reversible vertical slice: Domain stores a local score value, Presentation exposes Stepper controls, and ViewModel autosaves through the existing repository boundary.

### Files Changed

- `Sources/PickleBallMatchingCore/Domain/Round.swift`
- `Features/OperationBoard/Presentation/CurrentRoundSection.swift`
- `Features/OperationBoard/Presentation/OperationBoardMatchScoreActions.swift`
- `Features/OperationBoard/Presentation/OperationBoardView.swift`
- `Tests/PickleBallMatchingCoreTests/MatchScoreTests.swift`
- `Tests/PickleBallMatchingTests/OperationBoardMatchScoreTests.swift`
- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `swiftformat --cache ignore .`
- `swift test`
- `scripts/codex/validate-ios.sh`
- `gh project item-edit ... Validation Status Passed`

### GitHub Project Updates

Issue #64 is in Project `kanban@pickle_ball_matching` as an SBI. Validation Status was set to `Passed`; Status and Scrum Status remain `In Progress` until the PR is opened.

### Architecture Decision

Domain adds `MatchScore` and `MatchWinner` under `Round.swift`. Presentation score controls live in `CurrentRoundSection`, while mutation logic is isolated in `OperationBoardMatchScoreActions`; persistence remains behind `SessionRepository`.

### Validation

Full validation passed: `swift test` 29 core tests, SwiftLint 0 violations, SwiftFormat lint 0 files, XcodeGen generation, `xcodebuild build`, and `xcodebuild test` with 29 core tests and 47 app tests.

### Risk

Medium until PR CI passes. The JSON model adds an optional `score` field on `Match`; the optional field is intended to keep existing saved sessions decodable.

### Follow-up

Commit, push, open PR, move Issue #64 to In Review, and add PR evidence to the GitHub Project item.

## 2026-06-02 09:16 JST

### Action

Opened PR #65 for Issue #64 and moved the GitHub Project item to In Review.

### Reason

The score/winner recording slice passed local validation and is ready for autonomous CI review before squash merge to `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`

### Commands Run

- `git commit -m "feat(matches): record match scores"`
- `git push -u origin codex/sbi-64-match-score-entry`
- GitHub connector `_create_pull_request` for PR #65
- `gh issue edit 64 --remove-label status:in-progress --add-label status:in-review`
- `gh project item-edit ...` for Status `In review`, Scrum Status `In Review`, and Evidence Link PR #65

### GitHub Project Updates

Issue #64 set to Status `In review`, Scrum Status `In Review`, Validation Status `Passed`, and Evidence Link `https://github.com/ka-bo-su/pickle_ball_matching/pull/65`.

### Architecture Decision

No additional architecture decision after PR creation. The implementation remains a Domain value-type addition plus Presentation/ViewModel score editing.

### Validation

Local validation passed before PR creation. GitHub Actions is running.

### Risk

Medium until PR #65 CI passes.

### Follow-up

Watch PR #65 CI, squash merge to `dev` if it passes, close Issue #64, and set the Project item Done.

## 2026-06-02 09:18 JST

### Action

Recorded an execution-environment blocker for PR #65 CI confirmation and merge follow-up.

### Reason

`gh pr checks 65` and `gh run view 26790276942` were rejected by Codex escalation auto-review because the current execution usage limit is exhausted. The prior watch command only showed the check as pending.

### Files Changed

- `docs/codex/blockers.md`
- `docs/codex/github-projects-pending-updates.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr checks 65 --watch --interval 10`
- `gh pr checks 65` rejected by execution usage limit
- `gh run view 26790276942 --json status,conclusion,createdAt,updatedAt,jobs` rejected by execution usage limit

### GitHub Project Updates

No additional Project update was applied after the rejection. Issue #64 remains In Review with PR #65 evidence and Validation Status Passed.

### Architecture Decision

No architecture change.

### Validation

Local validation had already passed. CI result could not be confirmed in this execution window.

### Risk

Low product-code risk, medium process risk until CI is confirmed and PR #65 is merged.

### Follow-up

After quota reset, run PR #65 checks, squash merge if green, close Issue #64, and set the Project item Done.

## 2026-06-02 14:38 JST

### Action

Resolved the PR #65 execution-environment blocker in local Codex docs.

### Reason

Execution resumed and `gh pr view 65` confirmed PR #65 remote CI had passed on the previously pushed head. The local branch still contained the prior blocker-record commit, so the blocker needed to be marked resolved before pushing docs.

### Files Changed

- `docs/codex/blockers.md`
- `docs/codex/github-projects-pending-updates.md`
- `docs/codex/nightly-state.md`
- `docs/codex/nightly-summary.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr view 65 --json number,state,mergeable,headRefName,baseRefName,commits,statusCheckRollup,url`

### GitHub Project Updates

No Project field change in this checkpoint. Issue #64 remains In Review with PR #65 evidence.

### Architecture Decision

No architecture change.

### Validation

PR #65 remote CI had passed on the previously pushed head. A final recheck is required after pushing the blocker-resolution docs.

### Risk

Low. The change is documentation-only, but it will update the PR head and rerun CI.

### Follow-up

Push the docs resolution, recheck PR #65 CI, squash merge if green, and set Issue #64 / Project Done.

## 2026-06-02 14:48 JST

### Action

Merged PR #65, closed Issue #64, and set the GitHub Project item to Done.

### Reason

PR #65 passed local validation and GitHub Actions `validate`. The score/winner recording slice meets the Issue #64 acceptance criteria and is ready as a Done increment on `dev`.

### Files Changed

- `docs/codex/progress-ledger.md`
- `docs/codex/nightly-state.md`
- `docs/codex/github-projects-inventory.md`
- `docs/codex/nightly-summary.md`
- `docs/scrum/product-backlog.md`
- `docs/scrum/sprint-backlog.md`
- `docs/codex/audit-log.md`

### Commands Run

- `gh pr checks 65 --watch --interval 10`
- `gh run view 26800772677 --json status,conclusion,jobs`
- `gh pr merge 65 --squash --delete-branch ...`
- `gh issue edit 64 --remove-label status:in-review --add-label status:done`
- `gh project item-edit ...` for Status `Done`
- `gh project item-edit ...` for Scrum Status `Done`
- `gh issue comment 64 ...`
- `gh issue close 64 --reason completed`

### GitHub Project Updates

Issue #64 set to Status `Done`, Scrum Status `Done`, Validation Status `Passed`, and Evidence Link PR #65. The issue is closed.

### Architecture Decision

No additional architecture change after PR merge. Score recording remains a Domain value-type addition with Presentation/ViewModel editing and repository-backed autosave.

### Validation

GitHub Actions `validate` passed for PR #65 before merge.

### Risk

Low after merge.

### Follow-up

Select the next MVP SBI. Candidate areas include rule presets, richer score/history display, session deletion/search, or Pro boundary work.
