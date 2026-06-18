# iOS Bootstrap Plan

## Decision

Use SwiftPM for the testable core and XcodeGen for the iOS SwiftUI app shell.

## Reason

No existing iOS project is present. XcodeGen is installed, so the repository can avoid hand-writing a large `project.pbxproj` while still producing an Xcode project for Simulator build/test.

## Structure

```text
Package.swift
Sources/PickleBallMatchingCore/
  Domain/
  Application/
  Infrastructure/
Tests/PickleBallMatchingCoreTests/
project.yml
App/
  CompositionRoot/
Features/Matching/
  Presentation/
Shared/
```

## First Vertical Slice

The bootstrap slice provides:

- Domain entities for player profiles and match candidates
- `MatchingRepository` protocol
- `LoadMatchCandidatesUseCase`
- `InMemoryMatchingRepository`
- SwiftUI matching list view and ViewModel
- XCTest coverage for sorting and repository behavior

## Follow-up

- Add ViewModel tests in an iOS test target.
- Add richer matching criteria and persistence/API adapters behind repository protocols.
- Add accessibility and UI snapshot coverage when project validation is stable.
