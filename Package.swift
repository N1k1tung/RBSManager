
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "RBSManager",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "RBSManager",
            targets: ["RBSManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/N1k1tung/CombineStarscream.git", branch: "main"),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", from: "4.2.0")
    ],
    targets: [
        .target(
            name: "RBSManager",
            dependencies: ["CombineStarscream", "ObjectMapper"],
            path: "RBSManager",
            sources: ["Classes"])
    ]
)
