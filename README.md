# Calcifer

[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

Calcifer is a tool that enables remote build cache functionality for Xcode projects that use [CocoaPods](https://cocoapods.org/) dependency manager.

# Attention

**⚠️ The project is in alpha ⚠️**

- Use remote cache only if you have a Continuous Integration process that upload the cache to storage, otherwise there is no point in the remote cache.
- The version of Xcode should be the same for developers and for CI.
- Your project file and Podfile should be indexed by git.
- Initial build will take more time to finish because the remote cache is empty. Subsequent builds will then benefit from using remotely cached build artifacts.

# Installation

## Storage

You need to deploy a storage for artifacts. [Gradle Enterprise Build Cache Node](https://docs.gradle.com/build-cache-node/) can be used as such storage.
It is available as a [docker image](https://hub.docker.com/r/gradle/build-cache-node/). Install a [Docker](https://www.docker.com/get-started) and run the image:
```
docker pull gradle/build-cache-node
docker run -p 5071:5071 gradle/build-cache-node:latest
```

## Setup binary

Download or build a binary - `make build` / `make release_build` and execute:
```
./Calcifer installCalciferBinary
```
This command moves the binary to the `~ /.calcifer.noindex` folder and starts the Launch Daemon.
You can verify this by locating the running Calcifer process: `ps aux | grep Calcifer`.

## Setup Config

There are 4 configuration levels:

| Name     | Path                                       | Description                               | Priority     |
| -------- | -------------------------------------------|-------------------------------------------|--------------|
| Default  | Hardcoded in Calcifer sources              | All default values                        | 0 (lowest)   |
| Global   | `~ /.calcifer.noindex/CalciferConfig.json` | Global settings for all projects          | 1            |
| Project  | `/repository/CalciferConfig.json`          | Common to all developers project settings | 2            |
| Local    | `/repository/CalciferConfig.local.json`    | Custom project settings.                  | 3 (highest)  |

You need to create a Project Config file - `/repository/CalciferConfig.json`, next to your Podfile.

```json
{
	"enabled": true, // True by default
	"storageConfig": {
		"gradleHost": "http://PUT-HERE-YOUR-GRADLE-NODE_URL.com"
	}
}
```
This file is preferably put under the index of the git.
If you decide to temporarily disable the cache, you can override this config.
Create a Local config ('/repository/CalciferConfig.local.json') next to the project file with the following contents:
And override enable flag:

```json
{
	"enabled": false
}
```
This file does not need to be under the index, it is your personal project settings.
Of course, you can, and vice versa, turn off the remote cache for all developers, and enable it only for yourself.

## Integrate with CocoaPods

Download the calcifer.rb file and put it next to your Podfile.
Add the following code to Podfile:

```ruby

require './calcifer'

post_install do |installer|
  remote_cache_enabled_targets = [
    'YOUR_TARGET_NAME',
  ]
  targets_for_patch = setup_remote_cache(installer, remote_cache_enabled_targets)
  unlink_pods_dependencies_for_remote_cache(installer, targets_for_patch)
  update_remote_cache_if_needed()
end
```
Then run `pod install`. In the logs you should see `[Calcifer] Remote cache enabled` message.

## Validate Installation 
You can also check that the project is patched correctly:

- Open the workspace, and in the Pods project, find the target named `Pods-YOUR_PATCHED_TARGET_NAME`. This target should not have empty Target Dependencies.
- Find the target named `Pods-YOUR_PATCHED_TARGET_NAME-Calcifer`. This target should have all necessary Target Dependencies.

## CI

Follow the same steps to run Calcifer daemon on CI.
To upload the cache, build the desired target using the `xcodebuild` command and execute the following command:

```
./Calcifer uploadRemoteCache
```
Attention, if your target depends on another target, then only the results of the last builded target will be uploaded. In the future, this problem will be fixed.
You need to run `uploadRemoteCache` command after each `xcodebuild build` invocation. Fo example, you can build your project using different build settings and upload your build artifacts after each build.

---

# Troubleshooting

## Logs

You can find detailed logs inside the Calcifer folder:

- `~ /.calcifer.noindex/logs` calcifer logs.
- `~ /.calcifer.noindex/buildlogs` xcodebuild logs.
- `~ /.calcifer.noindex/launchctl` daemon logs.

## Environment parameters

All the necessary environment variables of your last build will be in the file - `~/.calcifer.noindex/calciferenv.json`.
All environment Parameters that affect the calculation of the checksum can be found in the logs:

```
INFO: Build parameters checksum: c0b8a254dac07f3a236fe0b404e79bcf from [ ... ]
```
These parameters should be the same for all developers and on the CI.

## Checksum

`~ /.calcifer.noindex/сhecksum.json` file contains all checksums of the latest build.
If you want to find the difference between two checksum files you can use the command:

```
~/.calcifer.noindex/Calcifer diff --firstChecksumPath ~/.calcifer.noindex/сhecksum.json --secondChecksumPath ~/.calcifer.noindex/сhecksum2.json
```
This is helpful when you want to investigate why Calcifer haven't provided remote build artifacts when you expected it to provide them.

## Build

Calcifer proxies all build warnings and errors through itself so you still will see them in Xcode as usual.. More details can be found in the logs.

If you want to manually reproduce a `xcodebuild` that Calcifer runs internally, open a patched project `YOUR_PATCHED_TARGET_NAME-RemoteCache.xcodeproj` inside `Pods` directory.
In Xcode, manually create a scheme for `Aggregate` target, select a build destination (by default it will be MacOS).
Then you may be able to build this scheme using Xcode or `xcodebuild` command. This build will be identical to the one which occurs in the Calcifer.

# License

Calcifer is released under the MIT license. See LICENSE for details.