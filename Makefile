run_gradle_remote_cache:
	docker run -p 5071:5071 gradle/build-cache-node:latest
.PHONY: run_gradle_remote_cache

install_gradle_remote_cache:
	docker pull gradle/build-cache-node
.PHONY: install_gradle_remote_cache

build:
	swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --static-swift-stdlib
.PHONY: build

test:
	swift test -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"  --static-swift-stdlib
.PHONY: test

release_build:
	swift build -c release -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --static-swift-stdlib
.PHONY: release_build

generate_project:
	swift package generate-xcodeproj --xcconfig-overrides Config.xcconfig
.PHONY: generate_project

ship:
	swift build -c release -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --static-swift-stdlib
	./.build/x86_64-apple-macosx/release/Calcifer shipCurrentCalciferVersion
.PHONY: ship

lint:
	mkdir -p Lint; swiftlint --reporter html > Lint/lint.html || open Lint/lint.html
.PHONY: lint