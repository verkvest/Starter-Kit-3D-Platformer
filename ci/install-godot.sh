#!/usr/bin/env bash
# Install Godot 4.6.2 and its official export templates.
set -euo pipefail

VERSION="4.6.2"
TEMPLATE_DIR_NAME="${VERSION}.stable"

if [[ "$(uname)" == "Darwin" ]]; then
  EDITOR_URL="https://github.com/godotengine/godot/releases/download/${VERSION}-stable/Godot_v${VERSION}-stable_macos.universal.zip"
  TEMPLATE_ROOT="${HOME}/Library/Application Support/Godot/export_templates/${TEMPLATE_DIR_NAME}"
  BIN_DIR="${HOME}/bin"
  mkdir -p "${BIN_DIR}" /tmp/godot-editor
  curl -fsSL -o /tmp/godot-editor.zip "${EDITOR_URL}"
  rm -rf /tmp/godot-editor/Godot.app
  unzip -q -o /tmp/godot-editor.zip -d /tmp/godot-editor
  xattr -dr com.apple.quarantine /tmp/godot-editor || true
  GODOT_BIN="$(find /tmp/godot-editor -type f -path '*/MacOS/Godot' | head -1)"
  test -n "${GODOT_BIN}"
  ln -sfn "${GODOT_BIN}" "${BIN_DIR}/godot"
else
  EDITOR_URL="https://github.com/godotengine/godot/releases/download/${VERSION}-stable/Godot_v${VERSION}-stable_linux.x86_64.zip"
  TEMPLATE_ROOT="${HOME}/.local/share/godot/export_templates/${TEMPLATE_DIR_NAME}"
  BIN_DIR="${HOME}/bin"
  mkdir -p "${BIN_DIR}" /tmp/godot-editor
  curl -fsSL -o /tmp/godot-editor.zip "${EDITOR_URL}"
  unzip -q -o /tmp/godot-editor.zip -d /tmp/godot-editor
  install -m 755 "/tmp/godot-editor/Godot_v${VERSION}-stable_linux.x86_64" "${BIN_DIR}/godot"
fi

if [[ "${SKIP_TEMPLATES:-}" == "1" ]]; then
  echo "skipping export templates"
elif [[ ! -f "${TEMPLATE_ROOT}/version.txt" ]]; then
  mkdir -p "${TEMPLATE_ROOT}" /tmp/godot-templates
  curl -fsSL -o /tmp/godot-templates.tpz \
    "https://github.com/godotengine/godot/releases/download/${VERSION}-stable/Godot_v${VERSION}-stable_export_templates.tpz"
  rm -rf /tmp/godot-templates
  mkdir -p /tmp/godot-templates
  unzip -q /tmp/godot-templates.tpz -d /tmp/godot-templates
  cp -a /tmp/godot-templates/templates/. "${TEMPLATE_ROOT}/"
fi

test -x "${BIN_DIR}/godot"
test -f "${TEMPLATE_ROOT}/version.txt"
echo "Godot $(${BIN_DIR}/godot --version) templates ${TEMPLATE_ROOT}"
if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "${BIN_DIR}" >> "${GITHUB_PATH}"
fi
