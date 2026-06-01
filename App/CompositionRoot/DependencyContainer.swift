import Foundation
import PickleBallMatchingCore

@MainActor
struct DependencyContainer {
    let operationBoardViewModel: OperationBoardViewModel

    static func live() -> DependencyContainer {
        DependencyContainer(
            operationBoardViewModel: OperationBoardViewModel(
                generateNextRoundUseCase: GenerateNextRoundUseCase(),
                sessionRepository: makeSessionRepository(),
                roundExporter: CSVRoundExporter(),
                pdfExporter: PDFRoundExporter()
            )
        )
    }

    private static func makeSessionRepository() -> JSONSessionRepository {
        let baseDirectory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        let directory = baseDirectory.appendingPathComponent("PickleBallMatching", isDirectory: true)
        return JSONSessionRepository(directoryURL: directory)
    }
}
