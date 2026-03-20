#!/usr/bin/env bash
set -euo pipefail

recipe_name="base-skel"

recipe_install() {
  local root="${LFS_ROOT:?}"

  install -d -m 0755 "${root}/etc/skel" "${root}/root"

  cat > "${root}/etc/skel/.profile" <<'EOF'
export PATH=/usr/bin:/usr/sbin
EOF

  cat > "${root}/etc/skel/.bashrc" <<'EOF'
export PATH=/usr/bin:/usr/sbin
EOF

  cp -a "${root}/etc/skel/." "${root}/root/" || true
}
