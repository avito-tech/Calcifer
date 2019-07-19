import Foundation
import XCTest
import Mock
@testable import XcodeProjectChecksumCalculator
@testable import XcodeProj
import PathKit
import Toolkit
import Checksum

public final class ChecksumCalculatorMeasurementTests: BaseTestCase {
    
    private func projectRoot() -> Path? {
        return nil
    }
    
    private func xcodeProjPath() -> Path? {
        guard let sourceRoot = sourceRoot()
            else { return nil }
        return sourceRoot + Path("Pods.xcodeproj")
    }
    
    private func sourceRoot() -> Path? {
        guard let projectRoot = projectRoot()
            else { return nil }
        return projectRoot + Path("Pods/")
    }
    
    func test_measure_simple_calculater() {
        guard let xcodeProjPath = xcodeProjPath(),
            let sourceRoot = sourceRoot()
            else { return }
        guard let holder = try? obtainRootHolder(
            xcodeProjPath: xcodeProjPath,
            sourceRoot: sourceRoot
        ) else { return }
        let calculator = SimpleChecksumCalculator()
        measure {
            invalidate(holder)
            assertNoThrow {
                _ = try calculator.calculate(rootHolder: holder)
            }
        }
    }
    
    func test_measure_concurent_leafs_calculater() {
        guard let xcodeProjPath = xcodeProjPath(),
            let sourceRoot = sourceRoot()
            else { return }
        guard let holder = try? obtainRootHolder(
            xcodeProjPath: xcodeProjPath,
            sourceRoot: sourceRoot
        ) else { return }
        let calculator = ConcurentLeafsChecksumCalculator()
        measure {
            invalidate(holder)
            assertNoThrow {
                _ = try calculator.calculate(rootHolder: holder)
            }
        }
    }
    
    func test_measure_upToDown_calculater() {
        guard let xcodeProjPath = xcodeProjPath(),
            let sourceRoot = sourceRoot()
            else { return }
        guard let holder = try? obtainRootHolder(
            xcodeProjPath: xcodeProjPath,
            sourceRoot: sourceRoot
        ) else { return }
        let calculator = ConcurentUpToDownChecksumCalculator()
        measure {
            invalidate(holder)
            assertNoThrow {
                _ = try calculator.calculate(rootHolder: holder)
            }
        }
    }
    
    func test_measure_concurentParents_calculater() {
        guard let xcodeProjPath = xcodeProjPath(),
            let sourceRoot = sourceRoot()
            else { return }
        guard let holder = try? obtainRootHolder(
            xcodeProjPath: xcodeProjPath,
            sourceRoot: sourceRoot
        ) else { return }
        let calculator = ConcurentParentsChecksumCalculator()
        measure {
            invalidate(holder)
            assertNoThrow {
                _ = try calculator.calculate(rootHolder: holder)
            }
        }
    }
    
    func obtainRootHolder(
        xcodeProjPath: Path,
        sourceRoot: Path)
        throws -> XcodeProjChecksumHolder<BaseChecksum>
    {
        let xcodeProj = try XcodeProj(path: xcodeProjPath)
        let fullPathProvider = BaseFileElementFullPathProvider()
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let holder = XcodeProjChecksumHolder(
            name: xcodeProjPath.url.path,
            fullPathProvider: fullPathProvider,
            checksumProducer: checksumProducer
        )
        let updateModel = XcodeProjUpdateModel(
            xcodeProj: xcodeProj,
            projectPath: xcodeProjPath.url.path,
            sourceRoot: sourceRoot
        )
        try holder.reflectUpdate(updateModel: updateModel)
        return holder
    }
    
    func invalidate<ChecksumType: Checksum>(_ holder: BaseChecksumHolder<ChecksumType>) {
        let visited = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        invalidate(holder, visited: visited)
    }
    
    func invalidate<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>,
        visited: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
    {
        guard visited.read(holder.name) == nil else { return }
        visited.write(holder, for: holder.name)
        holder.invalidate()
        for child in holder.children.values {
            invalidate(child, visited: visited)
        }
    }
}
