#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools chroot tar
ensure_dirs

BASE_MODE="${BASE_MODE:-systemd}"

build_minimal() {
  if [[ ! -d "${BUILD_DIR}/toolchain" ]]; then
    log "Missing toolchain build dir. Run bootstrap-toolchain.sh first."
    exit 1
  fi

  mkdir -p "${LFS_MNT}"

  if [[ -d "${ROOTFS_DIR}" && -n "$(ls -A "${ROOTFS_DIR}" 2>/dev/null)" ]]; then
    if [[ "${CLEAN_ROOTFS:-0}" -eq 1 ]]; then
      rm -rf "${ROOTFS_DIR:?}"/*
    else
      log "Rootfs dir is not empty: ${ROOTFS_DIR}"
      log "Set CLEAN_ROOTFS=1 to wipe it before rebuilding."
      exit 1
    fi
  fi

  busybox_bin="$(resolve_busybox)"

  mkdir -p \
    "${ROOTFS_DIR}/bin" \
    "${ROOTFS_DIR}/sbin" \
    "${ROOTFS_DIR}/etc" \
    "${ROOTFS_DIR}/proc" \
    "${ROOTFS_DIR}/sys" \
    "${ROOTFS_DIR}/dev" \
    "${ROOTFS_DIR}/tmp" \
    "${ROOTFS_DIR}/root" \
    "${ROOTFS_DIR}/home" \
    "${ROOTFS_DIR}/usr/bin" \
    "${ROOTFS_DIR}/usr/sbin" \
    "${ROOTFS_DIR}/var" \
    "${ROOTFS_DIR}/run" \
    "${ROOTFS_DIR}/boot" \
    "${ROOTFS_DIR}/mnt"

  install -m 0755 "$busybox_bin" "${ROOTFS_DIR}/bin/busybox"
  ln -sf /bin/busybox "${ROOTFS_DIR}/bin/sh"
  ln -sf /bin/busybox "${ROOTFS_DIR}/bin/mount"
  ln -sf /bin/busybox "${ROOTFS_DIR}/bin/umount"
  ln -sf /bin/busybox "${ROOTFS_DIR}/sbin/init"
  ln -sf /bin/busybox "${ROOTFS_DIR}/sbin/mdev"
  ln -sf /bin/busybox "${ROOTFS_DIR}/sbin/switch_root"

  cat > "${ROOTFS_DIR}/etc/inittab" <<'EOF'
::sysinit:/bin/mount -t proc proc /proc
::sysinit:/bin/mount -t sysfs sys /sys
::sysinit:/bin/mount -t devtmpfs devtmpfs /dev
::respawn:-/bin/sh
::ctrlaltdel:/bin/umount -a -r
::restart:/sbin/init
EOF

  cat > "${ROOTFS_DIR}/etc/passwd" <<'EOF'
root::0:0:root:/root:/bin/sh
EOF

  cat > "${ROOTFS_DIR}/etc/group" <<'EOF'
root:x:0:
EOF

  cat > "${ROOTFS_DIR}/etc/fstab" <<'EOF'
proc /proc proc nosuid,noexec,nodev 0 0
sysfs /sys sysfs nosuid,noexec,nodev 0 0
tmpfs /tmp tmpfs nosuid,nodev 0 0
devtmpfs /dev devtmpfs mode=0755,nosuid 0 0
EOF

  cat > "${ROOTFS_DIR}/etc/hostname" <<'EOF'
athenaos
EOF

  cat > "${ROOTFS_DIR}/etc/issue" <<'EOF'
AthenaOS (LFS minimal)
EOF

  cat > "${ROOTFS_DIR}/etc/os-release" <<'EOF'
NAME="AthenaOS"
ID=athenaos
VERSION="0.1"
PRETTY_NAME="AthenaOS 0.1 (LFS minimal)"
EOF

  cat > "${ROOTFS_DIR}/etc/profile" <<'EOF'
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
EOF

  log "Minimal rootfs staged at ${ROOTFS_DIR}."
  log "Next: build a kernel into ${ROOTFS_DIR}/boot and run build-initramfs.sh."
}

build_systemd() {
  local base_root
  base_root="${BASE_ROOT:-${ROOTFS_DIR}}"

  if [[ ! -d "${BUILD_DIR}/toolchain" ]]; then
    log "Toolchain build dir not found."
    log "Continuing with filesystem and config scaffolding only."
  fi

  if [[ -d "${base_root}" && -n "$(ls -A "${base_root}" 2>/dev/null)" ]]; then
    if [[ "${CLEAN_ROOTFS:-0}" -eq 1 ]]; then
      rm -rf "${base_root:?}"/*
    else
      log "Base root dir is not empty: ${base_root}"
      log "Set CLEAN_ROOTFS=1 to wipe it before rebuilding."
      exit 1
    fi
  fi

  mkdir -p "${base_root}"
  export LFS_ROOT="${base_root}"

  "${SCRIPT_DIR}/run-recipes.sh" base-systemd.order

  log "Base systemd scaffolding staged at ${base_root}."
  log "Next: add package recipes and rerun build-base.sh to expand the base system."
}

case "$BASE_MODE" in
  minimal)
    build_minimal
    ;;
  systemd)
    build_systemd
    ;;
  *)
    log "Unknown BASE_MODE=$BASE_MODE. Use BASE_MODE=systemd or BASE_MODE=minimal."
    exit 1
    ;;
esac
