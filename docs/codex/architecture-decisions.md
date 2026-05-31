# Architecture Decisions

## ADR-20260601-001: SwiftPM core with XcodeGen app shell

### Context

The repository had no existing iOS project. The target direction is an iOS Swift app that can be developed autonomously by Codex.

### Decision

Use SwiftPM for the testable core (`PickleBallMatchingCore`) and XcodeGen for an iOS SwiftUI app shell.

### Alternatives considered

- Hand-write `.xcodeproj`: rejected because it creates large fragile generated files.
- Tuist: deferred because Tuist is not installed and is unnecessary for the first slice.
- SwiftPM only: insufficient for iOS app shell and Simulator build workflow.

### Consequences

- `swift test` validates core logic quickly.
- `xcodegen generate` creates the project when needed.
- Clean Architecture starts with folder and protocol boundaries before multi-module complexity.

### Follow-up

- Validate generated Xcode project and app build.
- Add ViewModel tests in an iOS test target.
