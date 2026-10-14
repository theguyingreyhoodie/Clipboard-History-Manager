// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ClipboardHistory",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "ClipboardHistory",
            path: "Sources/ClipboardHistory"
        )
    ]
)
