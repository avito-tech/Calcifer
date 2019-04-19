import Foundation

public protocol BuildSourcePathProvider: class {
    func obtainBuildSourcePath(sourcePath: String, binaryPath: String) throws -> String
}

public final class BuildSourcePathProviderImpl: BuildSourcePathProvider {
    
    private let symbolTableProvider: SymbolTableProvider
    private let fileManager: FileManager
    
    public init(
        symbolTableProvider: SymbolTableProvider,
        fileManager: FileManager)
    {
        self.symbolTableProvider = symbolTableProvider
        self.fileManager = fileManager
    }
    
    public func obtainBuildSourcePath(sourcePath: String, binaryPath: String) throws -> String {
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
            return sourcePath
        }
        let relativeProductPath = sourceBuildPath.replacingOccurrences(
            of: sourcePath,
            with: ""
        )
        let buildSourcePath = buildPath.replacingOccurrences(
            of: relativeProductPath,
            with: ""
        )
        return buildSourcePath
    }
    
    private func obtainSourceMap(
        sourcePath: String,
        binaryPath: String)
        throws -> [String: String]
    {
        let binarySourcePathList = try obtainSourcePathList(for: binaryPath)
        let sourceMap: [(String, String)] = try binarySourcePathList.compactMap {
            var buildPath: String
            if $0.pathComponents().last == "/" {
                var buildPathComponents = $0.pathComponents()
                buildPathComponents.removeLast()
                buildPath = String.path(withComponents: buildPathComponents)
            } else {
                buildPath = $0
            }
            var currentPath = try self.findEqualPath(for: $0, rootPath: sourcePath)
            if currentPath.last == "/" {
                currentPath = currentPath.chop()
            }
            if buildPath.last == "/" {
                buildPath = buildPath.chop()
            }
            return (buildPath, currentPath)
        }
        return Dictionary(uniqueKeysWithValues: sourceMap)
    }

    private func findEqualPath(for path: String, rootPath: String) throws -> String {
        let components = path.pathComponents()
        if path.hasPrefix(rootPath) {
            return path
        }
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
                    path.contains("/Library/Caches/") == false &&
                        path.contains("Target Support Files") == false
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
