#!/bin/bash
set -e

echo "==> Building notime..."
swift build -c release

echo "==> Creating app bundle..."
rm -rf notime.app
mkdir -p notime.app/Contents/MacOS
cp .build/release/notime notime.app/Contents/MacOS/
cp Info.plist notime.app/Contents/

echo "==> Done: notime.app"
echo ""
echo "  Run:    open notime.app"
echo "  Or:     ./.build/release/notime"
