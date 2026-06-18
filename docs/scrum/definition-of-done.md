# Definition of Done

## Product / Scrum

- [ ] Acceptance Criteria are satisfied.
- [ ] User or technical value is explainable.
- [ ] Increment is inspectable.
- [ ] Sprint Backlog is updated.
- [ ] Sprint Review log contains evidence.

## Implementation

- [ ] Implementation completed.
- [ ] Unnecessary TODO/dead code removed or follow-up issue created.
- [ ] Changes are small and reversible.
- [ ] Existing structure is not broken.

## Architecture

- [ ] Domain does not depend on Presentation or Infrastructure.
- [ ] View does not call APIClient / DB / RepositoryImpl directly.
- [ ] ViewModel does not hold concrete Infrastructure implementation.
- [ ] UseCase depends through repository protocol.
- [ ] DTO and Domain Entity are separated where applicable.
- [ ] DI / Composition Root wires concrete implementations.
- [ ] Test fake/mock can be injected.
- [ ] Abstraction is not excessive.
- [ ] ADR is updated when needed.

## Testing

- [ ] Domain / UseCase / ViewModel test exists where practical.
- [ ] Repository mapping risk has mapping tests where applicable.
- [ ] async/await success/failure cases considered.
- [ ] UI state transitions minimally verified where practical.
- [ ] XCTest added or updated.
- [ ] If testing cannot be done, reason and follow-up are recorded.

## iOS Validation

- [ ] Available build/test/lint commands are run.
- [ ] `docs/codex/ios-swift-validation.md` is updated.
- [ ] Simulator / scheme / destination are recorded.
- [ ] xcodebuild failure includes cause and repair action.

## GitHub Project

- [ ] `kanban@pickle_ball_matching` item is updated.
- [ ] Status is correct.
- [ ] Evidence Link has PR / commit / validation log.
- [ ] Acceptance Criteria are updated.
- [ ] Blocker uses Blocked status.
- [ ] Failed GitHub update has pending update recorded.

## Documentation

- [ ] `docs/codex/progress-ledger.md` updated.
- [ ] `docs/codex/audit-log.md` updated.
- [ ] `docs/scrum/sprint-backlog.md` updated.
- [ ] README / AGENTS / setup docs updated when needed.
