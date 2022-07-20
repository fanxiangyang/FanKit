// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
//name：Swift包的名称；
//defaultLocalization：资源的默认本地化；
//platforms：支持的最低系统平台的列表；
//pkgConfig：用于C模块的名称。如果存在，Xcode将搜索.pc文件以获取系统目标所需的其他标志；
//providers：系统目标的程序包提供者；
//products：此软件包可让客户使用的产品列表；
//dependencies：软件包依赖项列表（可空，或需要其它外部依赖）；
//targets：属于此软件包的目标列表（源码目录、测试目录）；
//swiftLanguageVersions：此软件包兼容的Swift版本列表；
//cLanguageStandard：用于此程序包中所有C目标的C语言标准；
//cxxLanguageStandard：用于此程序包中所有C ++目标的C ++语言标准；
let package = Package(
    name: "FanKit",
//    defaultLocalization: "en",
//    platforms: [
//        .macOS(.v10_11),
//        .iOS(.v10),
//        .tvOS(.v10),
//        .watchOS(.v2)
//    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FanKit",
            targets: ["FanKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FanKit",
            dependencies: [],
            path: "Sources",
//            exclude: ["Info.plist"],
//            sources: ["FanKit.bundle"],
            resources: [.process("Resources/FanKit.bundle")],
            publicHeadersPath: "FanKit"
        ),
 
    ]
)
