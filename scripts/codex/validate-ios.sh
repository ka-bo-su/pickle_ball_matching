#!/usr/bin/env bash
set -euo pipefail

failures=0
project="${PROJECT:-PickleBallMatching.xcodeproj}"
scheme="${SCHEME:-PickleBallMatching}"
destination="${DESTINATION:-platform=iOS Simulator,name=iPhone 16}"

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
  run_step "swiftformat --cache ignore --lint ." swiftformat --cache ignore --lint .
else
  echo "[skip] swiftformat not installed"
fi

if [[ -f project.yml ]] && command -v xcodegen >/dev/null 2>&1; then
  run_step "xcodegen generate" xcodegen generate
else
  echo "[skip] project.yml or xcodegen not available"
fi

run_xcodebuild() {
  local title="$1"
  shift
  echo
  echo "## ${title}"
  if command -v xcbeautify >/dev/null 2>&1; then
    set +e
    xcodebuild "$@" | xcbeautify
    local code=${PIPESTATUS[0]}
    set -e
    if [[ "${code}" -eq 0 ]]; then
      echo "[ok] ${title}"
    else
      failures=$((failures + 1))
      echo "[fail] ${title} exited ${code}"
    fi
  else
    run_step "${title}" xcodebuild "$@"
  fi
}

resolve_destination() {
  if [[ -n "${DESTINATION:-}" ]]; then
    return 0
  fi

  if xcrun simctl list devices available | grep -q "iPhone 16"; then
    destination="platform=iOS Simulator,name=iPhone 16"
    return 0
  fi

  local fallback
  fallback="$(xcrun simctl list devices available | sed -n 's/.*\(iPhone [^ (][^(]*\) (.*/\1/p' | head -n 1)"
  if [[ -n "${fallback}" ]]; then
    destination="platform=iOS Simulator,name=${fallback}"
    echo "[info] iPhone 16 simulator not found; using ${fallback}"
    return 0
  fi

  echo "[fail] No available iPhone simulator found"
  failures=$((failures + 1))
  return 1
}

if [[ -d "${project}" ]]; then
  run_step "xcodebuild -list" xcodebuild -list -project "${project}"
  if resolve_destination; then
    run_xcodebuild "xcodebuild build" build -project "${project}" -scheme "${scheme}" -destination "${destination}"
    run_xcodebuild "xcodebuild test" test -project "${project}" -scheme "${scheme}" -destination "${destination}"
  fi
else
  echo "[skip] ${project} not found"
fi

if [[ "${failures}" -gt 0 ]]; then
  echo
  echo "Validation completed with ${failures} failure(s). Record root causes in docs/codex/ios-swift-validation.md or docs/codex/blockers.md."
  exit 1
fi

echo
echo "Validation completed successfully."
