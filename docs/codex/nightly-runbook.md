# Nightly Runbook

## Start

1. Confirm branch is not `main`.
2. Run `scripts/codex/preflight.sh`.
3. Resolve GitHub Project `kanban@pickle_ball_matching`.
4. Read current Sprint Backlog and Project items.
5. Update `docs/codex/nightly-state.md`.

## Locks

- Run only one `xcodebuild` at a time.
- Edit only one of these at a time: `.xcodeproj`, `.xcworkspace`, `project.pbxproj`, `Package.swift`, `Podfile`, `project.yml`, `Tuist.swift`.
- Edit `.codex/config.toml`, `AGENTS.md`, and GitHub Project fields serially.
- Parallelize only disjoint docs, issue inventory, previews, reviews, and feature files.

## End or Handoff

Do not stop because a single item blocked. Stop only when no safe code, test, docs, issue, or Project work remains, or when a hard-stop category is required.

Before stopping, update:

- `docs/codex/nightly-summary.md`
- `docs/codex/next-work-search.md`
- `docs/codex/blockers.md`
- `docs/codex/github-projects-pending-updates.md`
