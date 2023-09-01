// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GFMarkdown",
    platforms: [.macOS(.v13)],
    products: [
        .library(
            name: "GFMarkdown",
            targets: ["GFMarkdown"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-cmark.git", branch: "gfm"),
    ],
    targets: [
        .target(
            name: "CMarkGFMPlus",
            dependencies: [
                .product(name: "cmark-gfm", package: "swift-cmark"),
                .product(name: "cmark-gfm-extensions", package: "swift-cmark"),
            ]
        ),
        .target(
            name: "GFMarkdown",
            dependencies: [
                "CMarkGFMPlus"
            ]),
        .testTarget(
            name: "GFMarkdownTests",
            dependencies: ["GFMarkdown"]),
    ]
)
