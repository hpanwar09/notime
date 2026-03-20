#!/bin/bash
set -e

echo "==> Building notime (universal)..."
swift build -c release
NATIVE=.build/release/notime
cp "$NATIVE" /tmp/notime-native

ARCH=$(uname -m)
OTHER=$( [ "$ARCH" = "arm64" ] && echo "x86_64" || echo "arm64" )

if swift build -c release --triple ${OTHER}-apple-macosx 2>/dev/null; then
  CROSS=.build/${OTHER}-apple-macosx/release/notime
  lipo -create /tmp/notime-native "$CROSS" -output "$NATIVE"
  echo "  universal binary (arm64 + x86_64)"
else
  cp /tmp/notime-native "$NATIVE"
  echo "  ${ARCH}-only (cross-compile unavailable)"
fi
rm -f /tmp/notime-native

echo "==> Creating app bundle..."
rm -rf notime.app
mkdir -p notime.app/Contents/MacOS
cp .build/release/notime notime.app/Contents/MacOS/
cp Info.plist notime.app/Contents/

echo "==> Done: notime.app"
echo ""
echo "  Run:    open notime.app"
echo "  Or:     ./.build/release/notime"
