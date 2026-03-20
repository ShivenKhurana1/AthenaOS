#!/usr/bin/env bash
set -euo pipefail

recipe_name="eudev"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "eudev-*")")

  recipe_configure_make_install "$src_dir" --prefix=/usr --sysconfdir=/etc --disable-static
}
