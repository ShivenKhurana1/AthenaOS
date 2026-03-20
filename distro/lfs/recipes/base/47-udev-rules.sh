#!/usr/bin/env bash
set -euo pipefail

recipe_name="udev-rules"

recipe_install() {
  local root="${LFS_ROOT:?}"
  install -d -m 0755 "${root}/etc/udev/rules.d"

  cat > "${root}/etc/udev/rules.d/50-athenaos.rules" <<'EOF'
SUBSYSTEM=="input", GROUP="input", MODE="0660"
SUBSYSTEM=="tty", GROUP="tty", MODE="0660"
SUBSYSTEM=="video", GROUP="video", MODE="0660"
EOF
}
