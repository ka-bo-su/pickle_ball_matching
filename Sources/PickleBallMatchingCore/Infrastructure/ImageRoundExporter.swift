import CoreGraphics
import CoreText
import Foundation
import ImageIO

public struct ImageRoundExporter: RoundImageExporting {
    public init() {}

    public func exportPNG(session: Session, round: Round) -> Data {
        let imageSize = imageSize(for: round)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(imageSize.width),
            height: Int(imageSize.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return Data()
        }

        drawBackground(context: context, size: imageSize)
        drawHeader(session: session, round: round, context: context, imageHeight: imageSize.height)

        let contentWidth = imageSize.width - (Layout.margin * 2)
        var cursorY = Layout.headerHeight
        for match in round.matches {
            drawMatch(
                match,
                context: context,
                imageHeight: imageSize.height,
                rect: CGRect(x: Layout.margin, y: cursorY, width: contentWidth, height: Layout.matchHeight)
            )
            cursorY += Layout.matchHeight + Layout.gap
        }

        if !round.waitingParticipants.isEmpty {
            drawWaitingParticipants(
                round.waitingParticipants,
                context: context,
                imageHeight: imageSize.height,
                rect: CGRect(x: Layout.margin, y: cursorY, width: contentWidth, height: Layout.waitingHeight)
            )
        }

        guard let image = context.makeImage() else {
            return Data()
        }

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil) else {
            return Data()
        }

        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else {
            return Data()
        }
        return data as Data
    }

    private func imageSize(for round: Round) -> CGSize {
        let matchArea = CGFloat(round.matches.count) * (Layout.matchHeight + Layout.gap)
        let waitingArea = round.waitingParticipants.isEmpty ? 0 : Layout.waitingHeight + Layout.gap
        let height = max(Layout.minimumHeight, Layout.headerHeight + matchArea + waitingArea + Layout.margin)
        return CGSize(width: Layout.width, height: height)
    }

    private func drawBackground(context: CGContext, size: CGSize) {
        context.setFillColor(Palette.background)
        context.fill(CGRect(origin: .zero, size: size))
    }

    private func drawHeader(
        session: Session,
        round: Round,
        context: CGContext,
        imageHeight: CGFloat
    ) {
        drawText(
            session.name,
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: Layout.margin, y: 48, width: Layout.width - (Layout.margin * 2), height: 62),
            fontSize: 46,
            isBold: true
        )
        drawText(
            "ラウンド\(round.number)  現在の試合と待機者",
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: Layout.margin, y: 112, width: Layout.width - (Layout.margin * 2), height: 38),
            fontSize: 26
        )
    }

    private func drawMatch(
        _ match: Match,
        context: CGContext,
        imageHeight: CGFloat,
        rect: CGRect
    ) {
        drawFilledRect(rect, context: context, imageHeight: imageHeight, color: Palette.cardBackground)
        drawStrokeRect(rect, context: context, imageHeight: imageHeight, color: Palette.border, lineWidth: 3)

        drawText(
            "コート\(match.courtNumber)",
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.minX + 28, y: rect.minY + 20, width: 180, height: 42),
            fontSize: 30,
            isBold: true
        )

        let teamY = rect.minY + 70
        let teamWidth = (rect.width - 160) / 2
        drawTeam(
            title: "チームA",
            names: match.teamA.players.map(\.displayName),
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.minX + 28, y: teamY, width: teamWidth, height: 72)
        )
        drawText(
            "vs",
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.midX - 28, y: teamY + 14, width: 56, height: 42),
            fontSize: 28,
            isBold: true
        )
        drawTeam(
            title: "チームB",
            names: match.teamB.players.map(\.displayName),
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.midX + 52, y: teamY, width: teamWidth, height: 72)
        )
    }

    private func drawTeam(
        title: String,
        names: [String],
        context: CGContext,
        imageHeight: CGFloat,
        rect: CGRect
    ) {
        drawText(
            title,
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: 28),
            fontSize: 18
        )
        drawText(
            names.joined(separator: " / "),
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.minX, y: rect.minY + 30, width: rect.width, height: 42),
            fontSize: 30,
            isBold: true
        )
    }

    private func drawWaitingParticipants(
        _ participants: [Participant],
        context: CGContext,
        imageHeight: CGFloat,
        rect: CGRect
    ) {
        drawFilledRect(rect, context: context, imageHeight: imageHeight, color: Palette.waitingBackground)
        drawStrokeRect(rect, context: context, imageHeight: imageHeight, color: Palette.border, lineWidth: 3)
        drawText(
            "待機者",
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.minX + 28, y: rect.minY + 22, width: 160, height: 36),
            fontSize: 28,
            isBold: true
        )
        drawText(
            participants.map(\.displayName).joined(separator: "、"),
            context: context,
            imageHeight: imageHeight,
            rect: CGRect(x: rect.minX + 28, y: rect.minY + 68, width: rect.width - 56, height: rect.height - 82),
            fontSize: 28
        )
    }

    private func drawText(
        _ text: String,
        context: CGContext,
        imageHeight: CGFloat,
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
        let path = CGPath(rect: bitmapRect(rect, imageHeight: imageHeight), transform: nil)
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
        imageHeight: CGFloat,
        color: CGColor
    ) {
        context.setFillColor(color)
        context.fill(bitmapRect(rect, imageHeight: imageHeight))
    }

    private func drawStrokeRect(
        _ rect: CGRect,
        context: CGContext,
        imageHeight: CGFloat,
        color: CGColor,
        lineWidth: CGFloat
    ) {
        context.setStrokeColor(color)
        context.setLineWidth(lineWidth)
        context.stroke(bitmapRect(rect, imageHeight: imageHeight))
    }

    private func bitmapRect(_ rect: CGRect, imageHeight: CGFloat) -> CGRect {
        CGRect(x: rect.minX, y: imageHeight - rect.maxY, width: rect.width, height: rect.height)
    }
}

private enum Layout {
    static let width: CGFloat = 1600
    static let minimumHeight: CGFloat = 1000
    static let margin: CGFloat = 64
    static let headerHeight: CGFloat = 180
    static let matchHeight: CGFloat = 156
    static let waitingHeight: CGFloat = 140
    static let gap: CGFloat = 22
}

private enum Palette {
    static let text = CGColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1)
    static let background = CGColor(red: 0.96, green: 0.98, blue: 0.97, alpha: 1)
    static let border = CGColor(red: 0.73, green: 0.78, blue: 0.82, alpha: 1)
    static let cardBackground = CGColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)
    static let waitingBackground = CGColor(red: 0.90, green: 0.97, blue: 0.93, alpha: 1)
}
