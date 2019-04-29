import Foundation
import PathKit
import xcodeproj

public final class BuildStepIntegrator {
    
    public init() {}
    
    public func integrate(projectPath: String, targets: [String], binaryPath: String) throws {
        let path = Path(projectPath)
        let xcodeproject = try XcodeProj(path: path)
        let pbxproj = xcodeproject.pbxproj
        guard let project = try pbxproj.rootProject() else { return }
        try project.targets.enumerated().forEach { index, target in
            if targets.contains(target.name) {
                try removePodsFramework(
                    target: target,
                    pbxproj: pbxproj
                )
                try updateCalciferBuildPhasese(
                    target: target,
                    pbxproj: pbxproj,
                    binaryPath: binaryPath
                )
            }
        }
        try xcodeproject.write(path: path)
    }
    
    private func removePodsFramework(target: PBXTarget, pbxproj: PBXProj) throws {
        if let frameworkBuildPhase = try target.frameworksBuildPhase() {
            let podsFilePath = "Pods_\(target.name).framework"
            let file = frameworkBuildPhase.files.first(where: {
                $0.file?.path == podsFilePath
            })
            if let frameworkFile = file {
                if let index = frameworkBuildPhase.files.firstIndex(of: frameworkFile) {
                    frameworkBuildPhase.files.remove(at: index)
                }
                pbxproj.delete(object: frameworkFile)
            }
        }
    }
    
    private func updateCalciferBuildPhasese(
        target: PBXTarget,
        pbxproj: PBXProj,
        binaryPath: String)
        throws
    {
        if let resourcesBuildPhase = try target.resourcesBuildPhase(),
            let resourcesBuildPhaseIndex = target.buildPhases
                .firstIndex(of: resourcesBuildPhase) {
            
            let shellScript = [
                "\(binaryPath) parseXcodeBuildEnvironmentParameters",
                "\(binaryPath) prepareRemoteCache"
                ].joined(separator: "\n")
            let phaseName = "[Calcifer] Remote Cache"
            let phaseIndex = resourcesBuildPhaseIndex - 1
            
            if let existingBuildPhase = existingCalciferBuildPhase(
                target: target,
                name: phaseName)
            {
                updateExistingCalciferBuildPhase(
                    target: target,
                    buildPhase: existingBuildPhase,
                    shellScript: shellScript,
                    expectedIndex: phaseIndex
                )
            } else {
                let shellScriptBuildPhase = PBXShellScriptBuildPhase(
                    name: phaseName,
                    shellScript: shellScript,
                    showEnvVarsInLog: true
                )
                pbxproj.add(object: shellScriptBuildPhase)
                target.buildPhases.insert(
                    shellScriptBuildPhase,
                    at: phaseIndex
                )
            }
        }
    }
    
    private func updateExistingCalciferBuildPhase(
        target: PBXTarget,
        buildPhase: PBXShellScriptBuildPhase,
        shellScript: String,
        expectedIndex: Int)
    {
        buildPhase.shellScript = shellScript
        if let currentBuildPhaseIndex = target.buildPhases.firstIndex(of: buildPhase),
            currentBuildPhaseIndex != expectedIndex
        {
            target.buildPhases.remove(
                at: currentBuildPhaseIndex
            )
            target.buildPhases.insert(
                buildPhase,
                at: expectedIndex
            )
        }
    }
    
    private func existingCalciferBuildPhase(
        target: PBXTarget,
        name: String)
        -> PBXShellScriptBuildPhase?
    {
        return target.buildPhases.first(where: { buildPhase -> Bool in
            if let scriptBuildPhase = buildPhase as? PBXShellScriptBuildPhase {
                return scriptBuildPhase.name == name
            }
            return false
        }) as? PBXShellScriptBuildPhase
    }

}
