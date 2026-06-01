import CoreGraphics
import PickleBallMatchingCore
import XCTest

final class PDFRoundExporterTests: XCTestCase {
    func testExportPDFCreatesReadablePDFDocument() throws {
        let exporter = PDFRoundExporter()
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

        let pdfData = exporter.exportPDF(session: session, round: round)

        XCTAssertEqual(String(data: pdfData.prefix(4), encoding: .ascii), "%PDF")
        let provider = try XCTUnwrap(CGDataProvider(data: pdfData as CFData))
        let document = try XCTUnwrap(CGPDFDocument(provider))
        XCTAssertEqual(document.numberOfPages, 1)
        XCTAssertGreaterThan(pdfData.count, 1000)
    }

    func testExportPDFAddsPagesWhenCourtsDoNotFitOnePage() throws {
        let exporter = PDFRoundExporter()
        let participants = makeParticipants(count: 40)
        var matches: [Match] = []
        for (index, offset) in stride(from: 0, to: 40, by: 4).enumerated() {
            let match = Match(
                courtNumber: index + 1,
                teamA: DoublesTeam(players: [participants[offset], participants[offset + 1]]),
                teamB: DoublesTeam(players: [participants[offset + 2], participants[offset + 3]])
            )
            matches.append(match)
        }
        let round = Round(number: 1, matches: matches, waitingParticipants: [])
        let session = Session(name: "大人数練習", courtCount: matches.count, participants: participants, rounds: [round])

        let pdfData = exporter.exportPDF(session: session, round: round)

        let provider = try XCTUnwrap(CGDataProvider(data: pdfData as CFData))
        let document = try XCTUnwrap(CGPDFDocument(provider))
        XCTAssertGreaterThan(document.numberOfPages, 1)
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
