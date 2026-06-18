# Dependency Injection Policy

Use initializer injection and small composition roots.

## Rules

- Prefer protocols at application/domain boundaries.
- Construct concrete repositories, API clients, persistence, and use cases in `App/CompositionRoot`.
- Do not introduce global mutable state for feature dependencies.
- Avoid singleton services unless an Apple framework requires it and a wrapper/protocol keeps tests isolated.
- Test fakes should be simple and colocated with tests unless shared across many tests.

## Current Composition Root

`App/CompositionRoot/DependencyContainer.swift` wires:

- `PlayerProfile`
- `InMemoryMatchingRepository`
- `LoadMatchCandidatesUseCase`
