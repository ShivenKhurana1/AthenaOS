#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFS_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPO_ROOT="$(cd "${LFS_DIR}/../.." && pwd)"

SOURCES_DIR="${LFS_DIR}/sources"
PATCHES_DIR="${LFS_DIR}/patches"
ROOTFS_DIR="${LFS_DIR}/rootfs"
OUTPUT_DIR="${LFS_DIR}/output"
MANIFEST_DIR="${LFS_DIR}/manifests"
RECIPES_DIR="${LFS_DIR}/recipes"
BUILD_DIR="${LFS_DIR}/build"

LFS_MNT="${LFS_MNT:-/mnt/athenaos-lfs}"

log() {
  printf '%s\n' "$*"
}

require_linux() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    log "This script requires a Linux host."
    exit 1
  fi
}

require_tools() {
  local missing=0
  local tool
  for tool in "$@"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      log "Missing tool: $tool"
      missing=1
    fi
  done
  if [[ "$missing" -ne 0 ]]; then
    exit 1
  fi
}

ensure_dirs() {
  mkdir -p \
    "$SOURCES_DIR" \
    "$PATCHES_DIR" \
    "$ROOTFS_DIR" \
    "$OUTPUT_DIR" \
    "$MANIFEST_DIR" \
    "$RECIPES_DIR" \
    "$BUILD_DIR"
}

cpu_count() {
  getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1
}

resolve_busybox() {
  if [[ -n "${BUSYBOX_BINARY:-}" ]]; then
    if [[ -x "$BUSYBOX_BINARY" ]]; then
      printf '%s\n' "$BUSYBOX_BINARY"
      return 0
    fi
    log "BUSYBOX_BINARY is set but not executable: $BUSYBOX_BINARY"
    exit 1
  fi

  local source
  source=$(ls -1 "${SOURCES_DIR}"/busybox-* 2>/dev/null | tail -n 1 || true)
  if [[ -z "$source" ]]; then
    log "BusyBox source not found in ${SOURCES_DIR}."
    log "Set BUSYBOX_BINARY or add BusyBox to manifests/versions.lock and run setup-sources.sh."
    exit 1
  fi

  require_tools gcc make tar

  local build_root
  build_root="${BUILD_DIR}/busybox"
  rm -rf "$build_root"
  mkdir -p "$build_root"

  tar -xf "$source" -C "$build_root"
  local src_dir
  src_dir=$(find "$build_root" -maxdepth 1 -type d -name "busybox-*" | head -n 1)
  if [[ -z "$src_dir" ]]; then
    log "BusyBox source dir not found after extract."
    exit 1
  fi

  log "Building BusyBox from ${source}"
  pushd "$src_dir" >/dev/null
  make defconfig
  if grep -q "# CONFIG_STATIC is not set" .config; then
    sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
  elif ! grep -q "CONFIG_STATIC=y" .config; then
    echo "CONFIG_STATIC=y" >> .config
  fi
  make -j"$(cpu_count)"
  popd >/dev/null

  if [[ ! -x "${src_dir}/busybox" ]]; then
    log "BusyBox build failed."
    exit 1
  fi

  printf '%s\n' "${src_dir}/busybox"
}
