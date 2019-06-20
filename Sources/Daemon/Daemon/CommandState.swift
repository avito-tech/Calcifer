import Foundation

public enum CommandState {
    case running
    case completed(exitCode: Int32)
}
