# Codex Autonomy Policy

Codex runs as an autonomous iOS development system. Human approval is not part of the normal long-running loop; humans audit completed PRs, Project state, diffs, summaries, and logs afterward.

## Default Behavior

- Make reasonable repo-local decisions without waiting.
- Prefer small reversible changes and small PRs.
- Record assumptions and decisions in `docs/codex/audit-log.md`.
- If GitHub Project updates fail, record the pending update and continue.
- If one SBI blocks, mark only that SBI blocked and select the next safe item.
- If iOS build is unavailable, continue with Swift source, XCTest, Project structure, GitHub Issues/Project, docs, and architecture work.

## Hard Stops for the Affected Item

- Secret or credential exposure risk
- Production deploy
- App Store or TestFlight submission
- Paid service, billing, contract, or external account changes
- Production DB or customer data access
- Direct push to `main`
- Destructive operation outside the repository
- OS-wide destructive setting changes
- Required Xcode/Homebrew installation

The overall loop continues unless no code, tests, docs, issue, or Project work can proceed safely.

## Audit Requirements

Record these events:

- Legacy Claude document moves or deprecations
- Codex policy migration
- GitHub Project updates or failures
- Product or architecture assumptions
- Blockers and selected next safe work
- Validation failures and repair actions
- PR creation, merge, close, and release readiness
