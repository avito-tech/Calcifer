import Foundation
import xcodeproj
import PathKit
import CommonCrypto

public final class TargetHashCalculator {
    
    public init() {}
    
    @discardableResult
    func calculate(projectPath: String, targetName:String) -> String? {
        let url = URL(fileURLWithPath: "/b/Avito/Pods/Pods.xcodeproj/project.pbxproj")
        do {
            let plistXML = try Data(contentsOf: url)
            var plistData: [String: AnyObject] = [:]
            var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml
            do {
                plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String : AnyObject]
                let objects = plistData["objects"] as! [String: AnyObject]
                let classes = plistData["classes"] as! [String: AnyObject]
                let firstObject = objects.first
                let firstClass = classes.first
                debugPrint(plistData)
            } catch {
                print("Error reading plist: \(error), format: \(propertyListForamt)")
            }
        } catch {
            print("error no upload")
        }
        
        return nil
        
//        guard let xcodeproject = try? XcodeProj(pathString: projectPath) else {
//            debugPrint("Error open project")
//            return nil
//        }
//
//        let pbxproj = xcodeproject.pbxproj
//
//        guard let developmentPodsGroup = xcodeproject.pbxproj.developmentPodsGroup(),
//            let podsGroup = xcodeproject.pbxproj.podsGroup()
//            else {
//            return nil
//        }
//
//        let targets = pbxproj.nativeTargets.filter { !$0.name.contains("Pods-") }
//
//        let hashList: [String] = targets.compactMap { target in
//
//           guard let targetGroup = self.group(
//                for: target,
//                developmentPodsGroup: developmentPodsGroup,
//                podsGroup: podsGroup) else {
//                    debugPrint("Error find target group for target \(target.name)")
//                    return nil
//            }
//            guard let targetGroupPath = try? targetGroup.fullPath(sourceRoot: Path(projectPath)),
//                let groupPath = targetGroupPath else {
//                    debugPrint("Error find target group path for target \(target.name)")
//                    return nil
//            }
//
//            return self.hash(target: target, groupPath: groupPath)
//        }
//
//        debugPrint(hashList)
//        let hash = hashList.joined().md5()
//
//        return hash
    }
    
    private func group(
        for target: PBXTarget,
        developmentPodsGroup: PBXGroup,
        podsGroup: PBXGroup) -> PBXGroup?
    {
        if let developmentGroup = developmentPodsGroup.subgroup(identifier: target.name) {
            return developmentGroup
        }
        if let podGroup = podsGroup.subgroup(identifier: target.name) {
            return podGroup
        }
        return nil
    }
    
    private func hash(target: PBXTarget, groupPath: Path) -> String? {
        let fileURLs: [URL]?  = try? target.sourceFiles().compactMap { file in
            guard let filePath = try? file.fullPath(sourceRoot: groupPath) else {
                return nil
            }
            return filePath?.url
        }
        
        var hashDictionary = Dictionary<String, String>()
        
        fileURLs?.forEach { fileURL in
            if let data = try? Data(contentsOf: fileURL) {
                let length = Int(CC_MD5_DIGEST_LENGTH)
                var digest = [UInt8](repeating: 0, count: length)
                _ = data.withUnsafeBytes { body in
                    CC_MD5(body, CC_LONG(data.count), &digest)
                }
                let hash = (0..<length).reduce("") {
                    $0 + String(format: "%02x", digest[$1])
                }
                hashDictionary[fileURL.path] = hash
            }
        }
//        debugPrint(hashDictionary ?? "-")
        
        let hash = Array(hashDictionary.values).sorted().joined().md5()
        
        debugPrint("hash for \(target.name) \(hash ?? "-")")
        return hash
    }

}

extension PBXGroup {
    func subgroup(identifier: String) -> PBXGroup? {
        // Some strange thing
        let element = children.first { children in
            if let group = children as? PBXGroup {
                return group.name == identifier || group.path == identifier
            }
            return false
        }
        return element as? PBXGroup
    }
}

extension PBXProj {
    func developmentPodsGroup() -> PBXGroup? {
        return groups.first { $0.name == "Development Pods" }
    }
    
    func podsGroup() -> PBXGroup? {
        return groups.first { $0.name == "Pods" }
    }
}

extension String {
    func md5() -> String? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        return data.md5()
    }
}

extension Data {
    func md5() -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        _ = withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            CC_MD5(body, CC_LONG(count), &digest)
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
