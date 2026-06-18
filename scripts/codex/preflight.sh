#!/usr/bin/env bash
set -euo pipefail

run() {
  local title="$1"
  shift
  echo
  echo "## ${title}"
  if "$@"; then
    echo "[ok] ${title}"
  else
    local code=$?
    echo "[warn] ${title} failed with exit ${code}"
  fi
}

run "uname -a" uname -a
run "sw_vers" sw_vers
run "df -h ." df -h .
run "git --version" git --version
run "git status --short" git status --short
run "codex --version" codex --version
run "gh --version" gh --version
run "gh auth status" gh auth status
run "xcode-select -p" xcode-select -p
run "xcodebuild -version" xcodebuild -version
run "xcodebuild -showsdks" xcodebuild -showsdks
run "xcrun simctl list runtimes available" xcrun simctl list runtimes available
run "xcrun simctl list devices available" xcrun simctl list devices available
run "swift --version" swift --version
run "swiftlint version" swiftlint version
run "swiftformat --version" swiftformat --version
run "xcbeautify --version" xcbeautify --version
run "xcodegen --version" xcodegen --version
run "tuist version" tuist version
run "bundle --version" bundle --version
run "pod --version" pod --version
run "jq --version" jq --version

echo
echo "Preflight complete. Reflect durable findings in docs/codex/local-environment.md."
