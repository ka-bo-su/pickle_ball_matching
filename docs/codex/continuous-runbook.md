# Continuous Runbook

## Loop

1. Read `docs/codex/nightly-state.md`.
2. Read GitHub Project `kanban@pickle_ball_matching`.
3. Read GitHub Issues and PRs.
4. Read `docs/scrum/product-backlog.md` and `docs/scrum/sprint-backlog.md`.
5. Use `product-owner` to choose the next PBI.
6. Use `scrum-master` to split or select an SBI.
7. Assess architecture impact.
8. Use `swift-developer` to implement a small vertical slice.
9. Use `reviewer` and `architect-reviewer` to review.
10. Run validation.
11. Commit, open PR, update Project, update logs.
12. Use `release-reviewer` for merge readiness.
13. Select the next safe item and repeat.

## Work Search Order

1. GitHub Project `Scrum Status: In Progress`
2. Current Sprint Backlog unfinished SBI
3. GitHub Project `Scrum Status: Ready`
4. Ready GitHub Issues
5. Split PBI into SBI
6. iOS build/test/lint improvements
7. XCTest, Preview, accessibility, error handling, architecture, DI, refactor, docs, Project cleanup
8. Update `docs/codex/next-work-search.md`

## Checkpoints

Update `nightly-state.md`, `progress-ledger.md`, `audit-log.md`, and `sprint-backlog.md` when:

- an SBI starts or completes
- a PR opens, merges, or closes
- validation succeeds or fails
- a blocker appears
- a Project update succeeds or fails
- an architecture decision is made
