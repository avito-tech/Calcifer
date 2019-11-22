import Foundation
import BaseModels
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
    
    override var children: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>> {
        let childrenChecksums = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        files.forEach { key, value in
            childrenChecksums.write(value, for: key)
        }
        dependencies.forEach { key, value in
            childrenChecksums.write(value, for: key)
        }
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
        let all = dependencies.values + dependencies.values.flatMap { $0.allFlatDependencies }
        var uniq = [String: TargetChecksumHolder<ChecksumType>]()
        for dependency in all {
            uniq[dependency.targetName] = dependency
        }
        let result = Array(uniq.values)
        cachedAllFlatDependencies = result
        return result
    }
    
    override func calculateChecksum() throws -> ChecksumType {
        var checksums = try children.values
            .sorted()
            .map { try $0.obtainChecksum() }
        checksums.append(try checksumProducer.checksum(string: name))
        return try checksums.aggregate()
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
                    configurationName: updateModel.configurationName,
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
            onRemove: { _ in

            },
            buildValue: { updateModel in
                updateModel.targetCache.createIfNotExist(updateModel.name) { _ in
                    TargetChecksumHolder(
                        updateModel: updateModel,
                        parent: self,
                        fullPathProvider: fullPathProvider,
                        checksumProducer: checksumProducer
                    )
                }.value
            }
        )
    }
    
    private func updateFiles(updateModel: TargetUpdateModel<ChecksumType>) throws -> Bool {
        var fileUrlDictionary = try updateModel.target
            .fileElements()
            .map { url in
                try fullPathProvider.fullPath(for: url, sourceRoot: updateModel.sourceRoot).url
            }.toDictionary { $0.path }
        let frameworkFolder = updateModel.sourceRoot.absolute().string.appendingPathComponent(updateModel.targetName)
        let frameworks = try FileManager.default.elements(at: frameworkFolder)
            .filter({ $0.pathExtension() == "framework"})
            .map({ URL(fileURLWithPath: $0, isDirectory: true) })
            .toDictionary { $0.path }
        fileUrlDictionary = fileUrlDictionary.merging(frameworks) { (current, _) in current }
        let headers = try FileManager.default.files(at: frameworkFolder)
            .filter({ $0.pathExtension() == "h"})
            .map({ URL(fileURLWithPath: $0, isDirectory: true) })
            .toDictionary { $0.path }
        fileUrlDictionary = fileUrlDictionary.merging(headers) { (current, _) in current }
        return try fileUrlDictionary.update(
            childrenDictionary: files,
            update: { (fileChecksumHolder: FileChecksumHolder<ChecksumType>, updateModel: URL) in
                fileChecksumHolder.parents.write(self, for: name)
                try fileChecksumHolder.reflectUpdate(updateModel: updateModel)
            },
            onRemove: { _ in

            },
            buildValue: { url in
                updateModel.fileCache.createIfNotExist(url.path) { _ in
                    FileChecksumHolder<ChecksumType>(
                        fileURL: url,
                        parent: self,
                        checksumProducer: checksumProducer
                    )
                }.value
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
