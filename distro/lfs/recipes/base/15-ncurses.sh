#!/usr/bin/env bash
set -euo pipefail

recipe_name="ncurses"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "ncurses-*")")

  recipe_configure_make_install "$src_dir" \
    --prefix=/usr \
    --libdir=/usr/lib \
    --mandir=/usr/share/man \
    --with-shared \
    --without-debug \
    --enable-widec \
    --enable-pc-files \
    --with-pkg-config-libdir=/usr/lib/pkgconfig

  if [[ -f "${LFS_ROOT}/usr/lib/libncursesw.so" ]]; then
    ln -sf libncursesw.so "${LFS_ROOT}/usr/lib/libncurses.so"
  fi
}
