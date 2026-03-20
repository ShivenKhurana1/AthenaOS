#!/usr/bin/env bash
set -euo pipefail

recipe_name="systemd-config"

recipe_install() {
  local root="${LFS_ROOT:?}"

  install -d -m 0755 "${root}/etc/systemd/system"

  ln -sf /usr/lib/systemd/system/multi-user.target "${root}/etc/systemd/system/default.target"
}
