import Foundation
@testable import XcodeProj
import PathKit

// Copy from tuist/xcodeproj/Tests/xcodeprojTests/Objects
extension PBXProj {
    static func fixture(rootObject: PBXProject? = PBXProject.fixture(),
                        objectVersion: UInt = Xcode.LastKnown.objectVersion,
                        archiveVersion: UInt = Xcode.LastKnown.archiveVersion,
                        classes: [String: Any] = [:],
                        objects: [PBXObject] = []) -> PBXProj {
        return PBXProj(rootObject: rootObject,
                       objectVersion: objectVersion,
                       archiveVersion: archiveVersion,
                       classes: classes,
                       objects: objects)
    }
}

extension PBXProject {
    static func fixture(name: String = "test",
                        buildConfigurationList: XCConfigurationList = XCConfigurationList.fixture(),
                        compatibilityVersion: String = Xcode.Default.compatibilityVersion,
                        mainGroup: PBXGroup = PBXGroup.fixture()) -> PBXProject {
        return PBXProject(name: name,
                          buildConfigurationList: buildConfigurationList,
                          compatibilityVersion: compatibilityVersion,
                          mainGroup: mainGroup)
    }
}

extension PBXTarget {
    static func fixture(name: String = "Test",
                        buildConfigurationList: XCConfigurationList = XCConfigurationList.fixture(),
                        buildPhases: [PBXBuildPhase] = [],
                        buildRules: [PBXBuildRule] = [],
                        dependencies: [PBXTargetDependency] = [],
                        productName: String? = "Test",
                        product: PBXFileReference = PBXFileReference.fixture(name: "Test.app"),
                        productType: PBXProductType = PBXProductType.application) -> PBXTarget {
        return PBXTarget(name: name,
                         buildConfigurationList: buildConfigurationList,
                         buildPhases: buildPhases,
                         buildRules: buildRules,
                         dependencies: dependencies,
                         productName: productName,
                         product: product,
                         productType: productType)
    }
}

extension PBXSourcesBuildPhase {
    static func fixture(files: [PBXBuildFile] = []) -> PBXSourcesBuildPhase {
        return PBXSourcesBuildPhase(files: files,
                                    inputFileListPaths: nil,
                                    outputFileListPaths: nil,
                                    buildActionMask: PBXBuildPhase.defaultBuildActionMask,
                                    runOnlyForDeploymentPostprocessing: false)
    }
}

extension XCBuildConfiguration {
    static func fixture(name: String = "Debug") -> XCBuildConfiguration {
        return XCBuildConfiguration(name: name)
    }
}

extension XCConfigurationList {
    static func fixture(buildConfigurations: [XCBuildConfiguration] = [XCBuildConfiguration.fixture(name: "Debug"),
                                                                       XCBuildConfiguration.fixture(name: "Release")],
                        defaultConfigurationName: String? = "Debug",
                        defaultConfigurationIsVisible _: Bool = true) -> XCConfigurationList {
        return XCConfigurationList(buildConfigurations: buildConfigurations,
                                   defaultConfigurationName: defaultConfigurationName)
    }
}

extension PBXFileReference {
    static func fixture(sourceTree _: PBXSourceTree = .group,
                        name: String? = "Test") -> PBXFileReference {
        return PBXFileReference(sourceTree: .group, name: name)
    }
}

extension PBXGroup {
    static func fixture(children _: [PBXFileElement] = [],
                        sourceTree: PBXSourceTree = .group,
                        name: String = "test") -> PBXGroup {
        return PBXGroup(children: [],
                        sourceTree: sourceTree,
                        name: name)
    }
}

extension XCVersionGroup {
    static func fixture(objects: PBXObjects,
                        currentVersion: PBXFileReference? = PBXFileReference(name: "currentVersion"),
                        path: String = "path",
                        name: String? = "name",
                        sourceTree: PBXSourceTree = .group,
                        versionGroupType: String = "versionGroupType",
                        children: [PBXFileReference] = [PBXFileReference(name: "currentVersion")]) -> XCVersionGroup {
        let group = XCVersionGroup(currentVersion: currentVersion,
                                   path: path,
                                   name: name,
                                   sourceTree: sourceTree,
                                   versionGroupType: versionGroupType,
                                   children: children)
        if let currentVersion = currentVersion {
            objects.add(object: currentVersion)
        }
        children.forEach({ objects.add(object: $0) })
        objects.add(object: group)
        return group
    }
}
