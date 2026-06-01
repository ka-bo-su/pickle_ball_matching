public protocol RoundExporting: Sendable {
    func exportCSV(session: Session, round: Round) -> String
}
