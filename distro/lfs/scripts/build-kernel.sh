#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools make gcc bc bison flex perl tar xz
ensure_dirs

KERNEL_CONFIG="${KERNEL_CONFIG:-}"
KERNEL_SOURCE="${KERNEL_SOURCE:-}"
KERNEL_BUILD_DIR="${BUILD_DIR}/kernel"
KERNEL_INSTALL_DIR="${ROOTFS_DIR}/boot"

mkdir -p "${KERNEL_BUILD_DIR}" "${KERNEL_INSTALL_DIR}"

if [[ -z "$KERNEL_SOURCE" ]]; then
  KERNEL_SOURCE=$(ls -1 "${SOURCES_DIR}"/linux-* 2>/dev/null | tail -n 1 || true)
fi

if [[ -z "$KERNEL_SOURCE" ]]; then
  log "Kernel source not found in ${SOURCES_DIR}."
  log "Set KERNEL_SOURCE or add a kernel tarball to manifests/versions.lock and run setup-sources.sh."
  exit 1
fi

rm -rf "${KERNEL_BUILD_DIR:?}"/*

tar -xf "$KERNEL_SOURCE" -C "$KERNEL_BUILD_DIR"
KERNEL_SRC_DIR=$(find "$KERNEL_BUILD_DIR" -maxdepth 1 -type d -name "linux-*" | head -n 1)

if [[ -z "$KERNEL_SRC_DIR" ]]; then
  log "Kernel source dir not found after extract."
  exit 1
fi

log "Building kernel from ${KERNEL_SOURCE}"

pushd "$KERNEL_SRC_DIR" >/dev/null
if [[ -n "$KERNEL_CONFIG" ]]; then
  cp "$KERNEL_CONFIG" .config
else
  make defconfig
fi

make -j"$(cpu_count)"
make modules_install INSTALL_MOD_PATH="${ROOTFS_DIR}"

KERNEL_RELEASE=$(make kernelrelease)
cp arch/x86/boot/bzImage "${KERNEL_INSTALL_DIR}/vmlinuz-${KERNEL_RELEASE}"
cp .config "${KERNEL_INSTALL_DIR}/config-${KERNEL_RELEASE}"

popd >/dev/null

log "Kernel installed to ${KERNEL_INSTALL_DIR}/vmlinuz-${KERNEL_RELEASE}"
