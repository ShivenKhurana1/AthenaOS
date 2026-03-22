#!/usr/bin/env bash
set -euo pipefail

recipe_name="gcc"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "gcc-*")")

  mkdir -p "${RECIPE_WORK_DIR}/build"
  pushd "${RECIPE_WORK_DIR}/build" >/dev/null
  PATH="${LFS_ROOT}/usr/bin:${PATH}" \
  CPPFLAGS="-I${LFS_ROOT}/usr/include" \
  LDFLAGS="-L${LFS_ROOT}/usr/lib" \
  LD_LIBRARY_PATH="${LFS_ROOT}/usr/lib" \
  "${src_dir}/configure" \
    --prefix=/usr \
    --enable-languages=c,c++ \
    --disable-multilib \
    --disable-static \
    --with-gmp="${LFS_ROOT}/usr" \
    --with-mpfr="${LFS_ROOT}/usr" \
    --with-mpc="${LFS_ROOT}/usr"
  make -j"$(cpu_count)"
  make DESTDIR="$LFS_ROOT" install
  popd >/dev/null
}
