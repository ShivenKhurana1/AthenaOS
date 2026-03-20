#!/usr/bin/env bash
set -euo pipefail

recipe_name="zstd"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "zstd-*")")

  pushd "$src_dir" >/dev/null
  make -j"$(cpu_count)"
  make PREFIX=/usr DESTDIR="$LFS_ROOT" install
  popd >/dev/null
}
