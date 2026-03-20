#!/usr/bin/env bash
set -euo pipefail

recipe_name="polkit"

recipe_install() {
  require_tools meson ninja
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "polkit-*")")

  mkdir -p "${RECIPE_WORK_DIR}/build"
  pushd "${RECIPE_WORK_DIR}/build" >/dev/null
  meson "${src_dir}" --prefix=/usr --buildtype=release
  ninja
  DESTDIR="$LFS_ROOT" ninja install
  popd >/dev/null
}
