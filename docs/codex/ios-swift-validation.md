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
xcodebuild test -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'
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

Last checked: 2026-06-11 22:39 JST

| Command | Result | Notes |
|---|---|---|
| `scripts/codex/preflight.sh` | passed | Tuist missing only; optional |
| `swift test` | passed | 34 core tests, 0 failures; local linker warning for missing Homebrew GMP search path is non-blocking |
| `swiftlint --no-cache` | passed | 1 non-serious existing test type-body warning in 67 files |
| `swiftformat --swiftversion 6.0 --cache ignore --lint .` | passed | 0 of 67 Swift files require formatting; rules loaded from `.swiftformat` |
| `xcodegen generate` | passed | generated `PickleBallMatching.xcodeproj` locally; ignored by git |
| `xcodebuild -list -project PickleBallMatching.xcodeproj` | passed | schemes: `PickleBallMatching`, `PickleBallMatchingCore` |
| `xcodebuild build -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'` | passed | SwiftUI app target builds on iPhone 16 simulator |
| `xcodebuild test -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:PickleBallMatchingCoreTests` | passed | 34 Xcode core tests passed |
| full `xcodebuild test -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'` | partial | Core bundle passed, then hosted app test launch hung/failed with Simulator `NSMachErrorDomain Code=-308`; rerun after Simulator restart |

Latest UI validation result: local #85 passed SwiftPM tests, lint/format, XcodeGen, Xcode build, and Xcode Core tests. Full hosted app tests should be rerun after Simulator restart because the host app launch failed independently of compilation.

`scripts/codex/validate-ios.sh` uses `iPhone 16` when available and falls back to the first available iPhone Simulator on CI runners. If no iPhone Simulator exists, validation fails instead of silently skipping the Xcode build/test path.

## Repair Notes From Validation

- `PickleBallMatchingCore` needed `GENERATE_INFOPLIST_FILE: YES` in `project.yml` for XcodeGen-generated framework builds.
- `xcodebuild test` also requires `PRODUCT_BUNDLE_IDENTIFIER` on generated framework and test bundle targets.
- GitHub Actions fresh checkout needs tracked source directories. `Shared/.gitkeep` keeps the XcodeGen `Shared/` source path present before future shared code is added.
- No current blocker prevents SwiftPM or XcodeGen-based iOS development.

## Resolved Validation Blocker

Issue #56 local code could not complete validation in the current Codex execution window:

- `swiftformat --cache ignore .`: blocked because escalated execution was rejected by Codex usage limit.
- `swiftlint --no-cache`: blocked because escalated execution was rejected by Codex usage limit.
- `swift test`: non-escalated attempts failed because SwiftPM/Xcode sandbox/cache access is unavailable in the current sandbox.

This was an execution-environment blocker, not a code failure. It was resolved on 2026-06-02 after execution quota reset; Issue #56 full validation passed.

## Current Validation Blocker

Issue #74 local code could not complete full validation in the current Codex execution window on 2026-06-02 22:19 JST:

- `swift test`: failed inside the sandbox because SwiftPM could not write `~/.cache/clang/ModuleCache`.
- `swiftlint --no-cache`: passed with 0 violations.
- `swiftformat --cache ignore --lint .`: passed with 0 files requiring formatting.
- `xcodegen generate`: passed.
- `xcodebuild -list`: passed, but emitted sandbox-related CoreSimulatorService warnings.
- Simulator discovery: failed because CoreSimulatorService is unavailable inside the sandbox.
- Escalated `scripts/codex/validate-ios.sh`: rejected by Codex execution usage limit.

This is recorded as an execution-environment blocker, not an observed code failure. When execution quota resumes, rerun:

```bash
scripts/codex/validate-ios.sh
```

If validation passes, publish `codex/sbi-31-delete-saved-sessions` and move Issue #74 to In Review.
