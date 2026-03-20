#!/usr/bin/env bash
set -euo pipefail

recipe_name="linux-headers"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "linux-*")")

  pushd "$src_dir" >/dev/null
  make mrproper
  make headers
  find usr/include -name '.*' -delete
  rm -f usr/include/Makefile
  cp -r usr/include "${LFS_ROOT}/usr"
  popd >/dev/null
}
