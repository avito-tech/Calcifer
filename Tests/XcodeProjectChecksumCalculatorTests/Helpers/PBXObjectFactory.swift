import Foundation
@testable import XcodeProjectChecksumCalculator
@testable import xcodeproj
import PathKit

final class PBXObjectFactory {
    
    static var objects: PBXObjects?
    
    static func fileElement(path: String = "\(UUID().uuidString).swift")
        -> PBXFileElement
    {
        let filePath = Path(path)
        let fileReference = PBXFileReference(
            sourceTree: .group,
            name: filePath.lastComponent,
            path: path
        )
        objects?.add(object: fileReference)
        return fileReference
    }
    
    static func buildFile(file: PBXFileElement = PBXObjectFactory.fileElement()) -> PBXBuildFile {
        let buildFile = PBXBuildFile(file: file)
        buildFile.reference.objects = objects
        objects?.add(object: buildFile)
        return buildFile
    }
    
    static func target(
        name: String = UUID().uuidString,
        buildFiles: [PBXBuildFile] = [PBXObjectFactory.buildFile()],
        dependencies: [PBXTarget] = [PBXTarget]())
        -> PBXTarget
    {
        let buildPhase = PBXSourcesBuildPhase(files: buildFiles)
        objects?.add(object: buildPhase)
        buildPhase.reference.objects = objects
        let targetDependencies = dependencies.map({
            PBXTargetDependency(name: $0.name, target: $0)
        })
        targetDependencies.forEach({
            objects?.add(object: $0)
        })
        let product = PBXFileReference(
            path: UUID().uuidString.replacingOccurrences(of: "-", with: "")
        )
        product.name = "\(name).framework"
        objects?.add(object: product)
        let target = PBXTarget(
            name: name,
            dependencies: targetDependencies,
            product: product,
            productType: .framework
        )
        target.buildPhases.append(buildPhase)
        
        return target
    }
}

extension PBXTarget {
    func filesPaths(sourceRoot: Path) -> String {
        return fileElements().compactMap({
            guard let filePath = $0.path else {
                return sourceRoot.url.absoluteString
            }
            let path = sourceRoot + Path(filePath)
            return path.url.absoluteString
        }).joined()
    }
}
