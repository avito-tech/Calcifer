import Foundation
import Checksum
import XcodeProj
import PathKit
import Toolkit

class TargetChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        var childrenChecksums = [String: BaseChecksumHolder<ChecksumType>]()
        let filesChecksums = files as [String: BaseChecksumHolder<ChecksumType>]
        let dependenciesChecksums = dependencies as [String: BaseChecksumHolder<ChecksumType>]
        childrenChecksums = childrenChecksums.merging(filesChecksums, uniquingKeysWith: { (first, _) in first })
        childrenChecksums = childrenChecksums.merging(dependenciesChecksums, uniquingKeysWith: { (first, _) in first })
        return childrenChecksums
    }
    
    let targetName: String
    let productName: String
    let productType: TargetProductType
    
    private let fullPathProvider: FileElementFullPathProvider
    private let checksumProducer: URLChecksumProducer<ChecksumType>
    
    var files = [String: FileChecksumHolder<ChecksumType>]()
    var dependencies = [String: TargetChecksumHolder<ChecksumType>]()
    
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
        let all = dependencies.values + dependencies.flatMap { $0.value.allFlatDependencies }
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
                    cache: updateModel.cache
                )
            }.toDictionary { $0.name }
        return try updateModels.update(
            childrenDictionary: &dependencies,
            update: { (dependencyChecksumHolder: TargetChecksumHolder<ChecksumType>, dependencyUpdateModel: TargetUpdateModel<ChecksumType>) in
                // DO NOT UPDATE DEPENDENCY! THEY ALREADY UPDATED BY PROJECT
            }, buildValue: { updateModel in
                updateModel.cache.createIfNotExist(updateModel.name) { _ in
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
            childrenDictionary: &files,
            update: { (fileChecksumHolder: FileChecksumHolder<ChecksumType>, updateModel: URL) in
                try fileChecksumHolder.reflectUpdate(updateModel: updateModel)
            },
            buildValue: { url in
                FileChecksumHolder<ChecksumType>(
                    fileURL: url,
                    parent: self,
                    checksumProducer: checksumProducer
                )
            }
        )
    }
    
    override var nodeChildren: [CodableChecksumNode<String>] {
        let dependencyNodes = dependencies.values.map { dependency in
            CodableChecksumNode<String>(
                name: dependency.name,
                value: dependency.nodeValue,
                children: []
            )
        }
        let fileNodes = files.values.map{ $0.node() }
        return dependencyNodes + fileNodes
    }
    
}
