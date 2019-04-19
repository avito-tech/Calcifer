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
        dsymBundlePath: String,
        sourcePath: String,
        buildSourcePath: String,
        binaryPath: String,
        binaryPathInApp: String)
        throws
    {
        guard try shouldPatchDSYM(dsymBundlePath: dsymBundlePath, sourcePath: sourcePath) == true
            else { return }
        let binaryUUIDs = try dwarfUUIDProvider.obtainDwarfUUIDs(path: binaryPath)
        let dsymUUIDs = try dwarfUUIDProvider.obtainDwarfUUIDs(path: dsymBundlePath)
        
        guard try validateUUID(binaryUUIDs: binaryUUIDs, dsymUUIDs: dsymUUIDs) == true
            else {
                throw DSYMSymbolizerError.uuidMismatch(
                    dsymPath: dsymBundlePath,
                    binaryPath: binaryPath
                )
            }
        try generatePlist(
            dsymBundlePath: dsymBundlePath,
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
    
    public func shouldPatchDSYM(dsymBundlePath: String, sourcePath: String) throws -> Bool {
        let plistDirectory = dsymBundlePath
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
        dsymBundlePath: String,
        binaryPathInApp: String,
        sourcePath: String,
        buildSourcePath: String,
        binaryUUIDs: [DWARFUUID]) throws
    {
        for uuid in binaryUUIDs {
            let plistName = uuid.uuid.uuidString + ".plist"
            let plistPath = dsymBundlePath
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources")
                .appendingPathComponent(plistName)
            let dwarfFilePath = try obtainDSYMBinaryPath(dsymBundlePath: dsymBundlePath)
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
    
    private func obtainDSYMBinaryPath(dsymBundlePath: String) throws -> String {
        // Some.framework.dSYM/Contents/Resources/DWARF/Some
        let dwarfDirectory = dsymBundlePath
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("DWARF")
        let content = try fileManager.contentsOfDirectory(atPath: dwarfDirectory)
        if content.count > 1 {
            throw DSYMSymbolizerError.multipleDWARFFileInDSYM(
                dsymPath: dsymBundlePath
            )
        }
        if content.count == 0 {
            throw DSYMSymbolizerError.unableToFindDWARFFileInDSYM(
                dsymPath: dsymBundlePath
            )
        }
        let dwarfFilePath = dwarfDirectory.appendingPathComponent(content[0])
        return dwarfFilePath
    }
    
}
