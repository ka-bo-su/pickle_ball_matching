import PickleBallMatchingCore
import SwiftUI

struct OperationBoardView: View {
    @StateObject private var viewModel: OperationBoardViewModel

    init(viewModel: OperationBoardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                sessionSection
                ruleSettingsSection
                boardSummarySection
                RoundTimingSection(viewModel: viewModel)
                participantSection
                actionSection
                CurrentRoundSection(viewModel: viewModel)
                RoundHistorySection(viewModel: viewModel)
            }
            .navigationTitle("当日運営ボード")
        }
    }

    private var sessionSection: some View {
        SessionSettingsSection(viewModel: viewModel)
    }

    private var ruleSettingsSection: some View {
        RuleSettingsSection(viewModel: viewModel)
    }

    private var participantSection: some View {
        ParticipantListSection(viewModel: viewModel)
    }

    private var boardSummarySection: some View {
        let summary = viewModel.boardSummaryModel
        return Section("現在状態") {
            VStack(alignment: .leading, spacing: 12) {
                Label(summary.statusTitle, systemImage: "rectangle.and.text.magnifyingglass")
                    .font(.headline)

                Text(summary.statusDetail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    summaryLine(title: "参加者", value: summary.participantSummary, systemImage: "person.3")
                    summaryLine(title: "コート", value: summary.courtSummary, systemImage: "sportscourt")
                    summaryLine(title: "待機", value: summary.waitingSummary, systemImage: "person.2.slash")
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text(summary.nextActionTitle)
                        .font(.subheadline.weight(.semibold))
                    Text(summary.nextActionDetail)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(summary.accessibilityLabel)
        }
    }

    private var actionSection: some View {
        Section {
            generateRoundButton
            undoButton
            largeBoardLink
            csvShareButton
            pdfShareButton
            imageShareButton
            errorMessageView
        }
    }

    private func summaryLine(title: String, value: String, systemImage: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 72, alignment: .leading)

            Text(value)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var generateRoundButton: some View {
        Button {
            viewModel.generateNextRound()
        } label: {
            Label("次ラウンド生成", systemImage: "shuffle")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .disabled(!viewModel.canGenerateRound)
        .accessibilityLabel("次ラウンドを生成")
    }

    private var undoButton: some View {
        Button {
            viewModel.undoLastChange()
        } label: {
            Label(viewModel.undoButtonTitle, systemImage: "arrow.uturn.backward")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .disabled(!viewModel.canUndo)
        .accessibilityLabel(viewModel.undoButtonAccessibilityLabel)
    }

    private var largeBoardLink: some View {
        NavigationLink {
            LargeBoardView(viewModel: viewModel)
        } label: {
            Label("大画面表示", systemImage: "display")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .accessibilityLabel("参加者向け大画面ボードを表示")
    }

    @ViewBuilder
    private var csvShareButton: some View {
        if let csvText = viewModel.currentRoundCSV {
            ShareLink(
                item: csvText,
                subject: Text("\(viewModel.session.name) ラウンドCSV"),
                message: Text("現在ラウンドの組み合わせCSVです。")
            ) {
                Label("CSV共有", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("現在ラウンドをCSVで共有")
        }
    }

    @ViewBuilder
    private var pdfShareButton: some View {
        if let pdfDocument = viewModel.currentRoundPDFDocument {
            ShareLink(
                item: pdfDocument,
                preview: SharePreview(
                    pdfDocument.fileName,
                    image: Image(systemName: "doc.richtext")
                )
            ) {
                Label("PDF共有", systemImage: "doc.richtext")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("現在ラウンドをPDFで共有")
        }
    }

    @ViewBuilder
    private var imageShareButton: some View {
        if let imageDocument = viewModel.currentRoundImageDocument {
            ShareLink(
                item: imageDocument,
                preview: SharePreview(
                    imageDocument.fileName,
                    image: Image(systemName: "photo")
                )
            ) {
                Label("画像共有", systemImage: "photo")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("現在ラウンドを画像で共有")
        }
    }

    @ViewBuilder
    private var errorMessageView: some View {
        if let errorMessage = viewModel.errorMessage {
            Label(errorMessage, systemImage: "exclamationmark.triangle")
                .foregroundStyle(.red)
                .accessibilityLabel(errorMessage)
        }
    }
}

#Preview {
    OperationBoardView(viewModel: OperationBoardViewModel())
}
