# Scrum Operating Model

This repository applies ScrumExpansion.org's emphasis on transparency, inspection, adaptation, Product Goal, Product Backlog, Sprint Goal, Sprint Backlog, and validated Increments to autonomous Codex development.

References used for this operating model:

- [Scrum Guide Expansion Pack](https://scrumexpansion.org/scrum-guide-expansion-pack/)
- [Scrum Guide Expanded 2026.1 PDF](https://scrumexpansion.org/scrum-guide-expanded/2026.1/pdf/scrum-guide-expanded.2026.1.en.pdf)

Codex does not run synchronous human events. Instead, it reflects Scrum inspection/adaptation through GitHub Project items, Issues, PRs, docs, validation evidence, audit logs, Sprint Review logs, and Retrospective logs.

## Product Goal

Deliver a maintainable iOS Swift app foundation for pickleball matching that can grow through small vertical slices.

## Product Backlog

The ordered source of product work. GitHub Project `kanban@pickle_ball_matching` is the operational source of truth; `docs/scrum/product-backlog.md` mirrors it.

## PBI / SBI / Task / Bug / Chore

- PBI: larger user or technical outcome.
- SBI: small Sprint-sized work item that can produce an inspectable Increment.
- Task: implementation step inside an SBI.
- Bug: behavior defect.
- Chore: development infrastructure, docs, cleanup, configuration.

## Sprint Backlog

Contains the Sprint Goal, selected SBIs, and the plan for producing increments. It is updated throughout the run as Codex learns more.

## Increment

An Increment is a working, verified, integrated result that meets Definition of Done. For this repository, even docs/config/tooling increments must be auditable and validated.

## Sprint Review

Recorded in `docs/scrum/sprint-review-log.md` with evidence links, validation, open risks, and Project/PR references.

## Retrospective

Recorded in `docs/scrum/retrospective-log.md` with improvements to autonomy, validation, architecture, and Project sync.

## Role Mapping

| Scrum accountability | Codex subagent |
|---|---|
| Product Owner | product-owner |
| Scrum Master | scrum-master |
| Developers | swift-developer |
| Quality review | reviewer |
| Architecture review | architect-reviewer |
| Release readiness | release-reviewer |

## Sync Rule

Project updates happen first when possible. Docs are updated as the local readable ledger. Failed Project updates are recorded as pending updates.
