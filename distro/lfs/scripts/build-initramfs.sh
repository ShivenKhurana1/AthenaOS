#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools cpio gzip
ensure_dirs

INITRAMFS_OUTPUT="${INITRAMFS_OUTPUT:-${ROOTFS_DIR}/boot/initramfs.img}"
SQUASHFS_PATH_DEFAULT="/rootfs.squashfs"

busybox_bin="$(resolve_busybox)"

if [[ ! -d "${ROOTFS_DIR}/boot" ]]; then
  mkdir -p "${ROOTFS_DIR}/boot"
fi

WORK_DIR="${BUILD_DIR}/initramfs"
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}/bin" "${WORK_DIR}/sbin" "${WORK_DIR}/proc" \
  "${WORK_DIR}/sys" "${WORK_DIR}/dev" "${WORK_DIR}/mnt/iso" "${WORK_DIR}/newroot"

install -m 0755 "$busybox_bin" "${WORK_DIR}/bin/busybox"
ln -sf /bin/busybox "${WORK_DIR}/bin/sh"
ln -sf /bin/busybox "${WORK_DIR}/bin/mount"
ln -sf /bin/busybox "${WORK_DIR}/bin/umount"
ln -sf /bin/busybox "${WORK_DIR}/sbin/switch_root"
ln -sf /bin/busybox "${WORK_DIR}/sbin/mdev"

cat > "${WORK_DIR}/init" <<'EOF'
#!/bin/sh
set -e

mount -t proc proc /proc
mount -t sysfs sys /sys

if ! mount -t devtmpfs devtmpfs /dev 2>/dev/null; then
  mknod -m 600 /dev/console c 5 1
  mknod -m 666 /dev/null c 1 3
fi

echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s

cmdline="$(cat /proc/cmdline)"
label=""
iso_dev=""
squashfs=""

for arg in $cmdline; do
  case "$arg" in
    CDLABEL=*) label="${arg#CDLABEL=}" ;;
    athenaos.iso_dev=*) iso_dev="${arg#athenaos.iso_dev=}" ;;
    athenaos.squashfs=*) squashfs="${arg#athenaos.squashfs=}" ;;
  esac
done

if [ -n "$label" ] && [ -e "/dev/disk/by-label/$label" ]; then
  iso_dev="/dev/disk/by-label/$label"
fi

if [ -z "$iso_dev" ]; then
  iso_dev="/dev/sr0"
fi

if [ -z "$squashfs" ]; then
  squashfs="/rootfs.squashfs"
fi

if ! mount -o ro "$iso_dev" /mnt/iso; then
  echo "Failed to mount ISO device: $iso_dev" >/dev/console
  exec sh
fi

squashfs_path="/mnt/iso/${squashfs#/}"
if ! mount -t squashfs -o ro "$squashfs_path" /newroot; then
  echo "Failed to mount squashfs: $squashfs_path" >/dev/console
  exec sh
fi

exec switch_root /newroot /sbin/init
EOF

chmod +x "${WORK_DIR}/init"

( cd "${WORK_DIR}" && find . -print0 | cpio --null -ov --format=newc | gzip -9 ) > "${INITRAMFS_OUTPUT}"

log "Initramfs written to ${INITRAMFS_OUTPUT}"
log "Default squashfs path is ${SQUASHFS_PATH_DEFAULT}."
