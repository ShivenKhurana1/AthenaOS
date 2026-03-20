#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools meson ninja cmake
ensure_dirs

if [[ ! -d "${LFS_MNT}" ]]; then
  log "Rootfs mount not found at $LFS_MNT. Run build-base.sh first."
  exit 1
fi

log "Desktop stack scaffold created."
log "TODO: build GNOME stack and install Athena assets into $LFS_MNT."
