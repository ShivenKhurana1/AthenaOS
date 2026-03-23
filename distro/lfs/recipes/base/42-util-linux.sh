#!/usr/bin/env bash
set -euo pipefail

recipe_name="util-linux"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "util-linux-*")")

  pushd "$src_dir" >/dev/null
  ./configure \
    --prefix=/usr \
    --disable-static \
    --without-python

  # Patch install hooks to avoid chown/chgrp failures on non-root builds.
  local hook_files
  hook_files=$(grep -R -l -E '^\s*(chown|chgrp)\b' . 2>/dev/null || true)
  if [[ -n "$hook_files" ]]; then
    while IFS= read -r hook_file; do
      [[ -z "$hook_file" ]] && continue
      sed -i -E 's/^\s*(chown|chgrp)\b/# &/' "$hook_file"
    done <<< "$hook_files"
  fi

  make -j"$(cpu_count)"
  make DESTDIR="$LFS_ROOT" install
  popd >/dev/null
}
