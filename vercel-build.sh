#!/bin/bash
set -e

echo "Installing Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter
export PATH="$PATH:$(pwd)/_flutter/bin"

echo "Precaching Flutter..."
flutter precache

echo "Building Flutter web..."
flutter build web --release --no-tree-shake-icons

echo "Build complete!"
