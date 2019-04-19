import Foundation
import ShellCommand
import Toolkit

public final class DSYMSymbolizer {
    
    private let dwarfUUIDProvider: DWARFUUIDProvider
    private let fileManager: FileManager
    
    public init(
        dwarfUUIDProvider: DWARFUUIDProvider,
        fileManager: FileManager)
    {
        self.dwarfUUIDProvider = dwarfUUIDProvider
        self.fileManager = fileManager
    }
    
    // Some lldb related source https://github.com/llvm-mirror/lldb/blob/master/source/Plugins/SymbolVendor/MacOSX/SymbolVendorMacOSX.cpp
    // Post about patching https://medium.com/@maxraskin/background-1b4b6a9c65be
    public func symbolize(
        dsymPath: String,
        sourcePath: String,
        buildSourcePath: String,
        binaryPath: String,
        binaryPathInApp: String)
        throws
    {
        if try shouldPatchDSYM(dsymPath: dsymPath, sourcePath: sourcePath) == false {
            return
        }
        let binaryUUIDs = try dwarfUUIDProvider.obtainDwarfUUID(path: binaryPath)
        let dsymUUIDs = try dwarfUUIDProvider.obtainDwarfUUID(path: dsymPath)
        let valid = try validateUUID(
            binaryUUIDs: binaryUUIDs,
            dsymUUIDs: dsymUUIDs
        )
        if valid == false {
            throw DSYMSymbolizerError.uuidMismatch(
                dsymPath: dsymPath,
                binaryPath: binaryPath
            )
        }
        try generatePlist(
            dsymPath: dsymPath,
            binaryPathInApp: binaryPathInApp,
            sourcePath: sourcePath,
            buildSourcePath: buildSourcePath,
            binaryUUIDs: binaryUUIDs
        )
    }
    
    private func validateUUID(
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
    
    func shouldPatchDSYM(dsymPath: String, sourcePath: String) throws -> Bool {
        let plistDirectory = dsymPath
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
        let directoryFiles = try fileManager.contentsOfDirectory(atPath: plistDirectory)
        for fileName in directoryFiles {
            if fileName.pathExtension() == "plist" {
                let filePath = plistDirectory.appendingPathComponent(fileName)
                if fileManager.isReadableFile(atPath: filePath) {
                    if let plistContent = NSDictionary(contentsOfFile: filePath),
                        let plistSourcePath = plistContent["DBGSourcePath"] as? String,
                        plistSourcePath.contains(sourcePath)
                    {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func generatePlist(
        dsymPath: String,
        binaryPathInApp: String,
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
                "DBGSymbolRichExecutable": binaryPathInApp
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
    
    private func obtainDSYMBinaryPath(dsymPath: String) throws -> String {
        // Some.framework.dSYM/Contents/Resources/DWARF/Some
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
    
}
