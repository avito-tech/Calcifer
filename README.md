# Calcifer

[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

Calcifer is a tool written in Swift for remote caching in Xcode projects that use the [CocoaPods](https://cocoapods.org/) dependency manager.

# Attention

**⚠️ The project is in alpha version, which means that there may be problems. ⚠️**

- Use remote cache only if you have a Continuous Integration process that upload the cache to storage, otherwise there is no point in the remote cache.
- The version of Xcode should be the same for developers and for CI.
- Your project file and Podfile should be in the git repository.
- If there are no suitable artifacts in the storage, the first build will be long enough, do not be surprised, this is only the first build. Set everything up correctly and then the build will be quick.

# Installation

The instruction may seem long and difficult, but in fact, with the necessary skills, everything can be set up in 5-10 minutes. Read carefully.

## Storage

You need to deploy a storage for artifacts. [Gradle Enterprise Build Cache Node](https://docs.gradle.com/build-cache-node/) is used as such storage.
It is distributed as a [docker image](https://hub.docker.com/r/gradle/build-cache-node/), so you need to install a [Docker](https://www.docker.com/get-started).
After installing the docker, download and run the image:
```
docker pull gradle/build-cache-node
docker run -p 5071:5071 gradle/build-cache-node:latest
```

## Setup binary

Download or build binary and execute
```
./Calcifer installCalciferBinary
```
This command moved the binary to the `~ /.calcifer.noindex` folder and starts the Launch Agent.
You can verify this by locating the running `Calcifer` process.

## Setup Config

There are 4 configuration levels:

| Name     | Path                                       | Description                               | Priority |
| -------- | -------------------------------------------|-------------------------------------------|----------|
| Default  | Hardcoded in sources                       | All default values                        | 0        |
| Global   | `~ /.calcifer.noindex/CalciferConfig.json` | Global settings for all projects          | 1        |
| Project  | `/repository/CalciferConfig.json`          | Common to all developers project settings | 2        |
| Local    | `/repository/CalciferConfig.local.json`    | Custom project settings.                  | 3        |

You need to create a Project Config file - `/repository/CalciferConfig.json`, next to the project file.

```json
{
	"enabled": true, // True by default
	"storageConfig": {
		"gradleHost": "http://PUT-HERE-YOUR-GRADLE-NODE_URL.com"
	},
	"calciferUpdateConfig": { // This is optional, but without this, the update will not work.
		"versionFileURL": "http://PATH_WERE_DOWNLOAD_NEW_VERSION/version.json",
		"zipBinaryFileURL": "http://PATH_WERE_DOWNLOAD_NEW_VERSION/Calcifer.zip"
	}
}
```
This file is preferably put under the index of the git.
If you decide to temporarily disable the cache, you can override this config.
Create a Local config - `/repository/CalciferConfig.local.json`, next to the project file.
And override enable flag:

```json
{
	"enabled": false
}
```
This file does not need to be put under the index, it is your personal project settings.
Of course, you can, and vice versa, turn off the remout cache for all developers, and enable it only for yourself.

## Integrate to CocoaPods

Download the calcifer.rb file and put it next to your Podfile.
Add the following code to Podfile:

```ruby

require './calcifer'

post_install do |installer|
  remote_cache_targets = [
    'YOUR_TARGET_NAME',
  ]
  targets_for_patch = setup_remote_cache(installer, remote_cache_targets)
  unlink_pods_dependencies_for_remote_cache(installer, targets_for_patch)
  update_remote_cache_if_needed()
end
```
Then run `pod install`. In the logs you can see the inscription on the status of the cache - `[Calcifer] Remote cache enabled`.

## Validate Installation 
You can also check that the project is patched correctly:

- Open the workspace, and in the Pods project, find the target named `Pods-YOUR_PATCHED_TARGET_NAME`. This target should not have empty Target Dependencies.
- Find the target named `Pods-YOUR_PATCHED_TARGET_NAME-Calcifer`. This target should have all necessary Target Dependencies.

## CI

On CI you also should run Calcifer Launch Agent and set everything up correctly.
To upload the cache, build the desired target using the `xcodebuild` command. And then execute this command:
```
./Calcifer uploadRemoteCache
```
Attention, if your target depends on another, then only the results of the last meeting will be loaded. In the future, this problem will be fixed.
In order to upload the cache for the device or for different configurations, you need to do this again, passing the corresponding parameters in to `xcodebuild` command.

---

# Troubleshooting

## Logs

You can find detailed logs inside the Calcifer folder - `~ /.calcifer.noindex/logs`, `~ /.calcifer.noindex/buildlogs` `~ /.calcifer.noindex/launchctl`.
All the necessary environment variables of your last build will be in the file - `calciferenv.json`.

## Environment parameters

All environment Parameters that affect the calculation of the checksum can be found in the logs:
```
INFO: Build parameters checksum: c0b8a254dac07f3a236fe0b404e79bcf from ["-DDEBUG -Onone ... "120200"]
```
These parameters should be the same for all developers and on the CI.

## Checksum

Nearby you can find a file with checksums of the latest build  - `сhecksum.json`.
If you want to find the difference you can use the command:
```
~/.calcifer.noindex/Calcifer diff --firstChecksumPath ~/.calcifer.noindex/сhecksum.json --secondChecksumPath ~/.calcifer.noindex/сhecksum2.json
```

## Build

If the build is not successful, you can still see all the errors in Xcode. More details can be found in the logs.

If you want to reproduce the build of dependencies, then you can open the patched project - `repository/Pods/YOUR_PATCHED_TARGET_NAME-RemoteCache.xcodeproj`.
You should create a scheme for `Aggregate` target, select a device(by default it will be MacOS) and try to build it. The behavior will be identical to that which occurs in the Calcifer.
You can also try to build it with the `xcodebuild` command, all parameters can be found in the logs.

# License

Calcifer is released under the MIT license. See LICENSE for details.