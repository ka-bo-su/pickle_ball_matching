# Sprint Backlog

## Sprint Goal

Create the first inspectable autonomous Codex iOS development increment: Codex operating docs/config plus a testable SwiftPM core and XcodeGen app shell.

## Selected Work

| ID | Type | Status | Owner Role | Validation | Evidence |
|---|---|---|---|---|---|
| SBI-001 | Codex文書・設定・subagent・runbook作成 | In Review | scrum-master | docs review, preflight | PR #8 |
| SBI-002 | GitHub Project fields・labels・templates整備 | In Review | scrum-master | gh field/label commands | PR #8, Issues #1-#7 |
| SBI-003 | SwiftPM Clean Architecture core bootstrap | In Review | swift-developer | `swift test` passed | PR #8 |
| SBI-004 | XcodeGen最小SwiftUI app shell | In Review | swift-developer | `xcodegen generate`, `xcodebuild build` passed | PR #8 |

## Plan

1. Create Codex docs/config/subagents.
2. Migrate legacy Claude docs.
3. Create Project labels/fields/issues. Done.
4. Validate SwiftPM core. Done.
5. Generate and validate Xcode project. Done.
6. Commit, PR, update Project evidence. Done.
7. Squash merge to `dev`, set Project items Done, continue.
