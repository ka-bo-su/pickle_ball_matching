import CoreGraphics
import PickleBallMatchingCore
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            Form {
                profileFormSection
                if viewModel.hasSavedProfile {
                    qrCodeSection
                }
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("マイプロフィール")
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .top, spacing: 0) {
                if viewModel.showSaveSuccess {
                    Label("保存しました", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(.green)
                        .foregroundStyle(.white)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation { viewModel.showSaveSuccess = false }
                            }
                        }
                }
            }
            .animation(.easeInOut, value: viewModel.showSaveSuccess)
        }
    }

    private var profileFormSection: some View {
        Section("基本情報") {
            TextField("名前（必須）", text: $viewModel.displayName)
                .textInputAutocapitalization(.never)
                .accessibilityLabel("表示名")

            TextField("ふりがな", text: $viewModel.phoneticName)
                .textInputAutocapitalization(.never)
                .accessibilityLabel("ふりがな")

            Picker("レベル", selection: $viewModel.skillLevel) {
                ForEach(SkillLevel.allCases, id: \.self) { level in
                    Text(level.displayName).tag(level)
                }
            }
            .accessibilityLabel("スキルレベル")

            Picker("性別", selection: $viewModel.gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.displayName).tag(gender)
                }
            }
            .accessibilityLabel("性別")

            Picker("年代", selection: $viewModel.ageGroup) {
                ForEach(AgeGroup.allCases, id: \.self) { ageGroup in
                    Text(ageGroup.displayName).tag(ageGroup)
                }
            }
            .accessibilityLabel("年代")

            TextField("メモ", text: $viewModel.memo, axis: .vertical)
                .lineLimit(2 ... 4)
                .accessibilityLabel("メモ")

            Button {
                viewModel.saveProfile()
            } label: {
                Label(
                    viewModel.hasSavedProfile ? "プロフィールを更新" : "プロフィールを保存",
                    systemImage: "checkmark.circle.fill"
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(!viewModel.canSave)
            .accessibilityLabel(viewModel.hasSavedProfile ? "プロフィールを更新" : "プロフィールを保存")
            .accessibilityHint("入力した情報をプロフィールとして保存します")
        }
    }

    private var qrCodeSection: some View {
        Section("QRコード") {
            if let cgImage = viewModel.qrCodeImage {
                VStack(spacing: 12) {
                    Image(decorative: cgImage, scale: 1)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 240, maxHeight: 240)
                        .accessibilityLabel("プロフィールQRコード")

                    Text("このQRコードを幹事に読み取ってもらうと\n参加者として追加されます")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    NavigationLink {
                        ProfileQRCodeView(qrCodeImage: cgImage)
                    } label: {
                        Label("QRコードを大きく表示", systemImage: "qrcode")
                    }
                    .accessibilityHint("スキャンしやすいよう全画面でQRコードを表示します")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
}
