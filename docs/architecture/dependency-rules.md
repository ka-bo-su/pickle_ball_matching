# Dependency Rules

## Allowed

```text
View -> ViewModel
ViewModel -> UseCase
UseCase -> Repository protocol
RepositoryImpl -> APIClient / Persistence
CompositionRoot -> concrete implementations
```

## Forbidden

```text
Domain -> Presentation
Domain -> Infrastructure
Domain -> SwiftUI
Domain -> UIKit
Domain -> APIClient
Domain -> Persistence implementation
Application -> SwiftUI
View -> APIClient
View -> RepositoryImpl
ViewModel -> RepositoryImpl
```

## Review Checklist

- Repository protocols live inward of implementations.
- Concrete implementations are wired at the Composition Root.
- Async errors propagate as domain/application errors before becoming UI messages.
- Test doubles can be injected without touching production infrastructure.
