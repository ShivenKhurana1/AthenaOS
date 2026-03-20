#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools gcc make bison flex gawk tar xz
ensure_dirs

mkdir -p "${BUILD_DIR}/toolchain" "${LFS_MNT}"

log "Toolchain bootstrap scaffold created."
log "Next: implement LFS book steps in recipes and script phases."
log "Mount rootfs at $LFS_MNT and run build-base.sh when ready."
