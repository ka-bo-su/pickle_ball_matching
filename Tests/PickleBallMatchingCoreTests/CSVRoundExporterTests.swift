import PickleBallMatchingCore
import XCTest

final class CSVRoundExporterTests: XCTestCase {
    func testExportCSVIncludesRoundMatchesAndWaiters() {
        let exporter = CSVRoundExporter()
        let session = Session(name: "月曜初心者会")
        let round = Round(
            number: 2,
            matches: [
                Match(
                    courtNumber: 1,
                    teamA: DoublesTeam(players: [
                        Participant(displayName: "佐藤"),
                        Participant(displayName: "鈴木")
                    ]),
                    teamB: DoublesTeam(players: [
                        Participant(displayName: "高橋"),
                        Participant(displayName: "田中")
                    ])
                )
            ],
            waitingParticipants: [
                Participant(displayName: "伊藤"),
                Participant(displayName: "渡辺")
            ]
        )

        let csv = exporter.exportCSV(session: session, round: round)

        XCTAssertTrue(csv.contains("セッション,月曜初心者会"))
        XCTAssertTrue(csv.contains("ラウンド,2"))
        XCTAssertTrue(csv.contains("2,1,佐藤 / 鈴木,高橋 / 田中,伊藤 / 渡辺"))
    }

    func testExportCSVEscapesCommaQuoteAndNewline() {
        let exporter = CSVRoundExporter()
        let session = Session(name: "体験会, 午前")
        let round = Round(
            number: 1,
            matches: [
                Match(
                    courtNumber: 1,
                    teamA: DoublesTeam(players: [
                        Participant(displayName: "山田,太郎"),
                        Participant(displayName: "佐藤\"花子")
                    ]),
                    teamB: DoublesTeam(players: [
                        Participant(displayName: "改行\n名前"),
                        Participant(displayName: "鈴木")
                    ])
                )
            ],
            waitingParticipants: []
        )

        let csv = exporter.exportCSV(session: session, round: round)

        XCTAssertTrue(csv.contains("\"体験会, 午前\""))
        XCTAssertTrue(csv.contains("\"山田,太郎 / 佐藤\"\"花子\""))
        XCTAssertTrue(csv.contains("\"改行\n名前 / 鈴木\""))
    }
}
