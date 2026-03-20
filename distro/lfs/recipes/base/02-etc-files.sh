#!/usr/bin/env bash
set -euo pipefail

recipe_name="base-etc-files"

recipe_install() {
  local root="${LFS_ROOT:?}"

  install -d -m 0755 "${root}/etc"

  cat > "${root}/etc/hostname" <<'EOF'
athenaos
EOF

  cat > "${root}/etc/hosts" <<'EOF'
127.0.0.1 localhost
127.0.1.1 athenaos
::1       localhost
EOF

  cat > "${root}/etc/issue" <<'EOF'
AthenaOS (LFS base)
EOF

  cat > "${root}/etc/os-release" <<'EOF'
NAME="AthenaOS"
ID=athenaos
VERSION="0.1"
PRETTY_NAME="AthenaOS 0.1 (LFS base)"
EOF

  cat > "${root}/etc/fstab" <<'EOF'
proc /proc proc nosuid,noexec,nodev 0 0
sysfs /sys sysfs nosuid,noexec,nodev 0 0
devtmpfs /dev devtmpfs mode=0755,nosuid 0 0
tmpfs /run tmpfs nosuid,nodev,mode=0755 0 0
tmpfs /tmp tmpfs nosuid,nodev,mode=1777 0 0
EOF

  cat > "${root}/etc/profile" <<'EOF'
export PATH=/usr/bin:/usr/sbin
EOF
}
