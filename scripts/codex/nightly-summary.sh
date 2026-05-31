#!/usr/bin/env bash
set -euo pipefail

summary_file="docs/codex/nightly-summary.md"
timestamp="$(date '+%Y-%m-%d %H:%M %Z')"
branch="$(git branch --show-current || true)"
status="$(git status --short || true)"
last_commit="$(git log -1 --oneline || true)"

{
  echo "# Nightly / Continuous Summary"
  echo
  echo "## Result"
  echo
  echo "- Completed: see progress ledger"
  echo "- Partially completed: see git status"
  echo "- Blocked: see blockers"
  echo
  echo "## Time"
  echo
  echo "- Started: see nightly-state"
  echo "- Finished: ${timestamp}"
  echo "- Approximate duration: session-dependent"
  echo
  echo "## PRs"
  echo
  echo "- Opened: check GitHub"
  echo "- Merged: check GitHub"
  echo "- Closed: check GitHub"
  echo
  echo "## Commits"
  echo
  echo "- ${last_commit}"
  echo
  echo "## GitHub Project Updates"
  echo
  echo "- See docs/codex/progress-ledger.md and GitHub Project kanban@pickle_ball_matching"
  echo
  echo "## Pending GitHub Project Updates"
  echo
  echo "- See docs/codex/github-projects-pending-updates.md"
  echo
  echo "## iOS Validation"
  echo
  echo "- Build: see docs/codex/ios-swift-validation.md"
  echo "- Test: see docs/codex/ios-swift-validation.md"
  echo "- Lint: see docs/codex/ios-swift-validation.md"
  echo "- Simulator: see docs/codex/local-environment.md"
  echo
  echo "## Files Changed"
  echo
  if [[ -n "${status}" ]]; then
    echo '```text'
    echo "${status}"
    echo '```'
  else
    echo "- Working tree clean"
  fi
  echo
  echo "## PBI/SBI Progress"
  echo
  echo "- Done: see sprint review log"
  echo "- In progress: see sprint backlog"
  echo "- Blocked: see blockers"
  echo "- Next: see next work search"
  echo
  echo "## Architecture"
  echo
  echo "- Decisions: see docs/codex/architecture-decisions.md"
  echo "- Boundary changes: see docs/architecture"
  echo "- Refactor tasks: see Product Backlog"
  echo "- Risks: see audit log"
  echo
  echo "## Local Environment"
  echo
  echo "- Missing: see docs/codex/local-environment.md"
  echo "- Degraded: see docs/codex/local-environment.md"
  echo "- Recommended repair commands: see docs/codex/local-environment.md"
  echo
  echo "## Human Review Notes"
  echo
  echo "- Review closed PRs and merged changes in GitHub"
  echo "- Pay attention to validation failures and architecture decisions"
  echo "- Possible rollback: revert the relevant PR"
  echo
  echo "## Next Recommended Codex Goal"
  echo
  echo "- Continue with the next Ready SBI in GitHub Project kanban@pickle_ball_matching"
} > "${summary_file}"

echo "Updated ${summary_file}"
