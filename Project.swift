import ProjectDescription

let project = Project(
    name: "SebbiaTask",
    targets: [
        .target(
            name: "SebbiaTask",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SebbiaTask",
            //            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "Router"),
                .external(name: "RxMoya"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxRelay"),
                .external(name: "Stevia"),
                .external(name: "Factory"),
                .external(name: "CacheManagerWithoutKeychain")
            ]
        ),
        .target(
            name: "SebbiaTaskTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.SebbiaTaskTests",
            //            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "SebbiaTask")]
        )
    ]
)


