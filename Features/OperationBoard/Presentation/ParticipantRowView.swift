import PickleBallMatchingCore
import SwiftUI

struct ParticipantRowView: View {
    let participant: Participant
    let onEdit: () -> Void
    let onToggleAttendance: () -> Void
    let onUpdateSkillLevel: (SkillLevel) -> Void
    let onUpdateStatus: (ParticipantStatus) -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            participantSummary

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    participantControls
                }

                VStack(alignment: .leading, spacing: 8) {
                    participantControls
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var participantSummary: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(participant.displayName)
                    .font(.title3.weight(.bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Text("待機 \(participant.waitingCount)")
                    .font(.callout.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.secondary.opacity(0.12), in: Capsule())
                    .accessibilityLabel("待機回数 \(participant.waitingCount)回")
            }

            Label(
                "\(participant.skillLevel.displayName)・\(participant.status.displayName)",
                systemImage: participant.status.isAvailableForRound ? "checkmark.circle" : "pause.circle"
            )
            .font(.body)
            .foregroundStyle(participant.status.isAvailableForRound ? .primary : .secondary)

            if !participantDetailSummary.isEmpty {
                Text(participantDetailSummary)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(participantAccessibilityLabel)
    }

    @ViewBuilder
    private var participantControls: some View {
        editButton
        attendanceToggleButton
        skillLevelMenu
        statusMenu
        moreMenu
    }

    private var editButton: some View {
        Button(action: onEdit) {
            Label("編集", systemImage: "pencil.circle")
        }
        .buttonStyle(.borderless)
        .controlSize(.large)
        .font(.callout.weight(.semibold))
        .accessibilityLabel("\(participant.displayName)の詳細を編集")
    }

    private var attendanceToggleButton: some View {
        Button(action: onToggleAttendance) {
            Label(attendanceToggleTitle, systemImage: attendanceToggleSystemImage)
        }
        .buttonStyle(.borderless)
        .controlSize(.large)
        .font(.callout.weight(.semibold))
        .accessibilityLabel(attendanceToggleAccessibilityLabel)
    }

    private var skillLevelMenu: some View {
        Menu {
            ForEach(SkillLevel.allCases, id: \.self) { skillLevel in
                Button {
                    onUpdateSkillLevel(skillLevel)
                } label: {
                    Label(
                        skillLevel.displayName,
                        systemImage: skillLevel == participant.skillLevel ? "checkmark" : "circle"
                    )
                }
            }
        } label: {
            Label(participant.skillLevel.displayName, systemImage: "chart.bar")
                .labelStyle(.titleAndIcon)
                .font(.callout.weight(.semibold))
        }
        .controlSize(.large)
        .accessibilityLabel("\(participant.displayName)のレベル \(participant.skillLevel.displayName)。変更")
    }

    private var statusMenu: some View {
        Menu {
            ForEach(ParticipantStatus.allCases, id: \.rawValue) { status in
                Button {
                    onUpdateStatus(status)
                } label: {
                    Label(status.displayName, systemImage: status == participant.status ? "checkmark" : "circle")
                }
            }
        } label: {
            Label(
                participant.status.displayName,
                systemImage: participant.status.isAvailableForRound ? "checkmark.circle" : "pause.circle"
            )
            .labelStyle(.titleAndIcon)
            .font(.callout.weight(.semibold))
        }
        .controlSize(.large)
        .accessibilityLabel("\(participant.displayName)の状態 \(participant.status.displayName)。変更")
    }

    private var moreMenu: some View {
        Menu {
            Button(role: .destructive, action: onDelete) {
                Label("削除", systemImage: "trash")
            }
        } label: {
            Label("その他", systemImage: "ellipsis.circle")
                .font(.callout.weight(.semibold))
        }
        .controlSize(.large)
        .accessibilityLabel("\(participant.displayName)のその他操作")
    }

    private var attendanceToggleSystemImage: String {
        if participant.status.isAvailableForRound {
            return "person.crop.circle.badge.xmark"
        }

        return "person.crop.circle.badge.checkmark"
    }

    private var attendanceToggleTitle: String {
        if participant.status.isAvailableForRound {
            return "欠席"
        }

        return "参加"
    }

    private var attendanceToggleAccessibilityLabel: String {
        if participant.status.isAvailableForRound {
            return "\(participant.displayName)を欠席にする"
        }

        return "\(participant.displayName)を参加中に戻す"
    }

    private var participantAccessibilityLabel: String {
        [
            participant.displayName,
            participant.skillLevel.displayName,
            participant.status.displayName,
            participantDetailSummary
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "、")
    }

    private var participantDetailSummary: String {
        [
            participant.gender?.displayName,
            participant.ageGroup?.displayName,
            participant.memo.isEmpty ? nil : participant.memo
        ]
        .compactMap(\.self)
        .filter { $0 != "未設定" }
        .joined(separator: "・")
    }
}
