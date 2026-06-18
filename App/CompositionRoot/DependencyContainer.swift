import Foundation
import PickleBallMatchingCore

@MainActor
struct DependencyContainer {
    let operationBoardViewModel: OperationBoardViewModel
    let profileViewModel: ProfileViewModel

    static func live() -> DependencyContainer {
        DependencyContainer(
            operationBoardViewModel: OperationBoardViewModel(
                generateNextRoundUseCase: GenerateNextRoundUseCase(),
                sessionRepository: makeSessionRepository(),
                roundExporter: CSVRoundExporter(),
                pdfExporter: PDFRoundExporter(),
                imageExporter: ImageRoundExporter()
            ),
            profileViewModel: ProfileViewModel(
                profileRepository: makeProfileRepository()
            )
        )
    }

    private static func makeSessionRepository() -> JSONSessionRepository {
        let directory = appSupportDirectory()
        return JSONSessionRepository(directoryURL: directory)
    }

    private static func makeProfileRepository() -> JSONMemberProfileRepository {
        let directory = appSupportDirectory()
        return JSONMemberProfileRepository(directoryURL: directory)
    }

    private static func appSupportDirectory() -> URL {
        let baseDirectory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        return baseDirectory.appendingPathComponent("PickleBallMatching", isDirectory: true)
    }
}
