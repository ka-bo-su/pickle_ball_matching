@testable import PickleBallMatchingCore
import XCTest

final class JSONMemberProfileRepositoryTests: XCTestCase {
    private var tempDirectory: URL!
    private var repository: JSONMemberProfileRepository!

    override func setUp() {
        super.setUp()
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(
            at: tempDirectory,
            withIntermediateDirectories: true
        )
        repository = JSONMemberProfileRepository(directoryURL: tempDirectory)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }

    func testLoadReturnsNilWhenNoFile() throws {
        let loaded = try repository.loadProfile()
        XCTAssertNil(loaded)
    }

    func testSaveAndLoadRoundTrip() throws {
        let profile = MemberProfile(
            displayName: "田中太郎",
            phoneticName: "タナカタロウ",
            skillLevel: .intermediate,
            gender: .male,
            ageGroup: .thirties,
            memo: "左利き"
        )

        try repository.save(profile)
        let loaded = try repository.loadProfile()

        XCTAssertEqual(loaded, profile)
    }

    func testOverwriteExistingProfile() throws {
        let original = MemberProfile(
            displayName: "初期名",
            skillLevel: .beginner
        )
        try repository.save(original)

        let updated = MemberProfile(
            id: original.id,
            displayName: "更新名",
            skillLevel: .advanced,
            gender: .female,
            ageGroup: .twenties,
            memo: "更新済み"
        )
        try repository.save(updated)

        let loaded = try repository.loadProfile()
        XCTAssertEqual(loaded, updated)
        XCTAssertEqual(loaded?.displayName, "更新名")
    }

    func testSaveCreatesDirectoryIfNeeded() throws {
        let nestedDir = tempDirectory.appendingPathComponent("nested/deep", isDirectory: true)
        let repo = JSONMemberProfileRepository(directoryURL: nestedDir)

        let profile = MemberProfile(displayName: "テスト", skillLevel: .novice)
        try repo.save(profile)

        let loaded = try repo.loadProfile()
        XCTAssertEqual(loaded, profile)
    }

    func testLoadThrowsOnCorruptedJSON() throws {
        let filePath = tempDirectory.appendingPathComponent("member-profile.json")
        try try XCTUnwrap("{ invalid json".data(using: .utf8)?.write(to: filePath))

        XCTAssertThrowsError(try repository.loadProfile())
    }
}
