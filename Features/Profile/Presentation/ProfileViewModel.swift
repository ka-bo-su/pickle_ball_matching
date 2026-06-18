import CoreGraphics
import Foundation
import PickleBallMatchingCore

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName = ""
    @Published var phoneticName = ""
    @Published var skillLevel: SkillLevel = .beginner
    @Published var gender: Gender = .notSpecified
    @Published var ageGroup: AgeGroup = .notSpecified
    @Published var memo = ""
    @Published private(set) var hasSavedProfile = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var qrCodeImage: CGImage?
    @Published var showSaveSuccess = false

    private let profileRepository: any MemberProfileRepository
    private let qrCodeGenerator: QRCodeImageGenerator
    private var profileID: UUID?

    init(
        profileRepository: any MemberProfileRepository,
        qrCodeGenerator: QRCodeImageGenerator = QRCodeImageGenerator()
    ) {
        self.profileRepository = profileRepository
        self.qrCodeGenerator = qrCodeGenerator
        loadProfile()
    }

    var canSave: Bool {
        !displayName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func saveProfile() {
        let id = profileID ?? UUID()
        let profile = MemberProfile(
            id: id,
            displayName: displayName.trimmingCharacters(in: .whitespaces),
            phoneticName: phoneticName.isEmpty ? nil : phoneticName.trimmingCharacters(in: .whitespaces),
            skillLevel: skillLevel,
            gender: gender == .notSpecified ? nil : gender,
            ageGroup: ageGroup == .notSpecified ? nil : ageGroup,
            memo: memo
        )

        do {
            try profileRepository.save(profile)
            profileID = id
            hasSavedProfile = true
            errorMessage = nil
            showSaveSuccess = true
            generateQRCode(for: profile)
        } catch {
            errorMessage = "プロフィールの保存に失敗しました。"
        }
    }

    private func loadProfile() {
        do {
            guard let profile = try profileRepository.loadProfile() else { return }
            profileID = profile.id
            displayName = profile.displayName
            phoneticName = profile.phoneticName ?? ""
            skillLevel = profile.skillLevel
            gender = profile.gender ?? .notSpecified
            ageGroup = profile.ageGroup ?? .notSpecified
            memo = profile.memo
            hasSavedProfile = true
            generateQRCode(for: profile)
        } catch {
            errorMessage = "プロフィールの読み込みに失敗しました。"
        }
    }

    private func generateQRCode(for profile: MemberProfile) {
        let payload = MemberProfileQRPayload(profile: profile)
        guard let jsonString = try? payload.encodeToJSONString() else {
            qrCodeImage = nil
            return
        }
        qrCodeImage = qrCodeGenerator.generateQRCodeCGImage(from: jsonString)
    }
}
