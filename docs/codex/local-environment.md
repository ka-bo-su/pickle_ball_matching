# Local Environment

Last checked: 2026-06-01 02:55 JST

## Summary

The local machine can perform SwiftPM and XcodeGen-based iOS development. Xcode, Swift, Simulator runtimes, Codex CLI, GitHub CLI, jq, SwiftLint, SwiftFormat, xcbeautify, XcodeGen, CocoaPods, Mint, Homebrew, Ruby, and Bundler are available. Tuist is not installed and is optional for this repository. `scripts/codex/preflight.sh` completed successfully.

## Environment Table

| Item | Required | Status | Detected Version | Repair Command | Blocking Level |
| ---- | -------: | ------ | ---------------- | -------------- | -------------- |
| macOS | yes | available | macOS 15.1 build 24B83 | n/a | ok |
| Disk space | yes | available | 541Gi free on workspace volume | Free local disk space | ok |
| Xcode full installation | yes | available | Xcode 16.2 build 16C5032a | Install Xcode from Apple Developer/App Store | ok |
| Xcode Command Line Tools | yes | available | `/Applications/Xcode.app/Contents/Developer` | `xcode-select --install` | ok |
| iOS SDK | yes | available | iOS 18.2 | Install Simulator/runtime in Xcode | ok |
| iOS Simulator runtime | yes | available | iOS 17.4, iOS 18.2 | Install runtime in Xcode Settings | ok |
| Swift compiler | yes | available | Swift 6.0.3 | Install/update Xcode | ok |
| xcodebuild | yes | available | Xcode 16.2 | Install/update Xcode | ok |
| xcrun | yes | available | Xcode toolchain | Install/update Xcode | ok |
| git | yes | available | Apple Git 2.39.5 | `xcode-select --install` | ok |
| GitHub CLI `gh` | yes | available | 2.92.0 | `brew install gh` | ok |
| GitHub authentication | yes | available | user `ka-bo-su`, scopes include `project` | `gh auth login` | ok |
| GitHub Project scope | yes | available | `project` scope present | `gh auth refresh -s read:project -s project` | ok |
| jq | yes | available | jq-1.6-159-apple | `brew install jq` | ok |
| Codex CLI | yes | available | codex-cli 0.135.0 | `npm install -g @openai/codex` | ok |
| Codex goals feature | yes | available | enabled in installed CLI | `codex features enable goals` | ok |
| Sleep prevention | yes | command available | `caffeinate` via macOS | Use `caffeinate -dimsu ...` | ok |
| SwiftLint | no | available | 0.63.3 | `brew install swiftlint` | optional |
| SwiftFormat | no | available | 0.61.1 | `brew install swiftformat` | optional |
| xcbeautify | no | available | 3.2.1 | `brew install xcbeautify` | optional |
| fastlane | no | not verified | not required for bootstrap | `brew install fastlane` | optional |
| XcodeGen | no | available | 2.45.4 | `brew install xcodegen` | ok |
| Tuist | no | missing | not installed | Install from Tuist official docs if adopted | optional |
| CocoaPods | no | available | 1.16.2 | `sudo gem install cocoapods` | optional |
| Bundler | no | available | 1.17.2 | `gem install bundler` | optional |
| Homebrew | no | available | 5.1.14 | Install Homebrew manually | optional |
| Mint | no | available | 0.18.0 | `brew install mint` | optional |
| Ruby | no | available | 2.6.10 | Install via Xcode CLT or Ruby manager | optional |
| yq | no | available | 4.53.2 | `brew install yq` | optional |

## Preflight Commands

```bash
uname -a
sw_vers || true
df -h .
git --version
git status --short
codex --version || true
gh --version || true
gh auth status || true
xcode-select -p || true
xcodebuild -version || true
xcodebuild -showsdks || true
xcrun simctl list runtimes available || true
xcrun simctl list devices available || true
swift --version || true
swiftlint version || true
swiftformat --version || true
xcbeautify --version || true
xcodegen --version || true
tuist version || true
bundle --version || true
pod --version || true
jq --version || true
```

## Suggested Long-Running Launch

```bash
codex features enable goals
gh auth status
gh auth refresh -s project
caffeinate -dimsu codex \
  --cd . \
  --sandbox workspace-write \
  --ask-for-approval never \
  --search
```

## Latest Preflight Result

- Command: `scripts/codex/preflight.sh`
- Result: passed
- Notes: Tuist is missing but optional. CocoaPods prints a UTF-8 locale warning in this shell, but this repository does not depend on CocoaPods.
