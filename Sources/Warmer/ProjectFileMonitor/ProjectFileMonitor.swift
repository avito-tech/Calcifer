import Foundation
import FileWatcher
import Toolkit

final class ProjectFileMonitor {
    
    private let fileWatcher: FileWatcher
    
    init(fileWatcher: FileWatcher) {
        self.fileWatcher = fileWatcher
    }
    
    func start(projectPath: String, onProjectChange: @escaping () -> ()) {
        let pbxprojPath = projectPath.appendingPathComponent("project.pbxproj")
        fileWatcher.start(path: projectPath)
        fileWatcher.subscribe { event in
            guard event.path == pbxprojPath else { return }
            onProjectChange()
        }
    }
}
