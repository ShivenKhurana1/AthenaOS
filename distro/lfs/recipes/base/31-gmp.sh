#!/usr/bin/env bash
set -euo pipefail

recipe_name="gmp"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "gmp-*")")

  recipe_configure_make_install "$src_dir" --prefix=/usr --enable-cxx --disable-static
}
