# Setup

## Required

```bash
gh auth status
gh auth refresh -s project
codex features enable goals
scripts/codex/preflight.sh
```

## iOS Bootstrap

```bash
swift test
xcodegen generate
xcodebuild -list
scripts/codex/validate-ios.sh
```

## Long-Running Codex

```bash
caffeinate -dimsu codex \
  --cd . \
  --sandbox workspace-write \
  --ask-for-approval never \
  --search
```

## Notes

- Do not direct-push to `main`.
- Use GitHub Project `kanban@pickle_ball_matching` as the source of truth.
- If GitHub updates fail, record pending updates and continue safe local work.
