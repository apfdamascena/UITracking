// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UITracking",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "UITracking",
            targets: ["UITracking"] 
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.2"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        .target(
            name: "UITracking",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift")
            ]
        ),
        .testTarget(
            name: "UITrackingTests",
            dependencies: [
                "UITracking",
                .product(name: "RxTest", package: "RxSwift"),
                .product(name: "RxBlocking", package: "RxSwift")
            ]
        ),
    ]
)
