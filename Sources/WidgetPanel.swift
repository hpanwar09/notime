import Cocoa
import SwiftUI

final class WidgetPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

final class ResizeHandleNSView: NSView {
    private var dragStart: NSPoint = .zero
    private var startFrame: NSRect = .zero

    override var mouseDownCanMoveWindow: Bool { false }

    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .resizeLeftRight)
    }

    override func mouseDown(with event: NSEvent) {
        dragStart = NSEvent.mouseLocation
        startFrame = window?.frame ?? .zero
    }

    override func mouseDragged(with event: NSEvent) {
        guard let window = window else { return }
        let dx = NSEvent.mouseLocation.x - dragStart.x

        var w = startFrame.width + dx
        w = min(max(w, window.minSize.width), window.maxSize.width)

        window.setFrame(NSRect(
            x: startFrame.origin.x,
            y: startFrame.origin.y,
            width: w,
            height: startFrame.height
        ), display: true)
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        ctx.setStrokeColor(NSColor.white.withAlphaComponent(0.15).cgColor)
        ctx.setLineWidth(1)
        for i in stride(from: 3 as CGFloat, through: 11, by: 4) {
            ctx.move(to: CGPoint(x: bounds.maxX, y: bounds.maxY - i))
            ctx.addLine(to: CGPoint(x: bounds.maxX - i, y: bounds.maxY))
        }
        ctx.strokePath()
    }
}

struct ResizeHandle: NSViewRepresentable {
    func makeNSView(context: Context) -> ResizeHandleNSView {
        let v = ResizeHandleNSView()
        v.setFrameSize(NSSize(width: 20, height: 20))
        return v
    }
    func updateNSView(_ nsView: ResizeHandleNSView, context: Context) {}
}
