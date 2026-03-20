#!/usr/bin/env bash
set -euo pipefail

recipe_name="mpc"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "mpc-*")")

  CPPFLAGS="-I${LFS_ROOT}/usr/include" \
  LDFLAGS="-L${LFS_ROOT}/usr/lib" \
  LD_LIBRARY_PATH="${LFS_ROOT}/usr/lib" \
  PKG_CONFIG_PATH="${LFS_ROOT}/usr/lib/pkgconfig" \
  recipe_configure_make_install "$src_dir" --prefix=/usr --disable-static \
    --with-gmp="${LFS_ROOT}/usr" \
    --with-mpfr="${LFS_ROOT}/usr"
}
