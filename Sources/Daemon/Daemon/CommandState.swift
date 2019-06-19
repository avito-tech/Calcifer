import Foundation

public enum CommandState {
    case progress
    case completed(exitCode: Int32)
}
