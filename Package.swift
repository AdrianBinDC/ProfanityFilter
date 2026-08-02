// swift-tools-version: 6.3
import PackageDescription

let package = Package(
  name: "ProfanityFilter",
  platforms: [
    // Synchronization.Mutex requires Swift 6 stdlib / modern OS floors.
    .iOS(.v18),
    .macOS(.v15),
    .tvOS(.v18),
    .watchOS(.v11),
    .visionOS(.v2),
  ],
  products: [
    .library(
      name: "ProfanityFilter",
      targets: ["ProfanityFilter"],
    ),
  ],
  targets: [
    .target(
      name: "ProfanityFilter",
      resources: [
        .process("Resources"),
      ],
      swiftSettings: [
        .swiftLanguageMode(.v6),
      ],
    ),
    .testTarget(
      name: "ProfanityFilterTests",
      dependencies: ["ProfanityFilter"],
      swiftSettings: [
        .swiftLanguageMode(.v6),
      ],
    ),
  ],
)
