import PickleBallMatchingCore
import SwiftUI

struct SessionSettingsSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel
    @State private var isShowingNewSessionConfirmation = false
    @State private var deletionCandidateID: Session.ID?

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

                if !viewModel.savedSessionsForReopen.isEmpty {
                    Menu {
                        Section("再開") {
                            ForEach(viewModel.savedSessionsForReopen) { savedSession in
                                Button {
                                    viewModel.reopenSession(sessionID: savedSession.id)
                                } label: {
                                    Text(viewModel.savedSessionTitle(savedSession))
                                }
                            }
                        }

                        Section("削除") {
                            ForEach(viewModel.savedSessionsForReopen) { savedSession in
                                Button(role: .destructive) {
                                    deletionCandidateID = savedSession.id
                                } label: {
                                    Label(
                                        viewModel.savedSessionTitle(savedSession),
                                        systemImage: "trash"
                                    )
                                }
                            }
                        }
                    } label: {
                        Label("過去セッションを再開", systemImage: "clock.arrow.circlepath")
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("過去セッションを再開")
                }

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
                Button("名簿を引き継いで開始") {
                    viewModel.startNewSessionKeepingRoster()
                }
                Button("完全に空で開始", role: .destructive) {
                    viewModel.startNewSession()
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("前回の参加者名簿を残すか、参加者も含めて空にするか選べます。")
            }
            .confirmationDialog(
                "保存済みセッションを削除しますか？",
                isPresented: deletionConfirmationBinding,
                titleVisibility: .visible
            ) {
                Button("削除", role: .destructive) {
                    if let deletionCandidateID {
                        viewModel.deleteSavedSession(sessionID: deletionCandidateID)
                    }
                    deletionCandidateID = nil
                }
                Button("キャンセル", role: .cancel) {
                    deletionCandidateID = nil
                }
            } message: {
                Text("現在のセッションは削除されません。削除した履歴は過去セッション一覧から非表示になります。")
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

    private var deletionConfirmationBinding: Binding<Bool> {
        Binding(
            get: { deletionCandidateID != nil },
            set: { isPresented in
                if !isPresented {
                    deletionCandidateID = nil
                }
            }
        )
    }
}
