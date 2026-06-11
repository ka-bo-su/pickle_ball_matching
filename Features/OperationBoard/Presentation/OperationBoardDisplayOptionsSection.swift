import SwiftUI

struct OperationBoardDisplayOptionsSection: View {
    @Binding var showsTimerControls: Bool
    @Binding var showsScoreControls: Bool
    @Binding var showsSessionSettings: Bool
    @Binding var showsRuleSettings: Bool
    @Binding var showsShareOptions: Bool
    @Binding var showsRoundHistory: Bool

    var body: some View {
        Section("表示設定") {
            displayToggle(
                title: "タイマー操作",
                detail: "試合開始・終了と残り時間を操作するときだけ表示します。",
                systemImage: "timer",
                isOn: $showsTimerControls
            )
            displayToggle(
                title: "スコア入力",
                detail: "必要な試合だけスコアを入力したいときに表示します。",
                systemImage: "number.circle",
                isOn: $showsScoreControls
            )
            displayToggle(
                title: "セッション設定",
                detail: "コート数、時間、運営モードを変えるときに表示します。",
                systemImage: "slider.horizontal.3",
                isOn: $showsSessionSettings
            )
            displayToggle(
                title: "詳細ルール",
                detail: "同ペア回避やレベル差などの条件を調整するときに表示します。",
                systemImage: "checklist",
                isOn: $showsRuleSettings
            )
            displayToggle(
                title: "共有",
                detail: "CSV、PDF、画像を書き出すときに表示します。",
                systemImage: "square.and.arrow.up",
                isOn: $showsShareOptions
            )
            displayToggle(
                title: "履歴",
                detail: "過去ラウンドを確認するときに表示します。",
                systemImage: "clock.arrow.circlepath",
                isOn: $showsRoundHistory
            )
        }
    }

    private func displayToggle(
        title: String,
        detail: String,
        systemImage: String,
        isOn: Binding<Bool>
    ) -> some View {
        Toggle(isOn: isOn) {
            Label {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.semibold))
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
            }
        }
        .toggleStyle(.switch)
        .accessibilityLabel(title)
        .accessibilityHint(detail)
    }
}
