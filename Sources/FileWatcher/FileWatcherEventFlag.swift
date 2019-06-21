import Foundation

public struct FileWatcherEventFlag: OptionSet {
    
    public let rawValue: FSEventStreamEventFlags
    
    public init(rawValue: FSEventStreamEventFlags) {
        self.rawValue = rawValue
    }
    
    public init(_ value: Int) {
        self.rawValue = FSEventStreamEventFlags(value)
    }
    
    public static let isDirectory = FileWatcherEventFlag(kFSEventStreamEventFlagItemIsDir)
    public static let isFile = FileWatcherEventFlag(kFSEventStreamEventFlagItemIsFile)
    
    public static let created = FileWatcherEventFlag(kFSEventStreamEventFlagItemCreated)
    public static let modified = FileWatcherEventFlag(kFSEventStreamEventFlagItemModified)
    public static let removed = FileWatcherEventFlag(kFSEventStreamEventFlagItemRemoved)
    public static let renamed = FileWatcherEventFlag(kFSEventStreamEventFlagItemRenamed)
    
    public static let isHardlink = FileWatcherEventFlag(kFSEventStreamEventFlagItemIsHardlink)
    public static let isLastHardlink = FileWatcherEventFlag(kFSEventStreamEventFlagItemIsLastHardlink)
    public static let isSymlink = FileWatcherEventFlag(kFSEventStreamEventFlagItemIsSymlink)
    public static let changeOwner = FileWatcherEventFlag(kFSEventStreamEventFlagItemChangeOwner)
    public static let finderInfoModified = FileWatcherEventFlag(kFSEventStreamEventFlagItemFinderInfoMod)
    public static let inodeMetaModified = FileWatcherEventFlag(kFSEventStreamEventFlagItemInodeMetaMod)
    public static let xattrsModified = FileWatcherEventFlag(kFSEventStreamEventFlagItemXattrMod)
    
    var description: String {
        
        var names: [String] = []
        if self.contains(.isDirectory) { names.append("isDir") }
        if self.contains(.isFile) { names.append("isFile") }
        
        if self.contains(.created) { names.append("created") }
        if self.contains(.modified) { names.append("modified") }
        if self.contains(.removed) { names.append("removed") }
        if self.contains(.renamed) { names.append("renamed") }
        
        if self.contains(.isHardlink) { names.append("isHardlink") }
        if self.contains(.isLastHardlink) { names.append("isLastHardlink") }
        if self.contains(.isSymlink) { names.append("isSymlink") }
        if self.contains(.changeOwner) { names.append("changeOwner") }
        if self.contains(.finderInfoModified) { names.append("finderInfoModified") }
        if self.contains(.inodeMetaModified) { names.append("inodeMetaModified") }
        if self.contains(.xattrsModified) { names.append("xattrsModified") }
        
        return names.joined(separator: ", ")
    }
}
