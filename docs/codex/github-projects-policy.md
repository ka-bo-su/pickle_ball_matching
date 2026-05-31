# GitHub Projects Policy

GitHub Project `kanban@pickle_ball_matching` is the operational source of truth for PBI / SBI / Task / Bug / Chore state.

## Sync Targets

Priority order:

1. GitHub Project `kanban@pickle_ball_matching`
2. GitHub Issues / PRs
3. `docs/scrum/*.md`
4. `docs/codex/*.md`

If Project updates fail, record the intended update in `docs/codex/github-projects-pending-updates.md` and continue.

## Required Fields

- Backlog Level
- Scrum Status
- Sprint
- Priority
- Estimate
- Role Owner
- Parent PBI
- Acceptance Criteria
- Definition of Done
- Evidence Link
- Risk
- Area
- Architecture Impact
- Validation Status

## Required Labels

```text
type:pbi type:sbi type:task type:bug type:chore
area:ios area:ui area:domain area:application area:infrastructure area:test area:architecture area:docs
status:ready status:selected status:in-progress status:in-review status:blocked status:done
risk:low risk:medium risk:high risk:critical
arch:clean-architecture arch:domain arch:application arch:infrastructure arch:presentation arch:di arch:refactor
parallel:safe parallel:blocked
```

## Update Timing

- Select PBI/SBI: set Scrum Status to Selected or In Progress.
- Start implementation: add branch/commit evidence.
- Open PR: set In Review and record validation/risk.
- Merge/close PR: set Done, close issue, link evidence.
- Blocker: set Blocked for only the affected item and select next safe item.
