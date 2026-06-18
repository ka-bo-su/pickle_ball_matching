#!/usr/bin/env bash
set -euo pipefail

echo "## Codex iOS bootstrap"

if command -v brew >/dev/null 2>&1 && [[ -f Brewfile ]]; then
  echo
  echo "Detected Brewfile. To install missing tools manually, run:"
  echo "  brew bundle install"
fi

echo
echo "## Generate Xcode project"
if command -v xcodegen >/dev/null 2>&1; then
  xcodegen generate
else
  echo "[skip] xcodegen is not installed. Install with: brew install xcodegen"
fi

echo
echo "## Preflight"
scripts/codex/preflight.sh

echo
echo "## Validation"
scripts/codex/validate-ios.sh

echo
echo "Bootstrap completed."
