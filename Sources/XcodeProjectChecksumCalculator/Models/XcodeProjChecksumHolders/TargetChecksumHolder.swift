import Foundation
import Checksum
import XcodeProj
import PathKit
import Toolkit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Xcode models structure:                                                                                                //
// XcodeProj - root, represent *.xcodeproj file. It contains pbxproj file represented by Proj (Look below) and xcschemes. //
// Proj - represent project.pbxproj file. It contains all references to objects - projects, files, groups, targets etc.   //
// Project - represent build project. It contains build settings and targets.                                             //
// Target - represent build target. It contains build phases. For example source build phase.                             //
// File - represent source file. Can be obtained from source build phase.                                                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class TargetChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        var childrenChecksums = [String: BaseChecksumHolder<ChecksumType>]()
        let filesChecksums = files.obtainDictionary() as [String: BaseChecksumHolder<ChecksumType>]
        let dependenciesChecksums = dependencies.obtainDictionary() as [String: BaseChecksumHolder<ChecksumType>]
        childrenChecksums = childrenChecksums.merging(filesChecksums, uniquingKeysWith: { (first, _) in first })
        childrenChecksums = childrenChecksums.merging(dependenciesChecksums, uniquingKeysWith: { (first, _) in first })
        return childrenChecksums
    }
    
    let targetName: String
    let productName: String
    let productType: TargetProductType
    
    private let fullPathProvider: FileElementFullPathProvider
    private let checksumProducer: URLChecksumProducer<ChecksumType>
    
    var files = ThreadSafeDictionary<String, FileChecksumHolder<ChecksumType>>()
    var dependencies = ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>()
    
    init(
        updateModel: TargetUpdateModel<ChecksumType>,
        parent: BaseChecksumHolder<ChecksumType>,
        fullPathProvider: FileElementFullPathProvider,
        checksumProducer: URLChecksumProducer<ChecksumType>)
    {
        self.targetName = updateModel.targetName
        self.productName = updateModel.productName
        self.productType = updateModel.productType
        self.fullPathProvider = fullPathProvider
        self.checksumProducer = checksumProducer
        super.init(
            name: updateModel.name,
            parent: parent
        )
    }
    
    private var cachedAllFlatDependencies: [TargetChecksumHolder<ChecksumType>]?
    
    var allFlatDependencies: [TargetChecksumHolder<ChecksumType>] {
        if let cachedAllDependencies = cachedAllFlatDependencies {
            return cachedAllDependencies
        }
        let all = dependencies.values + dependencies.obtainDictionary().flatMap { $0.value.allFlatDependencies }
        var uniq = [String: TargetChecksumHolder<ChecksumType>]()
        for dependency in all {
            uniq[dependency.targetName] = dependency
        }
        let result = Array(uniq.values)
        cachedAllFlatDependencies = result
        return result
    }
    
    override func calculateChecksum() throws -> ChecksumType {
        return try children.values
            .sorted()
            .map { try $0.obtainChecksum() }
            .aggregate()
    }
    
    func reflectUpdate(updateModel: TargetUpdateModel<ChecksumType>) throws {
        var shouldInvalidate = false
        if try updateDependencies(updateModel: updateModel) {
            shouldInvalidate = true
        }
        if try updateFiles(updateModel: updateModel) {
            shouldInvalidate = true
        }
        if shouldInvalidate {
            invalidate()
        }
    }
    
    private func updateDependencies(updateModel: TargetUpdateModel<ChecksumType>) throws -> Bool {
        let updateModels = updateModel.target.dependencies
            .compactMap { $0.target }
            .map { target in
                TargetUpdateModel<ChecksumType>(
                    target: target,
                    sourceRoot: updateModel.sourceRoot,
                    targetCache: updateModel.targetCache,
                    fileCache: updateModel.fileCache
                )
            }.toDictionary { $0.name }
        return try updateModels.update(
            childrenDictionary: dependencies,
            update: { (targetChecksumHolder: TargetChecksumHolder<ChecksumType>, _: TargetUpdateModel<ChecksumType>) in
                targetChecksumHolder.parents.write(self, for: name)
                // DO NOT UPDATE DEPENDENCY! THEY ALREADY UPDATED BY PROJECT
            },
            onRemove: { key in
                updateModel.targetCache.removeValue(forKey: key)
            },
            buildValue: { updateModel in
                updateModel.targetCache.createIfNotExist(updateModel.name) { _ in
                    TargetChecksumHolder(
                        updateModel: updateModel,
                        parent: self,
                        fullPathProvider: fullPathProvider,
                        checksumProducer: checksumProducer
                    )
                }
            }
        )
    }
    
    private func updateFiles(updateModel: TargetUpdateModel<ChecksumType>) throws -> Bool {
        let fileUrlDictionary = try updateModel.target
            .fileElements()
            .map { url in
                try fullPathProvider.fullPath(for: url, sourceRoot: updateModel.sourceRoot).url
            }.toDictionary { $0.path }
        return try fileUrlDictionary.update(
            childrenDictionary: files,
            update: { (fileChecksumHolder: FileChecksumHolder<ChecksumType>, updateModel: URL) in
                fileChecksumHolder.parents.write(self, for: name)
                try fileChecksumHolder.reflectUpdate(updateModel: updateModel)
            },
            onRemove: { key in
                updateModel.fileCache.removeValue(forKey: key)
            },
            buildValue: { url in
                updateModel.fileCache.createIfNotExist(url.path) { _ in
                    FileChecksumHolder<ChecksumType>(
                        fileURL: url,
                        parent: self,
                        checksumProducer: checksumProducer
                    )
                }
            }
        )
    }
    
    override var nodeChildren: [CodableChecksumNode<String>] {
        let dependencyNodes = dependencies.values.sorted().map { dependency in
            CodableChecksumNode<String>(
                name: dependency.name,
                value: dependency.nodeValue,
                children: []
            )
        }
        let fileNodes = files.values.sorted().map{ $0.node() }
        return dependencyNodes + fileNodes
    }
    
}
