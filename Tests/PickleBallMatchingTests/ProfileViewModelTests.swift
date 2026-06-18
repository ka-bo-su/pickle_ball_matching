@testable import PickleBallMatching
@testable import PickleBallMatchingCore
import XCTest

final class FakeMemberProfileRepository: MemberProfileRepository, @unchecked Sendable {
    var storedProfile: MemberProfile?
    var saveError: Error?

    func loadProfile() throws -> MemberProfile? {
        storedProfile
    }

    func save(_ profile: MemberProfile) throws {
        if let saveError { throw saveError }
        storedProfile = profile
    }
}

@MainActor
final class ProfileViewModelTests: XCTestCase {
    func testInitWithNoProfile() {
        let repo = FakeMemberProfileRepository()
        let vm = ProfileViewModel(profileRepository: repo)

        XCTAssertEqual(vm.displayName, "")
        XCTAssertEqual(vm.phoneticName, "")
        XCTAssertEqual(vm.skillLevel, .beginner)
        XCTAssertFalse(vm.hasSavedProfile)
        XCTAssertNil(vm.qrCodeImage)
    }

    func testInitLoadsExistingProfile() {
        let repo = FakeMemberProfileRepository()
        repo.storedProfile = MemberProfile(
            displayName: "田中太郎",
            phoneticName: "タナカタロウ",
            skillLevel: .intermediate,
            gender: .male,
            ageGroup: .thirties,
            memo: "テスト"
        )

        let vm = ProfileViewModel(profileRepository: repo)

        XCTAssertEqual(vm.displayName, "田中太郎")
        XCTAssertEqual(vm.phoneticName, "タナカタロウ")
        XCTAssertEqual(vm.skillLevel, .intermediate)
        XCTAssertEqual(vm.gender, .male)
        XCTAssertEqual(vm.ageGroup, .thirties)
        XCTAssertEqual(vm.memo, "テスト")
        XCTAssertTrue(vm.hasSavedProfile)
        XCTAssertNotNil(vm.qrCodeImage)
    }

    func testCanSaveRequiresNonEmptyName() {
        let repo = FakeMemberProfileRepository()
        let vm = ProfileViewModel(profileRepository: repo)

        XCTAssertFalse(vm.canSave)

        vm.displayName = "   "
        XCTAssertFalse(vm.canSave)

        vm.displayName = "テスト"
        XCTAssertTrue(vm.canSave)
    }

    func testSaveProfilePersists() {
        let repo = FakeMemberProfileRepository()
        let vm = ProfileViewModel(profileRepository: repo)

        vm.displayName = "佐藤花子"
        vm.skillLevel = .advanced
        vm.saveProfile()

        XCTAssertTrue(vm.hasSavedProfile)
        XCTAssertNotNil(vm.qrCodeImage)
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(repo.storedProfile?.displayName, "佐藤花子")
        XCTAssertEqual(repo.storedProfile?.skillLevel, .advanced)
    }

    func testSavePreservesIDOnUpdate() {
        let repo = FakeMemberProfileRepository()
        let vm = ProfileViewModel(profileRepository: repo)

        vm.displayName = "初期名"
        vm.saveProfile()
        let firstID = repo.storedProfile?.id

        vm.displayName = "更新名"
        vm.saveProfile()
        let secondID = repo.storedProfile?.id

        XCTAssertEqual(firstID, secondID)
    }

    func testSaveErrorSetsErrorMessage() {
        let repo = FakeMemberProfileRepository()
        repo.saveError = NSError(domain: "test", code: 1)
        let vm = ProfileViewModel(profileRepository: repo)

        vm.displayName = "テスト"
        vm.saveProfile()

        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.hasSavedProfile)
    }
}
