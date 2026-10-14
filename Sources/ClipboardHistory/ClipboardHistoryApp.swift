import SwiftUI

@main
struct ClipboardHistoryApp: App {
    @State private var monitor = ClipboardMonitor()

    var body: some Scene {
        MenuBarExtra("Clipboard History", systemImage: "doc.on.clipboard") {
            ClipboardHistoryView(monitor: monitor)
        }
        .menuBarExtraStyle(.window)
    }
}
