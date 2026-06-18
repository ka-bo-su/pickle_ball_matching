import SwiftUI

struct QRCodeScannerSheet: View {
    @ObservedObject var viewModel: OperationBoardViewModel
    @StateObject private var scannerViewModel = QRCodeScannerViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                scannerContent
                feedbackOverlay
            }
            .navigationTitle("QRコードスキャン")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
            .task {
                scannerViewModel.checkCameraPermission()
                if scannerViewModel.permissionState == .notDetermined {
                    await scannerViewModel.requestCameraPermission()
                }
            }
        }
    }

    @ViewBuilder
    private var scannerContent: some View {
        switch scannerViewModel.permissionState {
        case .authorized:
            QRCodeScannerView { scannedValue in
                scannerViewModel.handleScannedQRCode(scannedValue, viewModel: viewModel)
            }
            .ignoresSafeArea()
        case .denied:
            VStack(spacing: 16) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                Text("カメラへのアクセスが許可されていません")
                    .font(.headline)
                Text("設定アプリからカメラの使用を許可してください")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("設定を開く") {
                    scannerViewModel.openSettings()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        case .notDetermined:
            ProgressView("カメラの許可を確認中...")
        }
    }

    @ViewBuilder
    private var feedbackOverlay: some View {
        if let feedback = scannerViewModel.scanFeedback {
            VStack {
                Spacer()
                feedbackBanner(for: feedback)
                    .padding()
                    .padding(.bottom, 40)
            }
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: scannerViewModel.scanFeedback)
            .task {
                try? await Task.sleep(for: .seconds(2))
                scannerViewModel.scanFeedback = nil
            }
        }
    }

    private func feedbackBanner(for feedback: QRCodeScannerViewModel.ScanFeedback) -> some View {
        HStack(spacing: 12) {
            Image(systemName: feedbackIcon(for: feedback))
                .font(.title3)
            Text(feedbackMessage(for: feedback))
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(feedbackColor(for: feedback).opacity(0.9))
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }

    private func feedbackIcon(for feedback: QRCodeScannerViewModel.ScanFeedback) -> String {
        switch feedback {
        case .success: "checkmark.circle.fill"
        case .duplicate: "person.fill.xmark"
        case .invalidQR: "xmark.circle.fill"
        }
    }

    private func feedbackMessage(for feedback: QRCodeScannerViewModel.ScanFeedback) -> String {
        switch feedback {
        case let .success(name): "\(name)を追加しました"
        case let .duplicate(name): "\(name)はすでに追加済みです"
        case .invalidQR: "無効なQRコードです"
        }
    }

    private func feedbackColor(for feedback: QRCodeScannerViewModel.ScanFeedback) -> Color {
        switch feedback {
        case .success: .green
        case .duplicate: .orange
        case .invalidQR: .red
        }
    }
}
