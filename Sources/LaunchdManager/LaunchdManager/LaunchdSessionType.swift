import Foundation

// TODO: Migrate on LaunchdJob from emcee
public enum LaunchdSessionType: String {
    /** Has access to all GUI services; much like a login item. This is a default value. */
    case aqua = "Aqua"
    /** Runs only in non-GUI login sessions (most notably, SSH login sessions) */
    case standardIO = "StandardIO"
    /** Runs in a context that's the parent of all contexts for a given user */
    case background = "Background"
    /** Runs in the loginwindow context */
    case loginWindow = "LoginWindow"
}
