import CoreTransferable
import Foundation
import UniformTypeIdentifiers

struct RoundImageDocument: Transferable {
    var fileName: String
    var data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { document in
            document.data
        }
        .suggestedFileName { document in
            document.fileName
        }
    }
}
