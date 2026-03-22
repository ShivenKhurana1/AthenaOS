#!/usr/bin/env bash
set -euo pipefail

recipe_name="dbus"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "dbus-*")")

  local build_dir="${RECIPE_WORK_DIR}/build"
  rm -rf "$build_dir"
  mkdir -p "$build_dir"
  pushd "$build_dir" >/dev/null

  meson setup \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var \
    -Dtests=false \
    "$src_dir"

  ninja
  DESTDIR="$LFS_ROOT" ninja install
  popd >/dev/null
}
