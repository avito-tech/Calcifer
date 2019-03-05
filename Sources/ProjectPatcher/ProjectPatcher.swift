import Foundation
import PathKit
import xcodeproj

final class ProjectPatcher {
    
    init() {}
    
    func patch(projectPath: String, outputPath: String, targets: [String]) throws {
        let path = Path(projectPath)
        let xcodeproject = try XcodeProj(path: path)
        let pbxproj = xcodeproject.pbxproj
        let project = try pbxproj.rootProject()
        let agregateTarget = PBXAggregateTarget(name: "Aggregate")
        var targetsForRemoving = [String]()
        let podsGroup = project?.mainGroup.group(named: "Pods")
        let developmentPodsGroup = project?.mainGroup.group(named: "Development Pods")
        project?.targets.enumerated().forEach({ index, target in
            if targets.contains(target.name) {
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
        })
        targetsForRemoving.forEach { targetName in
            if let index = project?.targets.firstIndex(where: { $0.name == targetName }) {
                if let targetGroup = podsGroup?.group(named: targetName) {
                    pbxproj.delete(object: targetGroup)
                }
                if let targetGroup = developmentPodsGroup?.group(named: targetName) {
                    pbxproj.delete(object: targetGroup)
                }
                project?.targets.remove(at: index)
            }
        }
        pbxproj.add(object: agregateTarget)
        project?.targets.append(agregateTarget)
        try xcodeproject.write(path: Path(outputPath))
    }
    
}
