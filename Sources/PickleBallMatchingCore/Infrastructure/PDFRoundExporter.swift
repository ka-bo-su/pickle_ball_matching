import CoreGraphics
import CoreText
import Foundation

public struct PDFRoundExporter: RoundPDFExporting {
    public init() {}

    public func exportPDF(session: Session, round: Round) -> Data {
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data) else {
            return Data()
        }

        var mediaBox = CGRect(x: 0, y: 0, width: 842, height: 595)
        guard let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            return Data()
        }

        var cursorY = beginPage(context: context, mediaBox: mediaBox, session: session, round: round)
        let contentWidth = mediaBox.width - (Layout.margin * 2)

        for match in round.matches {
            if cursorY + Layout.matchHeight > mediaBox.height - Layout.margin {
                context.endPDFPage()
                cursorY = beginPage(context: context, mediaBox: mediaBox, session: session, round: round)
            }

            drawMatch(match, context: context, pageHeight: mediaBox.height, rect: CGRect(
                x: Layout.margin,
                y: cursorY,
                width: contentWidth,
                height: Layout.matchHeight
            ))
            cursorY += Layout.matchHeight + 12
        }

        if !round.waitingParticipants.isEmpty {
            if cursorY + Layout.waitingHeight > mediaBox.height - Layout.margin {
                context.endPDFPage()
                cursorY = beginPage(context: context, mediaBox: mediaBox, session: session, round: round)
            }

            drawWaitingParticipants(
                round.waitingParticipants,
                context: context,
                pageHeight: mediaBox.height,
                rect: CGRect(x: Layout.margin, y: cursorY, width: contentWidth, height: Layout.waitingHeight)
            )
        }

        context.endPDFPage()
        context.closePDF()
        return data as Data
    }

    private func beginPage(
        context: CGContext,
        mediaBox: CGRect,
        session: Session,
        round: Round
    ) -> CGFloat {
        context.beginPDFPage(nil)

        let pageHeight = mediaBox.height
        drawText(
            session.name,
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: Layout.margin, y: 28, width: mediaBox.width - (Layout.margin * 2), height: 32),
            fontSize: 24,
            isBold: true
        )
        drawText(
            "ラウンド\(round.number)",
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: Layout.margin, y: 64, width: 220, height: 24),
            fontSize: 16,
            isBold: true
        )
        drawText(
            "現在の試合と待機者",
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: Layout.margin + 130, y: 64, width: 300, height: 24),
            fontSize: 14
        )

        return 104
    }

    private func drawMatch(
        _ match: Match,
        context: CGContext,
        pageHeight: CGFloat,
        rect: CGRect
    ) {
        drawFilledRect(rect, context: context, pageHeight: pageHeight, color: Palette.cardBackground)
        drawStrokeRect(rect, context: context, pageHeight: pageHeight, color: Palette.border)

        drawText(
            "コート\(match.courtNumber)",
            context: context,
            pageHeight: pageHeight,
            rect: rect.insetBy(dx: 16, dy: 10),
            fontSize: 16,
            isBold: true
        )

        let teamY = rect.minY + 38
        let teamWidth = (rect.width - 88) / 2
        drawTeam(
            title: "チームA",
            names: match.teamA.players.map(\.displayName),
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.minX + 16, y: teamY, width: teamWidth, height: 42)
        )
        drawText(
            "vs",
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.midX - 20, y: teamY + 8, width: 40, height: 24),
            fontSize: 14,
            isBold: true
        )
        drawTeam(
            title: "チームB",
            names: match.teamB.players.map(\.displayName),
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.midX + 34, y: teamY, width: teamWidth, height: 42)
        )
    }

    private func drawTeam(
        title: String,
        names: [String],
        context: CGContext,
        pageHeight: CGFloat,
        rect: CGRect
    ) {
        drawText(
            title,
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: 16),
            fontSize: 10
        )
        drawText(
            names.joined(separator: " / "),
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.minX, y: rect.minY + 17, width: rect.width, height: 26),
            fontSize: 15,
            isBold: true
        )
    }

    private func drawWaitingParticipants(
        _ participants: [Participant],
        context: CGContext,
        pageHeight: CGFloat,
        rect: CGRect
    ) {
        drawFilledRect(rect, context: context, pageHeight: pageHeight, color: Palette.waitingBackground)
        drawStrokeRect(rect, context: context, pageHeight: pageHeight, color: Palette.border)
        drawText(
            "待機者",
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.minX + 16, y: rect.minY + 10, width: 120, height: 20),
            fontSize: 14,
            isBold: true
        )
        drawText(
            participants.map(\.displayName).joined(separator: "、"),
            context: context,
            pageHeight: pageHeight,
            rect: CGRect(x: rect.minX + 16, y: rect.minY + 34, width: rect.width - 32, height: rect.height - 44),
            fontSize: 14
        )
    }

    private func drawText(
        _ text: String,
        context: CGContext,
        pageHeight: CGFloat,
        rect: CGRect,
        fontSize: CGFloat,
        isBold: Bool = false
    ) {
        let fontType: CTFontUIFontType = isBold ? .emphasizedSystem : .system
        let font = CTFontCreateUIFontForLanguage(fontType, fontSize, "ja" as CFString)
            ?? CTFontCreateWithName("Helvetica" as CFString, fontSize, nil)
        let attributed = NSAttributedString(
            string: text,
            attributes: [
                kCTFontAttributeName as NSAttributedString.Key: font,
                kCTForegroundColorAttributeName as NSAttributedString.Key: Palette.text
            ]
        )
        let path = CGPath(rect: pdfRect(rect, pageHeight: pageHeight), transform: nil)
        let framesetter = CTFramesetterCreateWithAttributedString(attributed)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

        context.saveGState()
        context.textMatrix = .identity
        CTFrameDraw(frame, context)
        context.restoreGState()
    }

    private func drawFilledRect(
        _ rect: CGRect,
        context: CGContext,
        pageHeight: CGFloat,
        color: CGColor
    ) {
        context.setFillColor(color)
        context.fill(pdfRect(rect, pageHeight: pageHeight))
    }

    private func drawStrokeRect(
        _ rect: CGRect,
        context: CGContext,
        pageHeight: CGFloat,
        color: CGColor
    ) {
        context.setStrokeColor(color)
        context.setLineWidth(1)
        context.stroke(pdfRect(rect, pageHeight: pageHeight))
    }

    private func pdfRect(_ rect: CGRect, pageHeight: CGFloat) -> CGRect {
        CGRect(x: rect.minX, y: pageHeight - rect.maxY, width: rect.width, height: rect.height)
    }
}

private enum Layout {
    static let margin: CGFloat = 36
    static let matchHeight: CGFloat = 92
    static let waitingHeight: CGFloat = 92
}

private enum Palette {
    static let text = CGColor(gray: 0.12, alpha: 1)
    static let border = CGColor(red: 0.74, green: 0.78, blue: 0.84, alpha: 1)
    static let cardBackground = CGColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
    static let waitingBackground = CGColor(red: 0.94, green: 0.98, blue: 0.96, alpha: 1)
}
