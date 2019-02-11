import CommandRunner
import Darwin

func main() -> Int32 {
    return CommandRunner().run()
}

let exitCode = main()
exit(exitCode)
