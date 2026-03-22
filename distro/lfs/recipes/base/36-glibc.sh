#!/usr/bin/env bash
set -euo pipefail

recipe_name="glibc"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "glibc-*")")

  mkdir -p "${RECIPE_WORK_DIR}/build"
  pushd "${RECIPE_WORK_DIR}/build" >/dev/null
  "${src_dir}/configure" \
    --prefix=/usr \
    --disable-werror \
    --enable-kernel=4.14 \
    --with-headers="${LFS_ROOT}/usr/include" \
    --without-selinux
  make -j"$(cpu_count)"
  make DESTDIR="$LFS_ROOT" install
  popd >/dev/null
}
