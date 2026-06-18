import AVFoundation
import Combine
import PickleBallMatchingCore
import UIKit

@MainActor
final class QRCodeScannerViewModel: ObservableObject {
    enum CameraPermissionState {
        case notDetermined
        case authorized
        case denied
    }

    enum ScanFeedback: Equatable {
        case success(String)
        case duplicate(String)
        case invalidQR
    }

    @Published var permissionState: CameraPermissionState = .notDetermined
    @Published var scanFeedback: ScanFeedback?

    private let addParticipantUseCase = AddParticipantFromProfileUseCase()

    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            permissionState = .authorized
        case .notDetermined:
            permissionState = .notDetermined
        default:
            permissionState = .denied
        }
    }

    func requestCameraPermission() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        permissionState = granted ? .authorized : .denied
    }

    func handleScannedQRCode(_ value: String, viewModel: OperationBoardViewModel) {
        guard let payload = try? MemberProfileQRPayload.decode(from: value),
              let profile = payload.toMemberProfile()
        else {
            scanFeedback = .invalidQR
            return
        }

        do {
            let updatedSession = try addParticipantUseCase.execute(
                session: viewModel.session,
                profile: profile
            )
            viewModel.session = updatedSession
            viewModel.persistSessionMutation()
            scanFeedback = .success(profile.displayName)
        } catch is AddParticipantError {
            scanFeedback = .duplicate(profile.displayName)
        } catch {
            scanFeedback = .invalidQR
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
