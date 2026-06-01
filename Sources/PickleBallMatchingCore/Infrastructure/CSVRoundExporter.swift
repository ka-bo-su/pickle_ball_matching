public struct CSVRoundExporter: RoundExporting {
    public init() {}

    public func exportCSV(session: Session, round: Round) -> String {
        var rows = [
            ["セッション", session.name],
            ["ラウンド", "\(round.number)"],
            [],
            ["ラウンド", "コート", "チームA", "チームB", "待機者"]
        ]

        let waitingNames = round.waitingParticipants
            .map(\.displayName)
            .joined(separator: " / ")

        rows += round.matches.map { match in
            [
                "\(round.number)",
                "\(match.courtNumber)",
                match.teamA.players.map(\.displayName).joined(separator: " / "),
                match.teamB.players.map(\.displayName).joined(separator: " / "),
                waitingNames
            ]
        }

        if round.matches.isEmpty, !round.waitingParticipants.isEmpty {
            rows.append(["\(round.number)", "", "", "", waitingNames])
        }

        return rows.map(csvLine).joined(separator: "\n")
    }

    private func csvLine(_ fields: [String]) -> String {
        fields.map(escape).joined(separator: ",")
    }

    private func escape(_ field: String) -> String {
        let needsQuoting = field.contains(",") || field.contains("\"") || field.contains("\n")
        guard needsQuoting else {
            return field
        }

        return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
}
