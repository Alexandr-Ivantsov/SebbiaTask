// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Moya": .framework,
        "Router": .framework,
        "Stevia": .framework,
        "Factory": .framework,
        "RxSwift": .framework,
        "CacheManagerWithoutKeychain": .framework
    ]
)
#endif

let package = Package(
    name: "SebbiaTask",
    products: [
        .library(name: "SebbiaTask", targets: ["SebbiaTask"])
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3")),
        .package(url: "https://github.com/freshOS/Stevia.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.5.3")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.8.0")),
        .package(url: "https://github.com/Alexandr-Ivantsov/Router.git", .upToNextMajor(from: "1.0.3")),
        .package(url: "https://github.com/Alexandr-Ivantsov/CacheManagerWithoutKeychain.git", .upToNextMajor(from: "1.0.2"))
    ],
    targets: [
        .target(name: "SebbiaTask",
                dependencies: [
                    "RxSwift",
                    .product(name: "RxCocoa", package: "RxSwift"),
                    .product(name: "RxRelay", package: "RxSwift")
                ])
    ]
)

