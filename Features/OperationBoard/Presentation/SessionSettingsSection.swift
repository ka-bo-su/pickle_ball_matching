import PickleBallMatchingCore
import SwiftUI

struct SessionSettingsSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel
    @State private var isShowingNewSessionConfirmation = false

    var body: some View {
        Section("セッション") {
            VStack(alignment: .leading, spacing: 8) {
                TextField("セッション名", text: sessionNameBinding)
                    .textInputAutocapitalization(.never)
                    .font(.headline)
                    .accessibilityLabel("セッション名")

                Stepper(value: courtCountBinding, in: 1 ... 8) {
                    Label("\(viewModel.session.courtCount)面", systemImage: "sportscourt")
                }
                .accessibilityLabel("コート数 \(viewModel.session.courtCount)面")

                Stepper(value: roundDurationBinding, in: 1 ... 60) {
                    Label("\(viewModel.session.roundDurationMinutes)分ラウンド", systemImage: "timer")
                }
                .accessibilityLabel("ラウンド時間 \(viewModel.session.roundDurationMinutes)分")

                Picker("運営モード", selection: operationModeBinding) {
                    ForEach(OperationMode.allCases, id: \.self) { mode in
                        Text(mode.displayName)
                            .tag(mode)
                    }
                }
                .accessibilityLabel("運営モード \(viewModel.session.mode.displayName)")

                Button(role: .destructive) {
                    isShowingNewSessionConfirmation = true
                } label: {
                    Label("新規セッション", systemImage: "plus.rectangle.on.rectangle")
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("新規セッションを開始")
            }
            .confirmationDialog(
                "新規セッションを開始しますか？",
                isPresented: $isShowingNewSessionConfirmation,
                titleVisibility: .visible
            ) {
                Button("新規セッションを開始", role: .destructive) {
                    viewModel.startNewSession()
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("現在の参加者とラウンドを空にして、今日の運営を最初から始めます。")
            }
        }
    }

    private var courtCountBinding: Binding<Int> {
        Binding(
            get: { viewModel.session.courtCount },
            set: { viewModel.updateCourtCount($0) }
        )
    }

    private var sessionNameBinding: Binding<String> {
        Binding(
            get: { viewModel.session.name },
            set: { viewModel.updateSessionName($0) }
        )
    }

    private var roundDurationBinding: Binding<Int> {
        Binding(
            get: { viewModel.session.roundDurationMinutes },
            set: { viewModel.updateRoundDurationMinutes($0) }
        )
    }

    private var operationModeBinding: Binding<OperationMode> {
        Binding(
            get: { viewModel.session.mode },
            set: { viewModel.updateOperationMode($0) }
        )
    }
}
