import CoreTransferable
import Foundation
import UniformTypeIdentifiers

struct RoundPDFDocument: Transferable {
    var fileName: String
    var data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .pdf) { document in
            document.data
        }
        .suggestedFileName { document in
            document.fileName
        }
    }
}
