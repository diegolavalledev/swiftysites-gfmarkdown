// swift-tools-version:5.5
import PackageDescription

let ARTIFACT_FRAGMENT = ".build/artifacts/GFMarkdown"
let ARTIFACT_FRAGMENT_LOWERCASE = ".build/artifacts/gfmarkdown"

let package = Package(
    name: "GFMarkdown",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "GFMarkdown",
            targets: ["GFMarkdown"]),
    ],
    targets: [
        .binaryTarget(name: "cmark-gfm",
            url: "https://github.com/swiftysites/gfmarkdown/releases/download/1.0.0/cmark-gfm.xcframework.zip", checksum: "f61664009f3fe1f3b88100a7a886682043ab7a234167bf579068472fe4472bec"
            //path: "cmark-gfm.xcframework"
        ),
        .binaryTarget(name: "cmark-gfm-extensions",
            url: "https://github.com/swiftysites/gfmarkdown/releases/download/1.0.0/cmark-gfm-extensions.xcframework.zip", checksum: "97f674f4622bae79498ba835295d7dfa33b1de2989f29db0d0c17ec339ac0149"
            //path: "cmark-gfm-extensions.xcframework"
        ),
        .target(
            name: "CMarkGFMPlus",
            dependencies: ["cmark-gfm", "cmark-gfm-extensions"]
            ,
            cSettings: [
                .unsafeFlags([
                    "-I\(ARTIFACT_FRAGMENT)/cmark-gfm.xcframework/linux-x86_64/Headers",
                    "-I\(ARTIFACT_FRAGMENT_LOWERCASE)/cmark-gfm.xcframework/linux-x86_64/Headers",
                ], .when(platforms: [.linux]))
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-L ../../\(ARTIFACT_FRAGMENT)/cmark-gfm.xcframework/linux-x86_64",
                    "-L ../../\(ARTIFACT_FRAGMENT_LOWERCASE)/cmark-gfm.xcframework/linux-x86_64"
                    ], .when(platforms: [.linux])),
                .unsafeFlags([
                    "-L ../../\(ARTIFACT_FRAGMENT)/cmark-gfm-extensions.xcframework/linux-x86_64",
                    "-L ../../\(ARTIFACT_FRAGMENT_LOWERCASE)/cmark-gfm-extensions.xcframework/linux-x86_64",
                    ], .when(platforms: [.linux])),

                // Library `cmark-gfm-extensions` needs to be first in order
                .linkedLibrary(
                    "cmark-gfm-extensions", .when(platforms: [.linux])
                ),
                .linkedLibrary("cmark-gfm", .when(platforms: [.linux]))
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
