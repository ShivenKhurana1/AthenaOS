#!/usr/bin/env bash
set -euo pipefail

recipe_find_source() {
  local pattern="$1"
  local match
  match=$(ls -1 "${SOURCES_DIR}/${pattern}" 2>/dev/null | tail -n 1 || true)
  if [[ -z "$match" ]]; then
    log "Source not found for pattern: ${pattern}"
    log "Add the tarball to ${SOURCES_DIR}."
    exit 1
  fi
  printf '%s\n' "$match"
}

recipe_unpack() {
  local tarball="$1"
  local work="${RECIPE_WORK_DIR}/src"
  rm -rf "$work"
  mkdir -p "$work"
  tar -xf "$tarball" -C "$work"

  local src_dir
  src_dir=$(find "$work" -mindepth 1 -maxdepth 1 -type d | head -n 1)
  if [[ -z "$src_dir" ]]; then
    log "Source dir not found after extracting ${tarball}"
    exit 1
  fi
  printf '%s\n' "$src_dir"
}

recipe_configure_make_install() {
  local src_dir="$1"
  shift

  pushd "$src_dir" >/dev/null
  ./configure "$@"
  make -j"$(cpu_count)"
  make DESTDIR="$LFS_ROOT" install
  popd >/dev/null
}
