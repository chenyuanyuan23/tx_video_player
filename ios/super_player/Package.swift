// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "super_player",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "super-player", targets: ["super_player"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "TXFFmpeg",
            url: "https://github.com/chenyuanyuan23/librarys/releases/download/LiteAVSDK_Player_iOS_13.1.0.20454/TXFFmpeg.xcframework.zip",
            checksum: "bbcf563422de9202741841bf72e7cae1b8456b1a21b9dc795ca8a35ab0495866"
        ),
        .binaryTarget(
            name: "TXLiteAVSDK_Player",
            url: "https://github.com/chenyuanyuan23/librarys/releases/download/LiteAVSDK_Player_iOS_13.1.0.20454/TXLiteAVSDK_Player.xcframework.zip",
            checksum: "525eeecb85c4970576e3df35d87d72b0cba9e0a7ba42630201f40f09f4eb7a28"
        ),
        .binaryTarget(
            name: "TXSoundTouch",
            url: "https://github.com/chenyuanyuan23/librarys/releases/download/LiteAVSDK_Player_iOS_13.1.0.20454/TXSoundTouch.xcframework.zip",
            checksum: "dda3f8a13456d125375a349c1c70963b2ab8818bbea294fbccb979fbb7be5728"
        ),
        .target(
            name: "super_player",
            dependencies: [
                "TXFFmpeg",
                "TXLiteAVSDK_Player",
                "TXSoundTouch"
            ],
            path: "Sources/super_player",
            resources: [
                .process("Resources")
            ],
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedFramework("MobileCoreServices"),
                .linkedFramework("VideoToolbox"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("AVFoundation")
            ]
        )
    ]
)
