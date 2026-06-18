import Foundation

public protocol RoundImageExporting: Sendable {
    func exportPNG(session: Session, round: Round) -> Data
}
