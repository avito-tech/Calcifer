import Foundation
import ShellCommand
import Toolkit

public final class DSYMSymbolizer {
    
    private let symbolTableProvider: SymbolTableProvider
    private let dwarfUUIDProvider: DWARFUUIDProvider
    private let fileManager: FileManager
    
    public init(
        symbolTableProvider: SymbolTableProvider,
        dwarfUUIDProvider: DWARFUUIDProvider,
        fileManager: FileManager)
    {
        self.symbolTableProvider = symbolTableProvider
        self.dwarfUUIDProvider = dwarfUUIDProvider
        self.fileManager = fileManager
    }
    
    // Some lldb related source https://github.com/llvm-mirror/lldb/blob/master/source/Plugins/SymbolVendor/MacOSX/SymbolVendorMacOSX.cpp
    // Post about patching https://medium.com/@maxraskin/background-1b4b6a9c65be
    
    public func symbolize(
        dsymPath: String,
        sourcePath: String,
        binaryPath: String)
        throws
    {
        let binaryUUIDs = try dwarfUUIDProvider.obtainDwarfUUID(path: binaryPath)
        let dsymUUIDs = try dwarfUUIDProvider.obtainDwarfUUID(path: dsymPath)
        let valid = try validateUUID(
            dsymPath: dsymPath,
            binaryPath: binaryPath,
            binaryUUIDs: binaryUUIDs,
            dsymUUIDs: dsymUUIDs
        )
        if valid == false {
            throw DSYMSymbolizerError.uuidMismatch(
                dsymPath: dsymPath,
                binaryPath: binaryPath
            )
        }
        let buildSourcePath = try obtainBuildSourcePath(
            sourcePath: sourcePath,
            binaryPath: binaryPath
        )
        if buildSourcePath == sourcePath {
            return
        }
        try generatePlist(
            dsymPath: dsymPath,
            binaryPath: binaryPath,
            sourcePath: sourcePath,
            buildSourcePath: buildSourcePath,
            binaryUUIDs: binaryUUIDs
        )
    }
    
    private func validateUUID(
        dsymPath: String,
        binaryPath: String,
        binaryUUIDs: [DWARFUUID],
        dsymUUIDs: [DWARFUUID])
        throws -> Bool
    {
        for binaryUUID in binaryUUIDs {
            if dsymUUIDs.contains(binaryUUID) {
                continue
            }
            return false
        }
        return true
    }
    
    func generatePlist(
        dsymPath: String,
        binaryPath: String,
        sourcePath: String,
        buildSourcePath: String,
        binaryUUIDs: [DWARFUUID]) throws
    {
        for uuid in binaryUUIDs {
            let plistName = uuid.uuid.uuidString + ".plist"
            let plistPath = dsymPath
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources")
                .appendingPathComponent(plistName)
            let dwarfFilePath = try obtainDSYMBinaryPath(dsymPath: dsymPath)
            let content : [String: String] = [
                "DBGArchitecture": uuid.architecture,
                "DBGBuildSourcePath": buildSourcePath,
                "DBGSourcePath": sourcePath,
                "DBGDSYMPath": dwarfFilePath,
                "DBGSymbolRichExecutable": binaryPath
            ]
            let dictionary = NSDictionary(dictionary: content)
            
            if fileManager.fileExists(atPath: plistPath) {
                let plistContent = NSDictionary(contentsOfFile: plistPath)
                if plistContent == dictionary {
                    return
                }
            }
            
            let isWritten = dictionary.write(toFile: plistPath, atomically: true)
            if isWritten == false {
                throw DSYMSymbolizerError.unableToWritePlist(
                    path: plistPath,
                    content: content
                )
            }
        }
    }
    
    func obtainBuildSourcePath(sourcePath: String, binaryPath: String) throws -> String {
        let sourceMap = try obtainSourceMap(
            sourcePath: sourcePath,
            binaryPath: binaryPath
        )
        let sorted = sourceMap.keys.sorted { (first, second) -> Bool in
            first.pathComponents().count < second.pathComponents().count
        }
        guard let buildPath = sorted.first,  let sourceBuildPath = sourceMap[buildPath] else {
            throw DSYMSymbolizerError.unableToFindBuildSourcePath(binaryPath: binaryPath)
        }
        if buildPath == sourceBuildPath {
            return buildPath
        }
        var buildPathComponents = buildPath.pathComponents()
        for component in sourceBuildPath.pathComponents().reversed() {
            if buildPathComponents.last == component {
                buildPathComponents.removeLast()
            } else {
                let buildSourcePath = String.path(withComponents: buildPathComponents)
                return buildSourcePath
            }
        }
        throw DSYMSymbolizerError.unableToFindBuildSourcePath(binaryPath: binaryPath)
    }
    
    func obtainDSYMBinaryPath(dsymPath: String) throws -> String {
        // Unbox.framework.dSYM/Contents/Resources/DWARF/Unbox
        let dwarfDirectory = dsymPath
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("DWARF")
        let content = try fileManager.contentsOfDirectory(atPath: dwarfDirectory)
        if content.count > 1 {
            throw DSYMSymbolizerError.multipleDWARFFileInDSYM(dsymPath: dsymPath)
        }
        if content.count == 0 {
            throw DSYMSymbolizerError.unableToFindDWARFFileInDSYM(dsymPath: dsymPath)
        }
        let dwarfFilePath = dwarfDirectory.appendingPathComponent(content[0])
        return dwarfFilePath
    }
    
    private func obtainSourceMap(
        sourcePath: String,
        binaryPath: String)
        throws -> [String: String]
    {
        let binarySourcePathList = try obtainSourcePathList(for: binaryPath)
        let sourceMap: [(String, String)] = try binarySourcePathList.compactMap {
            let buildPath: String
            if $0.pathComponents().last == "/" {
                var buildPathComponents = $0.pathComponents()
                buildPathComponents.removeLast()
                buildPath = String.path(withComponents: buildPathComponents)
            } else {
                buildPath = $0
            }
            let currentPath = try self.findEqualPath(for: $0, rootPath: sourcePath)
            return (buildPath, currentPath)
        }
        return Dictionary(uniqueKeysWithValues: sourceMap)
    }
    
    private func findEqualPath(for path: String, rootPath: String) throws -> String {
        let components = path.pathComponents()
        let rootPathComponents = rootPath.pathComponents()
        for i in 0..<components.count {
            let resultPathComponents = rootPathComponents + components[i...]
            let resultPath = String.path(withComponents: resultPathComponents)
            if fileManager.directoryExist(at: resultPath) {
                return resultPath
            }
        }
        throw DSYMSymbolizerError.unableToFindNewSourcePath(
            path: path,
            sourceRoot: rootPath
        )
    }
    
    private func obtainSourcePathList(for binaryPath: String) throws -> [String] {
        let symbolTable = try symbolTableProvider.obtainSymbolTable(binaryPath: binaryPath)
        var sources = [String: String]()
        for line in symbolTable {
            if sources[line] != nil {
                continue
            }
            if line.contains("SO /") == false {
                continue
            }
            // 0000000000000000 - 00 0000    SO /Users/user/Rep/Pods/Target Support Files/Unbox/
            // 0000000000000000 - 00 0000    SO /Users/user/Rep/Pods/Unbox/Sources/
            let components = line.split(separator: " ")
            if components.count >= 5, components[4] == "SO" {
                let path = components[5...].joined(separator: " ")
                // filter pathes from build folder and from some system
                if path.contains(".build") == false &&
                    path.contains("/Library/Caches/") == false
                {
                    sources[line] = path
                }
            }
        }
        let uniqPathList = Array(Set(sources.values))
        if uniqPathList.count == 0 {
            throw DSYMSymbolizerError.emptyPathList(
                binaryPath: binaryPath
            )
        }
        return Array(uniqPathList)
    }
    
}
