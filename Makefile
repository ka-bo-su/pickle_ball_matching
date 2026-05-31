.PHONY: bootstrap preflight validate format lint xcodegen build test

bootstrap:
	scripts/codex/bootstrap-ios.sh

preflight:
	scripts/codex/preflight.sh

validate:
	scripts/codex/validate-ios.sh

format:
	swiftformat .

lint:
	swiftlint --no-cache
	swiftformat --lint .

xcodegen:
	xcodegen generate

build:
	xcodebuild build -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'

test:
	xcodebuild test -project PickleBallMatching.xcodeproj -scheme PickleBallMatching -destination 'platform=iOS Simulator,name=iPhone 16'
