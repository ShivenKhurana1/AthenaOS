#!/usr/bin/env bash
set -euo pipefail

recipe_name="sudo"

recipe_install() {
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "sudo-*")")

  pushd "$src_dir" >/dev/null
  local configure_flags=(--prefix=/usr --sysconfdir=/etc --with-all-insults)
  if ! command -v scdoc >/dev/null 2>&1; then
    # Skip manpages when scdoc is unavailable to avoid configure failure.
    configure_flags+=(--disable-manpages)
  fi

  ./configure "${configure_flags[@]}"

  # Patch install hooks to avoid chown/chgrp and install -o/-g in non-root builds.
  local hook_files
  hook_files=$(grep -R -l -E '(^|[[:space:]])(chown|chgrp)\b' . 2>/dev/null || true)
  if [[ -n "$hook_files" ]]; then
    while IFS= read -r hook_file; do
      [[ -z "$hook_file" ]] && continue
      sed -i -E 's/^[[:space:]]*(chown|chgrp)\b/# &/' "$hook_file"
    done <<< "$hook_files"
  fi

  local makefiles
  makefiles=$(find . -type f -name 'Makefile' -o -name 'Makefile.in' -o -name '*.mk')
  if [[ -n "$makefiles" ]]; then
    while IFS= read -r makefile; do
      [[ -z "$makefile" ]] && continue
      sed -i -E '/\$\(INSTALL\)|[[:space:]]install[[:space:]]/ s/[[:space:]]-o[[:space:]]+[^[:space:]]+//g' "$makefile"
      sed -i -E '/\$\(INSTALL\)|[[:space:]]install[[:space:]]/ s/[[:space:]]-g[[:space:]]+[^[:space:]]+//g' "$makefile"
    done <<< "$makefiles"
  fi

  make -j"$(cpu_count)"
  make DESTDIR="$LFS_ROOT" install \
    CHOWN=true \
    CHGRP=true \
    INSTALL_OWNER= \
    INSTALL_GROUP=
  popd >/dev/null
}
