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
flutter build web --release
