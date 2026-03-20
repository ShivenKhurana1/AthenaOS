#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools mksquashfs grub-mkrescue xorriso
ensure_dirs

ARCH="${ARCH:-x86_64}"
VERSION="${VERSION:-0.1}"
ISO_LABEL="${ISO_LABEL:-ATHENAOS-${VERSION}}"
ISO_NAME="${ISO_NAME:-AthenaOS-${VERSION}-${ARCH}.iso}"
SQUASHFS_COMP="${SQUASHFS_COMP:-xz}"
GRUB_TIMEOUT="${GRUB_TIMEOUT:-5}"
LIVE_ARGS_DEFAULT="root=live:CDLABEL=${ISO_LABEL} rd.live.image athenaos.squashfs=/rootfs.squashfs"
LIVE_ARGS="${LIVE_ARGS:-${LIVE_ARGS_DEFAULT}}"
COMMON_ARGS="${COMMON_ARGS:-quiet}"

if [[ ! -d "${ROOTFS_DIR}" ]]; then
  log "Rootfs staging dir not found at $ROOTFS_DIR."
  exit 1
fi

if [[ ! -d "${ROOTFS_DIR}/boot" ]]; then
  log "Rootfs boot dir not found at ${ROOTFS_DIR}/boot."
  exit 1
fi

find_kernel() {
  if [[ -n "${KERNEL_IMAGE:-}" ]]; then
    printf '%s\n' "$KERNEL_IMAGE"
    return 0
  fi
  shopt -s nullglob
  local candidates=(
    "${ROOTFS_DIR}/boot/vmlinuz-"*
    "${ROOTFS_DIR}/boot/vmlinuz"
    "${ROOTFS_DIR}/boot/bzImage"
  )
  shopt -u nullglob
  if [[ "${#candidates[@]}" -gt 0 ]]; then
    printf '%s\n' "${candidates[-1]}"
    return 0
  fi
  return 1
}

find_initramfs() {
  if [[ -n "${INITRAMFS_IMAGE:-}" ]]; then
    printf '%s\n' "$INITRAMFS_IMAGE"
    return 0
  fi
  shopt -s nullglob
  local candidates=(
    "${ROOTFS_DIR}/boot/initramfs-"*.img
    "${ROOTFS_DIR}/boot/initrd-"*.img
    "${ROOTFS_DIR}/boot/initramfs.img"
    "${ROOTFS_DIR}/boot/initrd.img"
  )
  shopt -u nullglob
  if [[ "${#candidates[@]}" -gt 0 ]]; then
    printf '%s\n' "${candidates[-1]}"
    return 0
  fi
  return 1
}

KERNEL_PATH="$(find_kernel || true)"
INITRAMFS_PATH="$(find_initramfs || true)"

if [[ -z "$KERNEL_PATH" ]]; then
  log "Missing kernel image in ${ROOTFS_DIR}/boot. Set KERNEL_IMAGE to override."
  exit 1
fi

if [[ -z "$INITRAMFS_PATH" ]]; then
  if [[ "${BUILD_INITRAMFS:-0}" -eq 1 ]]; then
    "${SCRIPT_DIR}/build-initramfs.sh"
    INITRAMFS_PATH="$(find_initramfs || true)"
  fi
fi

if [[ -z "$INITRAMFS_PATH" ]]; then
  log "Missing initramfs image in ${ROOTFS_DIR}/boot. Set INITRAMFS_IMAGE to override."
  log "Or set BUILD_INITRAMFS=1 to generate it."
  exit 1
fi

ISO_STAGING="${BUILD_DIR}/iso"
ISO_BOOT="${ISO_STAGING}/boot"
ISO_GRUB="${ISO_BOOT}/grub"

rm -rf "${ISO_STAGING}"
mkdir -p "${ISO_GRUB}"

log "Creating squashfs from ${ROOTFS_DIR}"
mksquashfs "${ROOTFS_DIR}" "${ISO_STAGING}/rootfs.squashfs" -comp "${SQUASHFS_COMP}" -noappend

log "Staging kernel and initramfs"
cp "${KERNEL_PATH}" "${ISO_BOOT}/vmlinuz"
cp "${INITRAMFS_PATH}" "${ISO_BOOT}/initramfs.img"

cat > "${ISO_GRUB}/grub.cfg" <<EOF
set default=0
set timeout=${GRUB_TIMEOUT}

menuentry "AthenaOS Live" {
  linux /boot/vmlinuz ${LIVE_ARGS} ${COMMON_ARGS}
  initrd /boot/initramfs.img
}
EOF

log "Building ISO ${ISO_NAME}"
grub-mkrescue -o "${OUTPUT_DIR}/${ISO_NAME}" "${ISO_STAGING}" -- -volid "${ISO_LABEL}"

log "ISO written to ${OUTPUT_DIR}/${ISO_NAME}"
