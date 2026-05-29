// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Toasty",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "Toasty", targets: ["Toasty"])
    ],
    targets: [
        .target(name: "Toasty"),
        .testTarget(name: "ToastyTests", dependencies: ["Toasty"])
    ]
)

let version = "1.2.0"
