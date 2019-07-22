import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import RemoteCachePreparer
import CalciferConfig
import Checksum
import Toolkit
import XCTest
import Mock

@testable import Warmer

public final class BuildProductCacheStorageWarmerTests: BaseTestCase {
    
    private lazy var podsRoot = createTmpDirectory()
    private lazy var calciferPathProviderStub: CalciferPathProviderStub = {
        let calciferPathProvider = CalciferPathProviderStub(
            fileManager: fileManager
        )
        calciferPathProvider.stubedCalciferDirectory = createTmpDirectory().path
        return calciferPathProvider
    }()
    
    func test_warmup() throws {
        // Given
        let expectedProductName = UUID().uuidString
        var resultProductName: String?
        let warmer = createWarmer(productName: expectedProductName) { productName in
            resultProductName = productName
            return UUID().uuidString
        }
        let projectDirectory = createTmpDirectory().path
        assertNoThrow {
            try generateParams(
                podsRoot: createTmpDirectory().path,
                projectDirectory: projectDirectory
            )
            let projectConfigPath = projectDirectory
                .appendingPathComponent("CalciferConfig.json")
            try generateConfig(
                projectConfigPath: projectConfigPath
            )
        }
        let events: WarmerEvent = .initial
        // When
        warmer.warmup(for: events) { operation in
            operation.start()
        }
        // Then
        XCTAssertEqual(expectedProductName, resultProductName)
    }
    
    private func createWarmer(
        productName: String,
        onCached: @escaping (String) -> (String))
        -> BuildProductCacheStorageWarmer
    {
        let calciferDirectory = calciferPathProviderStub.calciferDirectory()
        let calciferConfigProvider = CalciferConfigProvider(
            calciferDirectory: calciferDirectory
        )
        let requiredTargetsProvider = RequiredTargetsProviderStub()
        requiredTargetsProvider.onObtainRequiredTargets = { _, _ in
            [
                TargetInfo(
                    targetName: "targetName",
                    productName: productName,
                    productType: .framework,
                    dependencies: [],
                    checksum: BaseChecksum("checksum")
                )
            ]
        }
        let cacheKeyBuilder = BuildProductCacheKeyBuilder()
        let targetInfoFilter = TargetInfoFilter()
        let storage = BuildProductCacheStorageStub(
            onCached: onCached
        )
        let cacheStorageFactory = CacheStorageFactoryStub(
            localBuildProductCacheStorage: storage,
            remoteBuildProductCacheStorage: storage,
            mixedCacheStorage: storage
        )
        let factory = BuildProductCacheStorageWarmerFactory(
            configProvider: calciferConfigProvider,
            requiredTargetsProvider: requiredTargetsProvider,
            calciferPathProvider: calciferPathProviderStub,
            cacheKeyBuilder: cacheKeyBuilder,
            targetInfoFilter: targetInfoFilter,
            cacheStorageFactory: cacheStorageFactory,
            fileManager: fileManager
        )
        return factory.build()
    }
    
    @discardableResult
    private func generateParams(
        podsRoot: String,
        projectDirectory: String)
        throws -> XcodeBuildEnvironmentParameters
    {
        let params = try XcodeBuildEnvironmentParameters.forTests(
            podsRoot: podsRoot,
            projectDirectory: projectDirectory
        )
        let podXcodeprojFolder = params.podsProjectPath
        try fileManager.createDirectory(
            atPath: podXcodeprojFolder,
            withIntermediateDirectories: true
        )
        let pbxprojFile = podXcodeprojFolder.appendingPathComponent("project.pbxproj")
        fileManager.createFile(
            atPath: pbxprojFile,
            contents: nil
        )
        try params.save(to: calciferPathProviderStub.calciferEnvironmentFilePath())
        return params
    }
    
    private func generateConfig(projectConfigPath: String) throws {
        let content = [
            "storageConfig": [
                "gradleHost": "http://gradle-cache-node.com"
            ]
        ]
        let data = try JSONSerialization.data(
            withJSONObject: content,
            options: .prettyPrinted
        )
        try data.write(to: URL(fileURLWithPath: projectConfigPath))
    }
    
}
