// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FocusPersonCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(name: "FocusPersonCore", targets: ["FocusPersonCore"]),
        .executable(name: "FocusPersonDemo", targets: ["FocusPersonDemo"])
    ],
    targets: [
        .target(name: "FocusPersonCore"),
        .executableTarget(name: "FocusPersonDemo", dependencies: ["FocusPersonCore"]),
        .testTarget(name: "FocusPersonCoreTests", dependencies: ["FocusPersonCore"])
    ]
)
