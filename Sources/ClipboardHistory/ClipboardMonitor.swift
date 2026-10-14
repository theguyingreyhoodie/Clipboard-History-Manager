import AppKit
import Observation

struct ClipboardItem: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let date: Date

    init(text: String, date: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.date = date
    }
}

@Observable
final class ClipboardMonitor {
    private(set) var history: [ClipboardItem] = []
    private var lastChangeCount: Int
    private var timer: Timer?
    private let maxItems = 50
    private let defaultsKey = "clipboardHistory"

    init() {
        lastChangeCount = NSPasteboard.general.changeCount
        loadHistory()
        startMonitoring()
    }

    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkPasteboard()
        }
    }

    private func checkPasteboard() {
        let pasteboard = NSPasteboard.general
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount

        guard let text = pasteboard.string(forType: .string), !text.isEmpty else { return }
        guard text != history.first?.text else { return }

        history.removeAll { $0.text == text }
        history.insert(ClipboardItem(text: text), at: 0)
        if history.count > maxItems {
            history.removeLast(history.count - maxItems)
        }
        saveHistory()
    }

    func copyToClipboard(_ item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(item.text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }

    func clearHistory() {
        history.removeAll()
        saveHistory()
    }

    func remove(_ item: ClipboardItem) {
        history.removeAll { $0.id == item.id }
        saveHistory()
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let saved = try? JSONDecoder().decode([ClipboardItem].self, from: data) else { return }
        history = saved
    }
}
