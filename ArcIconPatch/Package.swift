// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ArcIconPatch",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "ArcIconPatch", targets: ["ArcIconPatch"])
    ],
    dependencies: [
        .package(url: "https://github.com/SerenaKit/PrivateKits", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "ArcIconPatch",
            dependencies: [
                .product(name: "AssetCatalogWrapper", package: "PrivateKits")
            ]
        )
    ]
)
