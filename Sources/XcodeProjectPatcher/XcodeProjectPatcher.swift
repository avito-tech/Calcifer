import Foundation
import PathKit
import xcodeproj

public final class XcodeProjectPatcher {
    
    public init() {}
    
    public func patch(projectPath: String, outputPath: String, targets: [String]) throws {
        let path = Path(projectPath)
        let xcodeproject = try XcodeProj(path: path)
        let pbxproj = xcodeproject.pbxproj
        guard let project = try pbxproj.rootProject() else { return }
        patchBuildSetting(in: project.buildConfigurationList)
        let agregateTarget = PBXAggregateTarget(
            name: "Aggregate",
            buildConfigurationList: project.buildConfigurationList
        )
        patchBuildSetting(in: agregateTarget.buildConfigurationList)
        var targetsForRemoving = [String]()

        project.targets.enumerated().forEach { index, target in
            if targets.contains(target.name) {
                patchBuildSetting(in: target.buildConfigurationList)
                let dependency = PBXTargetDependency(
                    name: target.name,
                    target: target,
                    targetProxy: nil
                )
                pbxproj.add(object: dependency)
                agregateTarget.dependencies.append(dependency)
            } else {
                targetsForRemoving.append(target.name)
            }
        }
        targetsForRemoving.forEach { targetName in
            if let index = project.targets.firstIndex(where: { $0.name == targetName }) {
                // This is necessary because of an error about duplication of heders
                // (One inside the framework, the other in the source).
                // Perhaps this can be corrected in another way.
                let target = project.targets[index]
                for buildPhase in target.buildPhases {
                    pbxproj.delete(object: buildPhase)
                }
                removeGroup(for: target, pbxproj: pbxproj, project: project)
                if let product = target.product {
                    pbxproj.delete(object: product)
                }

                project.targets.remove(at: index)
            }
        }
        pbxproj.add(object: agregateTarget)
        project.targets.append(agregateTarget)
        try xcodeproject.write(path: Path(outputPath))
    }
    
    private func removeGroup(for target: PBXTarget, pbxproj: PBXProj, project: PBXProject) {
        let podsGroup = project.mainGroup.group(named: "Pods")
        let developmentPodsGroup = project.mainGroup.group(named: "Development Pods")
        if let targetGroup = podsGroup?.group(named: target.name) {
            pbxproj.delete(object: targetGroup)
        }
        if let targetGroup = developmentPodsGroup?.group(named: target.name) {
            pbxproj.delete(object: targetGroup)
        }
        if let productName = target.productName {
            if let targetGroup = podsGroup?.group(named: productName) {
                pbxproj.delete(object: targetGroup)
            }
            if let targetGroup = developmentPodsGroup?.group(named: productName) {
                pbxproj.delete(object: targetGroup)
            }
        }
        if let productName = target.product?.name {
            if let productGroup = project.productsGroup?.group(named: productName) {
                pbxproj.delete(object: productGroup)
            }
        }
    }
    
    func patchBuildSetting(in buildConfigurationList: XCConfigurationList?) {
        guard let buildConfigurations = buildConfigurationList?.buildConfigurations
            else { return }
        for buildConfiguration in buildConfigurations {
            for (key, value) in buildSettings() {
                buildConfiguration.buildSettings[key] = value
            }
        }
    }
    
    func buildSettings() -> BuildSettings {
        return [
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "GCC_GENERATE_DEBUGGING_SYMBOLS": "YES",
            // Можно
//            "CLANG_ENABLE_MODULE_DEBUGGING": "YES",
//            "STRIP_INSTALLED_PRODUCT": "NO",
//            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
//            "GCC_OPTIMIZATION_LEVEL": "0",
//            "STRIP_SWIFT_SYMBOLS": "NO",
//            "COPY_PHASE_STRIP": "NO",
            
            // Это не помогает
//            "GCC_PRECOMPILE_PREFIX_HEADER": "NO",
//            "SWIFT_PRECOMPILE_BRIDGING_HEADER": "NO",
//            "PRECOMPS_INCLUDE_HEADERS_FROM_BUILT_PRODUCTS_DIR": "NO",
//            "DEPLOYMENT_POSTPROCESSING": "NO",
            
            // Из за этого не билдится
//            "SWIFT_INSTALL_OBJC_HEADER": "NO",
//            "BUILD_VARIANTS": "debug"
        ]
    }
    
}
