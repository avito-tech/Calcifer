import Foundation

public protocol DWARFUUIDProvider: class {
    func obtainDwarfUUID(path: String) throws -> [DWARFUUID]
}
