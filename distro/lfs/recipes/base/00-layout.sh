#!/usr/bin/env bash
set -euo pipefail

recipe_name="base-layout"

recipe_install() {
  local root="${LFS_ROOT:?}"

  install -d -m 0755 \
    "${root}/boot" \
    "${root}/dev" \
    "${root}/etc" \
    "${root}/home" \
    "${root}/mnt" \
    "${root}/opt" \
    "${root}/proc" \
    "${root}/root" \
    "${root}/run" \
    "${root}/srv" \
    "${root}/sys" \
    "${root}/tmp" \
    "${root}/usr/bin" \
    "${root}/usr/lib" \
    "${root}/usr/lib64" \
    "${root}/usr/sbin" \
    "${root}/usr/share" \
    "${root}/var/cache" \
    "${root}/var/lib" \
    "${root}/var/log" \
    "${root}/var/tmp"

  chmod 1777 "${root}/tmp" "${root}/var/tmp"

  if [[ ! -e "${root}/bin" ]]; then
    ln -s "usr/bin" "${root}/bin"
  fi

  if [[ ! -e "${root}/sbin" ]]; then
    ln -s "usr/sbin" "${root}/sbin"
  fi

  if [[ ! -e "${root}/lib" ]]; then
    ln -s "usr/lib" "${root}/lib"
  fi

  if [[ ! -e "${root}/lib64" ]]; then
    ln -s "usr/lib64" "${root}/lib64"
  fi

  if [[ ! -e "${root}/var/run" ]]; then
    ln -s ../run "${root}/var/run"
  fi

  if [[ ! -e "${root}/var/lock" ]]; then
    ln -s ../run/lock "${root}/var/lock"
  fi
}
