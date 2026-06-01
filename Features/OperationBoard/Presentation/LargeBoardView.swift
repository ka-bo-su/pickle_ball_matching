import SwiftUI

struct LargeBoardView: View {
    @ObservedObject var viewModel: OperationBoardViewModel

    var body: some View {
        Group {
            if let model = viewModel.largeBoardDisplayModel {
                board(model)
            } else {
                ContentUnavailableView(
                    "表示するラウンドがありません",
                    systemImage: "display",
                    description: Text("参加者を追加し、次ラウンドを生成すると大画面ボードに表示されます。")
                )
                .accessibilityLabel("表示するラウンドがありません。次ラウンドを生成してください。")
            }
        }
        .navigationTitle("大画面ボード")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func board(_ model: LargeBoardDisplayModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header(model)

                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(model.courts) { court in
                        courtCard(court)
                    }
                }

                waitingSection(model)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 300), spacing: 16, alignment: .top)
        ]
    }

    private func header(_ model: LargeBoardDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.sessionName)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(model.roundTitle)
                .font(.largeTitle.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Label(model.announcement, systemImage: "megaphone")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(model.sessionName)、\(model.roundTitle)、\(model.announcement)")
    }

    private func courtCard(_ court: LargeBoardCourtDisplay) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Label(court.courtTitle, systemImage: "sportscourt")
                .font(.title.weight(.bold))

            HStack(alignment: .top, spacing: 16) {
                largeTeamColumn(title: "チームA", names: court.teamAPlayerNames)
                Text("vs")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.secondary)
                    .padding(.top, 34)
                    .accessibilityHidden(true)
                largeTeamColumn(title: "チームB", names: court.teamBPlayerNames)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(court.accessibilityLabel)
    }

    private func largeTeamColumn(title: String, names: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            ForEach(names, id: \.self) { name in
                Text(name)
                    .font(.title.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func waitingSection(_ model: LargeBoardDisplayModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(
                model.waitingTitle,
                systemImage: model.waitingPlayerNames.isEmpty ? "checkmark.circle" : "person.2.slash"
            )
            .font(.title2.weight(.bold))
            Text(model.waitingSummary)
                .font(.title3.weight(.semibold))
                .foregroundStyle(model.waitingPlayerNames.isEmpty ? .secondary : .primary)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(model.waitingTitle)、\(model.waitingSummary)")
    }
}
