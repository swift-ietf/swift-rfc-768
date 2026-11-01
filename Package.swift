// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-rfc-768",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "RFC 768", targets: ["RFC 768"]),
        .library(
            name: "RFC 768 Standard Library Integration",
            targets: ["RFC 768 Standard Library Integration"]
        ),
        .library(
            name: "RFC 768 Foundation Integration",
            targets: ["RFC 768 Foundation Integration"]
        ),
    ],
    traits: [
        .trait(name: "Coder", description: "Wire coders for RFC 768 types")
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(
            url: "https://github.com/swift-ietf/swift-rfc-791.git",
            branch: "main",
            traits: ["Coder"]
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-binary.git",
            branch: "main",
            traits: [
                .trait(name: "LEB128", condition: .when(traits: ["Coder"])),
                .trait(name: "Serializer", condition: .when(traits: ["Coder"])),
            ]
        ),
        .package(url: "https://github.com/swift-atoms/swift-coder.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cursor.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-parser.git",
            branch: "main",
            traits: [
                .trait(name: "Append", condition: .when(traits: ["Coder"])),
                .trait(name: "Either", condition: .when(traits: ["Coder"])),
                .trait(name: "Iterator", condition: .when(traits: ["Coder"])),
                .trait(name: "IteratorLeaves", condition: .when(traits: ["Coder"])),
                .trait(name: "Map", condition: .when(traits: ["Coder"])),
                .trait(name: "Product", condition: .when(traits: ["Coder"])),
                .trait(name: "Skip", condition: .when(traits: ["Coder"])),
            ]
        ),
        .package(url: "https://github.com/swift-atoms/swift-serializer.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "RFC 768",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "RFC 791", package: "swift-rfc-791"),
                .product(name: "Coder", package: "swift-coder", condition: .when(traits: ["Coder"])),
                .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Coder"])),
                .product(name: "Parser", package: "swift-parser", condition: .when(traits: ["Coder"])),
                .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Coder"])),
                .product(name: "Binary", package: "swift-binary", condition: .when(traits: ["Coder"])),
            ]
        ),
        .target(
            name: "RFC 768 Standard Library Integration",
            dependencies: [
                .target(name: "RFC 768"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .target(
            name: "RFC 768 Foundation Integration",
            dependencies: [
                .target(name: "RFC 768")
            ]
        ),
        .testTarget(
            name: "RFC 768 Tests",
            dependencies: [
                .target(name: "RFC 768"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "RFC 791", package: "swift-rfc-791"),
                .product(name: "Coder", package: "swift-coder", condition: .when(traits: ["Coder"])),
                .product(name: "Cursor", package: "swift-cursor", condition: .when(traits: ["Coder"])),
                .product(name: "Parser", package: "swift-parser", condition: .when(traits: ["Coder"])),
                .product(name: "Serializer", package: "swift-serializer", condition: .when(traits: ["Coder"])),
                .product(name: "Binary", package: "swift-binary", condition: .when(traits: ["Coder"])),
            ]
        ),
        .testTarget(
            name: "RFC 768 Standard Library Integration Tests",
            dependencies: [
                .target(name: "RFC 768"),
                .target(name: "RFC 768 Standard Library Integration"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .testTarget(
            name: "RFC 768 Foundation Integration Tests",
            dependencies: [
                .target(name: "RFC 768"),
                .target(name: "RFC 768 Foundation Integration"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
