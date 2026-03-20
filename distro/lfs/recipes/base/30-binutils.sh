#!/usr/bin/env bash
set -euo pipefail

recipe_name="binutils"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "binutils-*")")

  mkdir -p "${RECIPE_WORK_DIR}/build"
  pushd "${RECIPE_WORK_DIR}/build" >/dev/null
  "${src_dir}/configure" --prefix=/usr --disable-static --enable-gold --enable-plugins
  make -j"$(cpu_count)"
  make DESTDIR="$LFS_ROOT" install
  popd >/dev/null
}
