// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "SnapshotFileKit",
    platforms: [.macOS(.v13)],
    products: [.library(name: "SnapshotFileKit", targets: ["SnapshotFileKit"])],
    targets: [
        .target(name: "SnapshotFileKit"),
        .testTarget(name: "SnapshotFileKitTests", dependencies: ["SnapshotFileKit"])
    ]
)
