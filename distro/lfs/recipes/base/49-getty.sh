#!/usr/bin/env bash
set -euo pipefail

recipe_name="getty"

recipe_install() {
  local root="${LFS_ROOT:?}"

  install -d -m 0755 "${root}/etc/systemd/system/getty@tty1.service.d"

  cat > "${root}/etc/systemd/system/getty@tty1.service.d/autologin.conf" <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I $TERM
EOF
}
