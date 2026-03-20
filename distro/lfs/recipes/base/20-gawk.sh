#!/usr/bin/env bash
set -euo pipefail

recipe_name="gawk"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "gawk-*")")

  recipe_configure_make_install "$src_dir" --prefix=/usr
}
