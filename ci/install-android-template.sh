#!/usr/bin/env bash
# Godot only exports a Gradle build when res://android/build exists.
# Install the (already patched) official android_source.zip there.
set -euo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  TEMPLATE_ROOT="${HOME}/Library/Application Support/Godot/export_templates/4.6.2.stable"
else
  TEMPLATE_ROOT="${HOME}/.local/share/godot/export_templates/4.6.2.stable"
fi

ZIP="${TEMPLATE_ROOT}/android_source.zip"
test -f "${ZIP}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "${ROOT}/android"
mkdir -p "${ROOT}/android/build"
printf '%s\n' "4.6.2.stable" > "${ROOT}/android/.build_version"
printf '\n' > "${ROOT}/android/build/.gdignore"
unzip -q "${ZIP}" -d "${ROOT}/android/build"
test -f "${ROOT}/android/build/build.gradle"
test -f "${ROOT}/android/build/config.gradle"
grep -q "compileSdk         : 36" "${ROOT}/android/build/config.gradle"
echo "installed Android build template into ${ROOT}/android/build"
