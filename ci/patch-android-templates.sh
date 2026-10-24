#!/usr/bin/env bash
# Godot 4.6.2's Android template compiles against API 35. targetSdk 36 cannot
# exceed compileSdk, and API 36 needs Android Gradle Plugin 8.9.1. The wrapper
# is already Gradle 8.11.1.
set -euo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
  TEMPLATE_ROOT="${HOME}/Library/Application Support/Godot/export_templates/4.6.2.stable"
else
  TEMPLATE_ROOT="${HOME}/.local/share/godot/export_templates/4.6.2.stable"
fi

ZIP="${TEMPLATE_ROOT}/android_source.zip"
test -f "${ZIP}"
WORK="$(mktemp -d)"
unzip -q "${ZIP}" -d "${WORK}"
python3 - "${WORK}/config.gradle" <<'PY'
import pathlib, sys
path = pathlib.Path(sys.argv[1])
text = path.read_text()
replacements = {
    "androidGradlePlugin: '8.6.1'": "androidGradlePlugin: '8.9.1'",
    "compileSdk         : 35": "compileSdk         : 36",
    "targetSdk          : 35": "targetSdk          : 36",
    "buildTools         : '35.0.1'": "buildTools         : '36.0.0'",
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"pattern not found: {old}")
    text = text.replace(old, new, 1)
path.write_text(text)
print("patched", path)
PY
rm -f "${ZIP}"
(cd "${WORK}" && zip -qr "${ZIP}" .)
rm -rf "${WORK}"
echo "patched ${ZIP}"
