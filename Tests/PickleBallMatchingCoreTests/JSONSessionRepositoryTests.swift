import Foundation
import PickleBallMatchingCore
import XCTest

final class JSONSessionRepositoryTests: XCTestCase {
    private var directoryURL: URL!

    override func setUpWithError() throws {
        directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("PickleBallMatchingTests-\(UUID().uuidString)", isDirectory: true)
    }

    override func tearDownWithError() throws {
        if let directoryURL, FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.removeItem(at: directoryURL)
        }
        directoryURL = nil
    }

    func testSaveAndLoadLatestSessionRoundTripsJSON() throws {
        let repository = JSONSessionRepository(directoryURL: directoryURL)
        let session = makeSession()

        try repository.save(session)
        let restored = try XCTUnwrap(repository.loadLatestSession())

        XCTAssertEqual(restored, session)
    }

    func testLoadLatestSessionReturnsNilWhenFileDoesNotExist() throws {
        let repository = JSONSessionRepository(directoryURL: directoryURL)

        let restored = try repository.loadLatestSession()

        XCTAssertNil(restored)
    }

    func testLoadLatestSessionThrowsWhenJSONIsBroken() throws {
        let repository = JSONSessionRepository(directoryURL: directoryURL)
        let fileURL = directoryURL.appendingPathComponent("latest-session.json")
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        try Data("not-json".utf8).write(to: fileURL)

        XCTAssertThrowsError(try repository.loadLatestSession()) { error in
            XCTAssertEqual(error.localizedDescription, "保存済みセッションの形式が壊れています。")
        }
    }

    private func makeSession() -> Session {
        let date = Date(timeIntervalSince1970: 1_717_171_200)
        let participants = makeParticipants()
        return Session(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000301")!,
            name: "保存テスト",
            date: date,
            courtCount: 1,
            roundDurationMinutes: 12,
            mode: .normalPractice,
            participants: participants,
            ruleSet: .balancedPractice,
            rounds: [makeRound(participants: participants, date: date)],
            createdAt: date,
            updatedAt: date
        )
    }

    private func makeParticipants() -> [Participant] {
        [
            Participant(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                displayName: "佐藤",
                skillLevel: .beginner,
                waitingCount: 1
            ),
            Participant(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                displayName: "鈴木",
                skillLevel: .advanced,
                playCount: 1
            ),
            Participant(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                displayName: "高橋",
                skillLevel: .intermediate
            ),
            Participant(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                displayName: "田中",
                skillLevel: .novice
            )
        ]
    }

    private func makeRound(participants: [Participant], date: Date) -> Round {
        Round(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000101")!,
            number: 1,
            matches: [
                Match(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000201")!,
                    courtNumber: 1,
                    teamA: DoublesTeam(players: [participants[0], participants[1]]),
                    teamB: DoublesTeam(players: [participants[2], participants[3]])
                )
            ],
            waitingParticipants: [],
            createdAt: date,
            isConfirmed: true
        )
    }
}
