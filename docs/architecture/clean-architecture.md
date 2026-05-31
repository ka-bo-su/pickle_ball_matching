# Clean Architecture

The app favors Clean Architecture without overbuilding.

## Dependency Direction

```text
Presentation -> Application -> Domain
Infrastructure -> Domain
App/CompositionRoot -> Presentation/Application/Infrastructure
```

## Rules

- Domain does not import SwiftUI, UIKit, networking, persistence, or infrastructure details.
- UseCases depend on repository protocols.
- Infrastructure implements repository protocols.
- Views call ViewModels, not API clients, DBs, or repository implementations.
- ViewModels receive UseCases through initializer injection.
- DTOs and domain entities are separated when external data appears.
- Composition Root wires concrete implementations.

## Vertical Slice Expectation

Prefer a small complete flow:

```text
View -> ViewModel -> UseCase -> Repository protocol -> Repository implementation/fake -> Tests
```

Avoid UI-only work, abstract foundations without behavior, and untestable placeholders.
