#!/usr/bin/env bash
set -euo pipefail

recipe_name="mpfr"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "mpfr-*")")

  CPPFLAGS="-I${LFS_ROOT}/usr/include" \
  LDFLAGS="-L${LFS_ROOT}/usr/lib" \
  LD_LIBRARY_PATH="${LFS_ROOT}/usr/lib" \
  recipe_configure_make_install "$src_dir" --prefix=/usr --disable-static --with-gmp="${LFS_ROOT}/usr"
}
