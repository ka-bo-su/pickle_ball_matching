# Sprint Backlog

## Sprint Goal

Create the first inspectable autonomous Codex iOS development increment: Codex operating docs/config plus a testable SwiftPM core and XcodeGen app shell.

## Selected Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-001 | Codex文書・設定・subagent・runbook作成 | In Progress | scrum-master | docs review, preflight | pending PR |
| SBI-002 | GitHub Project fields・labels・templates整備 | In Progress | scrum-master | gh field/label commands | Issues #1-#7 and Project fields |
| SBI-003 | SwiftPM Clean Architecture core bootstrap | In Progress | swift-developer | `swift test` passed | `Sources/`, `Tests/` |
| SBI-004 | XcodeGen最小SwiftUI app shell | In Progress | swift-developer | `xcodegen generate`, `xcodebuild build` passed | `project.yml`, `App/`, `Features/` |

## Plan

1. Create Codex docs/config/subagents.
2. Migrate legacy Claude docs.
3. Create Project labels/fields/issues. Done.
4. Validate SwiftPM core. Done.
5. Generate and validate Xcode project. Done.
6. Commit, PR, update Project evidence, continue.
