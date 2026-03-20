#!/usr/bin/env bash
set -euo pipefail

recipe_name="base-users"

recipe_install() {
  local root="${LFS_ROOT:?}"

  install -d -m 0755 "${root}/etc"

  cat > "${root}/etc/passwd" <<'EOF'
root:x:0:0:root:/root:/bin/sh
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
EOF

  cat > "${root}/etc/group" <<'EOF'
root:x:0:
nobody:x:65534:
EOF

  cat > "${root}/etc/shadow" <<'EOF'
root::10933:0:99999:7:::
nobody:*:10933:0:99999:7:::
EOF

  chmod 0644 "${root}/etc/passwd" "${root}/etc/group"
  chmod 0640 "${root}/etc/shadow"
}
