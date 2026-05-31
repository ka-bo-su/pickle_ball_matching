#!/usr/bin/env bash
set -euo pipefail

failures=0

run_step() {
  local title="$1"
  shift
  echo
  echo "## ${title}"
  if "$@"; then
    echo "[ok] ${title}"
  else
    local code=$?
    failures=$((failures + 1))
    echo "[fail] ${title} exited ${code}"
  fi
}

if [[ -f Package.swift ]]; then
  run_step "swift test" swift test
else
  echo "[skip] Package.swift not found"
fi

if command -v swiftlint >/dev/null 2>&1; then
  run_step "swiftlint --no-cache" swiftlint --no-cache
else
  echo "[skip] swiftlint not installed"
fi

if command -v swiftformat >/dev/null 2>&1; then
  run_step "swiftformat --swiftversion 6.0 --cache ignore --lint ." swiftformat --swiftversion 6.0 --cache ignore --lint .
else
  echo "[skip] swiftformat not installed"
fi

if [[ -f project.yml ]] && command -v xcodegen >/dev/null 2>&1; then
  run_step "xcodegen generate" xcodegen generate
else
  echo "[skip] project.yml or xcodegen not available"
fi

if [[ -d PickleBallMatching.xcodeproj ]]; then
  run_step "xcodebuild -list" xcodebuild -list -project PickleBallMatching.xcodeproj
  if xcrun simctl list devices available | grep -q "iPhone 16"; then
    run_step "xcodebuild build" xcodebuild build -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination "platform=iOS Simulator,name=iPhone 16"
  else
    echo "[skip] iPhone 16 simulator not available"
  fi
else
  echo "[skip] PickleBallMatching.xcodeproj not found"
fi

if [[ "${failures}" -gt 0 ]]; then
  echo
  echo "Validation completed with ${failures} failure(s). Record root causes in docs/codex/ios-swift-validation.md or docs/codex/blockers.md."
  exit 1
fi

echo
echo "Validation completed successfully."
