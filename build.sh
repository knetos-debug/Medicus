#!/bin/bash
set -e

# Install Flutter
if [ ! -d "/tmp/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
fi

export PATH="$PATH:/tmp/flutter/bin"

# Verify Flutter installation
flutter --version

# Install dependencies
flutter pub get

# Build web app
# Note: --web-renderer was removed in Flutter 3.22+, CanvasKit is now default
flutter build web --release
