import Foundation
import FileWatcher
import Toolkit

final class ProjectFileMonitor {
    
    private let fileEventNotifier: FileEventNotifier
    
    init(fileEventNotifier: FileEventNotifier) {
        self.fileEventNotifier = fileEventNotifier
    }
    
    func start(projectPath: String, onProjectChange: @escaping () -> ()) {
        let pbxprojPath = projectPath.appendingPathComponent("project.pbxproj")
        fileEventNotifier.subscribe { event in
            guard event.path == pbxprojPath else { return }
            onProjectChange()
        }
    }
}
