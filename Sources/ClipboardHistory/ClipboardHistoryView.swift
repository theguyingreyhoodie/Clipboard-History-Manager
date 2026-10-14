import SwiftUI
import AppKit

struct ClipboardHistoryView: View {
    var monitor: ClipboardMonitor

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Clipboard History")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    monitor.clearHistory()
                }
                .disabled(monitor.history.isEmpty)
            }
            .padding()

            Divider()

            if monitor.history.isEmpty {
                Text("No clipboard history yet")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(monitor.history) { item in
                            ClipboardRow(item: item, monitor: monitor)
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 400)
            }

            Divider()
            Button("Quit") {
                NSApp.terminate(nil)
            }
            .padding()
        }
        .frame(width: 320)
    }
}

private struct ClipboardRow: View {
    let item: ClipboardItem
    var monitor: ClipboardMonitor

    var body: some View {
        Button {
            monitor.copyToClipboard(item)
        } label: {
            HStack {
                Text(item.text)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Spacer()
                Button {
                    monitor.remove(item)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
