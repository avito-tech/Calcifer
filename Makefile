run_gradle_remote_cache:
	docker run -p 5071:5071 gradle/build-cache-node:latest

install_gradle_remote_cache:
	docker pull gradle/build-cache-node

build:
	swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --static-swift-stdlib

test:
	swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"  --static-swift-stdlib

generate_project:
	swift package generate-xcodeproj --xcconfig-overrides Config.xcconfig

prepareRemoteCache:
	.build/x86_64-apple-macosx10.10/debug/Calcifer prepareRemoteCache --environmentFilePath ~/calciferenv.json
