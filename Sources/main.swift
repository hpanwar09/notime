import Cocoa

let args = CommandLine.arguments

if args.contains("--help") || args.contains("-h") {
    print("""
    notime — desktop widget showing time remaining

    Right-click the widget to quit or toggle always-on-top.
    Drag to reposition. Resize from the bottom-right corner.
    """)
    exit(0)
}

let running = NSRunningApplication.runningApplications(withBundleIdentifier: "com.notime.app")
if running.count > 1 { exit(0) }


let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
