#!/usr/bin/env bash
set -euo pipefail

recipe_name="bash"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "bash-*")")

  recipe_configure_make_install "$src_dir" --prefix=/usr --without-bash-malloc

  ln -sf bash "${LFS_ROOT}/usr/bin/sh"
}
