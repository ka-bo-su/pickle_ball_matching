import SwiftUI

struct OperationBoardSummarySection: View {
    let summary: OperationBoardSummaryModel

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                Label(summary.statusTitle, systemImage: "rectangle.and.text.magnifyingglass")
                    .font(.title3.weight(.bold))

                Text(summary.statusDetail)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 10) {
                    summaryLine(title: "参加者", value: summary.participantSummary, systemImage: "person.3")
                    summaryLine(title: "コート", value: summary.courtSummary, systemImage: "sportscourt")
                    summaryLine(title: "待機", value: summary.waitingSummary, systemImage: "person.2.slash")
                }

                if let proPlanNotice = summary.proPlanNotice {
                    Label(proPlanNotice, systemImage: "star.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    Text(summary.nextActionTitle)
                        .font(.headline)
                    Text(summary.nextActionDetail)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.vertical, 8)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(summary.accessibilityLabel)
        } header: {
            Text("現在状態")
        } footer: {
            Text("普段見る情報だけを上に集めています。細かい設定や共有は「表示設定」から出せます。")
        }
    }

    private func summaryLine(title: String, value: String, systemImage: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 88, alignment: .leading)

            Text(value)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
