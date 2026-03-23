#!/usr/bin/env bash
set -euo pipefail

recipe_name="kmod"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "kmod-*")")

  local configure_flags=(--prefix=/usr --disable-static)
  if ! command -v scdoc >/dev/null 2>&1; then
    # Skip manpages when scdoc is unavailable to avoid configure failure.
    configure_flags+=(--disable-manpages)
  fi

  recipe_configure_make_install "$src_dir" "${configure_flags[@]}"
}
