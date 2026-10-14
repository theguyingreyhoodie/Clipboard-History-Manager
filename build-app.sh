#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

APP_NAME="ClipboardHistory"
APP_BUNDLE="$APP_NAME.app"

echo "Building release binary..."
swift build -c release

BIN_PATH=".build/release/$APP_NAME"

echo "Assembling $APP_BUNDLE..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BIN_PATH" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
cp Info.plist "$APP_BUNDLE/Contents/Info.plist"

echo "Done: $APP_BUNDLE"
