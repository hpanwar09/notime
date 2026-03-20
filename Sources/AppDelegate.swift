import Cocoa
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: WidgetPanel!
    private let fixedHeight: CGFloat = 300

    func applicationDidFinishLaunching(_ notification: Notification) {
        let hosting = NSHostingView(rootView: TimeRemainingView())

        window = WidgetPanel(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: fixedHeight),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        window.contentView = hosting
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.isMovableByWindowBackground = true
        window.hidesOnDeactivate = false
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.minSize = NSSize(width: 240, height: fixedHeight)
        window.maxSize = NSSize(width: 600, height: fixedHeight)

        updateWindowLevel()

        window.setFrameAutosaveName("notime")
        if UserDefaults.standard.object(forKey: "NSWindow Frame notime") == nil {
            positionBottomRight()
        }

        window.orderFrontRegardless()

        let nc = NotificationCenter.default
        nc.addObserver(forName: .init("notime.windowLevel"), object: nil, queue: .main) { [weak self] _ in
            self?.updateWindowLevel()
        }
        nc.addObserver(forName: .init("notime.resetFrame"), object: nil, queue: .main) { [weak self] _ in
            self?.resetFrame()
        }
        nc.addObserver(forName: .init("notime.resetSize"), object: nil, queue: .main) { [weak self] _ in
            self?.resetSize()
        }
        nc.addObserver(forName: .init("notime.setWidth"), object: nil, queue: .main) { [weak self] note in
            guard let self = self, let w = note.object as? CGFloat else { return }
            let origin = self.window.frame.origin
            self.window.setFrame(NSRect(x: origin.x, y: origin.y, width: w, height: self.fixedHeight), display: true)
        }
    }

    private func updateWindowLevel() {
        let onTop = UserDefaults.standard.bool(forKey: "alwaysOnTop")
        window.level = onTop
            ? .floating
            : NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.normalWindow)) - 1)
    }

    private func positionBottomRight() {
        guard let screen = NSScreen.main else { return }
        let visible = screen.visibleFrame
        let size = window.frame.size
        window.setFrameOrigin(NSPoint(
            x: visible.maxX - size.width - 20,
            y: visible.minY + 20
        ))
    }

    private func resetFrame() {
        positionBottomRight()
    }

    private func resetSize() {
        let origin = window.frame.origin
        window.setFrame(NSRect(x: origin.x, y: origin.y, width: 320, height: fixedHeight), display: true)
    }
}
