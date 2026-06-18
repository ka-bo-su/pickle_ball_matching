import Foundation

extension OperationBoardViewModel {
    var currentRoundCSV: String? {
        guard let currentRound else {
            return nil
        }

        return roundExporter.exportCSV(session: session, round: currentRound)
    }

    var currentRoundPDFDocument: RoundPDFDocument? {
        guard let currentRound else {
            return nil
        }

        return RoundPDFDocument(
            fileName: "\(safeFileName(session.name))-round-\(currentRound.number).pdf",
            data: pdfExporter.exportPDF(session: session, round: currentRound)
        )
    }

    var currentRoundImageDocument: RoundImageDocument? {
        guard let currentRound else {
            return nil
        }

        return RoundImageDocument(
            fileName: "\(safeFileName(session.name))-round-\(currentRound.number).png",
            data: imageExporter.exportPNG(session: session, round: currentRound)
        )
    }
}

private func safeFileName(_ name: String) -> String {
    let invalidCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>:")
    let sanitized = name
        .components(separatedBy: invalidCharacters)
        .joined(separator: "-")
        .trimmingCharacters(in: .whitespacesAndNewlines)
    return sanitized.isEmpty ? "pickleball-round" : sanitized
}
