import PickleBallMatchingCore
import SwiftUI

struct RuleSettingsSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel

    var body: some View {
        Section("ルール設定") {
            presetSummary

            ruleToggle(
                title: "待機回数をそろえる",
                detail: "休みが偏らないように、待機回数が少ない人を優先して休ませます。",
                systemImage: "person.2.slash",
                keyPath: \.balancesWaitingCount
            )

            ruleToggle(
                title: "連続待機を避ける",
                detail: "直前に休んだ人が続けて待機になりにくくします。",
                systemImage: "arrow.triangle.2.circlepath",
                keyPath: \.avoidsConsecutiveWaiting
            )

            ruleToggle(
                title: "同じペアを避ける",
                detail: "過去に組んだ相手と続けてペアになりにくくします。",
                systemImage: "person.2",
                keyPath: \.avoidsRepeatedPairs
            )

            ruleToggle(
                title: "同じ対戦相手を避ける",
                detail: "過去に対戦した相手と同じカードになりにくくします。",
                systemImage: "figure.pickleball",
                keyPath: \.avoidsRepeatedOpponents
            )

            ruleToggle(
                title: "レベル差を抑える",
                detail: "チーム間の実力差が大きくなりすぎないようにします。",
                systemImage: "scale.3d",
                keyPath: \.reducesLevelGap
            )

            ruleToggle(
                title: "初心者を保護する",
                detail: "初心者が強い人同士の試合に偏って入らないようにします。",
                systemImage: "hands.sparkles",
                keyPath: \.protectsBeginners
            )
        }
    }

    private var presetSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("現在のプリセット: \(viewModel.session.mode.displayName)", systemImage: "slider.horizontal.3")
                .font(.subheadline.weight(.semibold))

            Text(viewModel.session.mode.presetDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                viewModel.reapplyCurrentModeRulePreset()
            } label: {
                Label("プリセットを再適用", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .disabled(viewModel.session.ruleSet == viewModel.session.mode.defaultRuleSet)
            .accessibilityLabel("\(viewModel.session.mode.displayName)のルールプリセットを再適用")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "現在のプリセット \(viewModel.session.mode.displayName)。\(viewModel.session.mode.presetDescription)"
        )
    }

    private func ruleToggle(
        title: String,
        detail: String,
        systemImage: String,
        keyPath: WritableKeyPath<SessionRuleSet, Bool>
    ) -> some View {
        Toggle(isOn: ruleBinding(keyPath)) {
            VStack(alignment: .leading, spacing: 4) {
                Label(title, systemImage: systemImage)
                    .font(.subheadline.weight(.semibold))

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title)。\(detail)")
        .accessibilityValue(viewModel.session.ruleSet[keyPath: keyPath] ? "オン" : "オフ")
    }

    private func ruleBinding(_ keyPath: WritableKeyPath<SessionRuleSet, Bool>) -> Binding<Bool> {
        Binding(
            get: { viewModel.session.ruleSet[keyPath: keyPath] },
            set: { viewModel.updateRule(keyPath, isEnabled: $0) }
        )
    }
}
