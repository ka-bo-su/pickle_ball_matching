# iOS / Swift Validation

## Project Detection

Initial detection found no existing `.xcodeproj`, `.xcworkspace`, `Package.swift`, `project.yml`, `Tuist.swift`, or `Podfile`.

This migration creates:

- `Package.swift` for `PickleBallMatchingCore`
- `project.yml` for XcodeGen
- SwiftUI app shell under `App/` and `Features/`

## Commands

```bash
scripts/codex/preflight.sh
swift test
swiftlint
swiftformat --lint .
xcodegen generate
xcodebuild -list
xcodebuild build -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Lock Policy

- Run only one `xcodebuild` at a time.
- Edit `Package.swift`, `project.yml`, `.xcodeproj`, `.xcworkspace`, and `project.pbxproj` serially.
- If `xcodebuild` fails due to local Simulator/Xcode environment, keep working on SwiftPM tests, docs, Issues, Project sync, and architecture boundaries.

## Current Scheme

- Expected app scheme: `PickleBallMatching`
- Expected core target: `PickleBallMatchingCore`
- Preferred destination: `platform=iOS Simulator,name=iPhone 16`

## Latest Validation

Last checked: 2026-06-01 02:55 JST

| Command | Result | Notes |
|---|---|---|
| `scripts/codex/preflight.sh` | passed | Tuist missing only; optional |
| `swift test` | passed | 2 tests, 0 failures; local linker warning for missing Homebrew GMP search path is non-blocking |
| `swiftlint --no-cache` | passed | 0 violations in 11 files |
| `swiftformat --swiftversion 6.0 --cache ignore --lint .` | passed | 0 files require formatting |
| `xcodegen generate` | passed | generated `PickleBallMatching.xcodeproj` locally; ignored by git |
| `xcodebuild -list -project PickleBallMatching.xcodeproj` | passed | schemes: `PickleBallMatching`, `PickleBallMatchingCore` |
| `xcodebuild build -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'` | passed | initial generated Info.plist issue fixed in `project.yml` |

Full validation script result: `scripts/codex/validate-ios.sh` passed.

## Repair Notes From Validation

- `PickleBallMatchingCore` needed `GENERATE_INFOPLIST_FILE: YES` in `project.yml` for XcodeGen-generated framework builds.
- No current blocker prevents SwiftPM or XcodeGen-based iOS development.
