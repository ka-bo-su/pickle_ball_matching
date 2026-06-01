import Foundation

public protocol RoundPDFExporting: Sendable {
    func exportPDF(session: Session, round: Round) -> Data
}
