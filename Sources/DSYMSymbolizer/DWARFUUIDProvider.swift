import Foundation

public protocol DWARFUUIDProvider: class {
    func obtainDwarfUUIDs(path: String) throws -> [DWARFUUID]
}
