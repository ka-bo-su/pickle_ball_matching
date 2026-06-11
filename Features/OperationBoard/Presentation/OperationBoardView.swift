import PickleBallMatchingCore
import SwiftUI

struct OperationBoardView: View {
    @StateObject private var viewModel: OperationBoardViewModel
    @AppStorage("operationBoardShowsSessionSettings") private var showsSessionSettings = false
    @AppStorage("operationBoardShowsRuleSettings") private var showsRuleSettings = false
    @AppStorage("operationBoardShowsTimerControls") private var showsTimerControls = true
    @AppStorage("operationBoardShowsScoreControls") private var showsScoreControls = false
    @AppStorage("operationBoardShowsShareOptions") private var showsShareOptions = false
    @AppStorage("operationBoardShowsRoundHistory") private var showsRoundHistory = false

    init(viewModel: OperationBoardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                boardSummarySection
                actionSection
                CurrentRoundSection(viewModel: viewModel, showsScoreControls: showsScoreControls)
                participantSection
                OperationBoardDisplayOptionsSection(
                    showsTimerControls: $showsTimerControls,
                    showsScoreControls: $showsScoreControls,
                    showsSessionSettings: $showsSessionSettings,
                    showsRuleSettings: $showsRuleSettings,
                    showsShareOptions: $showsShareOptions,
                    showsRoundHistory: $showsRoundHistory
                )

                if showsTimerControls {
                    RoundTimingSection(viewModel: viewModel)
                }

                if showsSessionSettings {
                    sessionSection
                }

                if showsRuleSettings {
                    ruleSettingsSection
                }

                if showsShareOptions {
                    OperationBoardShareSection(viewModel: viewModel)
                }

                if showsRoundHistory {
                    RoundHistorySection(viewModel: viewModel)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("運営ボード")
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
        OperationBoardSummarySection(summary: viewModel.boardSummaryModel)
    }

    private var actionSection: some View {
        Section("よく使う操作") {
            generateRoundButton
            if viewModel.canUndo {
                undoButton
            }
            largeBoardLink
            errorMessageView
        }
    }

    private var generateRoundButton: some View {
        Button {
            viewModel.generateNextRound()
        } label: {
            Label("次ラウンドを作る", systemImage: "shuffle")
                .font(.title3.weight(.bold))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!viewModel.canGenerateRound)
        .accessibilityLabel("次ラウンドを生成")
        .accessibilityHint("参加者、待機者、コート数に合わせて次の組み合わせを作ります")
    }

    private var undoButton: some View {
        Button {
            viewModel.undoLastChange()
        } label: {
            Label(viewModel.undoButtonTitle, systemImage: "arrow.uturn.backward")
                .font(.body.weight(.semibold))
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .disabled(!viewModel.canUndo)
        .accessibilityLabel(viewModel.undoButtonAccessibilityLabel)
    }

    private var largeBoardLink: some View {
        NavigationLink {
            LargeBoardView(viewModel: viewModel)
        } label: {
            Label("大画面表示", systemImage: "display")
                .font(.body.weight(.semibold))
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .accessibilityLabel("参加者向け大画面ボードを表示")
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
