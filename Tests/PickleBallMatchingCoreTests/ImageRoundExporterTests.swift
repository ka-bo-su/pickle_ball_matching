import CoreGraphics
import ImageIO
import PickleBallMatchingCore
import XCTest

final class ImageRoundExporterTests: XCTestCase {
    func testExportPNGCreatesReadableImage() throws {
        let exporter = ImageRoundExporter()
        let participants = makeParticipants(count: 5)
        let round = Round(
            number: 1,
            matches: [
                Match(
                    courtNumber: 1,
                    teamA: DoublesTeam(players: [participants[0], participants[1]]),
                    teamB: DoublesTeam(players: [participants[2], participants[3]])
                )
            ],
            waitingParticipants: [participants[4]]
        )
        let session = Session(name: "初心者体験会", courtCount: 1, participants: participants, rounds: [round])

        let pngData = exporter.exportPNG(session: session, round: round)

        XCTAssertEqual(Array(pngData.prefix(8)), [137, 80, 78, 71, 13, 10, 26, 10])
        let source = try XCTUnwrap(CGImageSourceCreateWithData(pngData as CFData, nil))
        let image = try XCTUnwrap(CGImageSourceCreateImageAtIndex(source, 0, nil))
        XCTAssertEqual(image.width, 1600)
        XCTAssertGreaterThanOrEqual(image.height, 1000)
    }

    func testExportPNGExpandsHeightForManyCourts() throws {
        let exporter = ImageRoundExporter()
        let participants = makeParticipants(count: 24)
        var matches: [Match] = []
        for (index, offset) in stride(from: 0, to: 24, by: 4).enumerated() {
            matches.append(
                Match(
                    courtNumber: index + 1,
                    teamA: DoublesTeam(players: [participants[offset], participants[offset + 1]]),
                    teamB: DoublesTeam(players: [participants[offset + 2], participants[offset + 3]])
                )
            )
        }
        let round = Round(number: 1, matches: matches, waitingParticipants: [])
        let session = Session(name: "大人数練習", courtCount: matches.count, participants: participants, rounds: [round])

        let pngData = exporter.exportPNG(session: session, round: round)

        let source = try XCTUnwrap(CGImageSourceCreateWithData(pngData as CFData, nil))
        let image = try XCTUnwrap(CGImageSourceCreateImageAtIndex(source, 0, nil))
        XCTAssertGreaterThan(image.height, 1000)
    }

    private func makeParticipants(count: Int) -> [Participant] {
        (1 ... count).map { index in
            Participant(
                id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", index))!,
                displayName: "参加者\(index)",
                skillLevel: SkillLevel(rawValue: (index % 4) + 1) ?? .beginner
            )
        }
    }
}
