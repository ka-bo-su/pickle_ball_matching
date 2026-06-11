import SwiftUI

struct OperationBoardShareSection: View {
    @ObservedObject var viewModel: OperationBoardViewModel

    var body: some View {
        Section("共有") {
            csvShareButton
            pdfShareButton
            imageShareButton
            if viewModel.currentRound == nil {
                Label("ラウンド生成後に共有できます", systemImage: "info.circle")
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var csvShareButton: some View {
        if let csvText = viewModel.currentRoundCSV {
            ShareLink(
                item: csvText,
                subject: Text("\(viewModel.session.name) ラウンドCSV"),
                message: Text("現在ラウンドの組み合わせCSVです。")
            ) {
                Label("CSV共有", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("現在ラウンドをCSVで共有")
        }
    }

    @ViewBuilder
    private var pdfShareButton: some View {
        if let pdfDocument = viewModel.currentRoundPDFDocument {
            ShareLink(
                item: pdfDocument,
                preview: SharePreview(
                    pdfDocument.fileName,
                    image: Image(systemName: "doc.richtext")
                )
            ) {
                Label("PDF共有", systemImage: "doc.richtext")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("現在ラウンドをPDFで共有")
        }
    }

    @ViewBuilder
    private var imageShareButton: some View {
        if let imageDocument = viewModel.currentRoundImageDocument {
            ShareLink(
                item: imageDocument,
                preview: SharePreview(
                    imageDocument.fileName,
                    image: Image(systemName: "photo")
                )
            ) {
                Label("画像共有", systemImage: "photo")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .accessibilityLabel("現在ラウンドを画像で共有")
        }
    }
}
