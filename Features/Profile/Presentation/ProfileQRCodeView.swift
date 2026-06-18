import SwiftUI
import UIKit

struct ProfileQRCodeView: View {
    let qrCodeImage: CGImage

    @State private var previousBrightness: CGFloat = 0

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(decorative: qrCodeImage, scale: 1)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding(32)
                .accessibilityLabel("プロフィールQRコード")

            Text("このQRコードを幹事にスキャンしてもらってください")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)

            Spacer()
        }
        .navigationTitle("QRコード")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            previousBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIScreen.main.brightness = previousBrightness
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
