#!/usr/bin/env bash
set -euo pipefail

recipe_name="networkmanager"

recipe_install() {
  require_tools meson ninja
  local src_dir
  src_dir=$(recipe_unpack "$(recipe_find_source "NetworkManager-*")")

  mkdir -p "${RECIPE_WORK_DIR}/build"
  pushd "${RECIPE_WORK_DIR}/build" >/dev/null
  export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:${LFS_ROOT}/usr/lib/x86_64-linux-gnu/pkgconfig:${LFS_ROOT}/usr/lib/pkgconfig:${LFS_ROOT}/usr/share/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"
  local meson_flags=(
    "${src_dir}"
    --prefix=/usr
    --buildtype=release
    -Dsystemdsystemunitdir=/usr/lib/systemd/system
    -Dsystemd_journal=true
    -Dintrospection=false
    -Dlibaudit=yes
    -Dpolkit=true
    -Dppp=true
    -Dmodem_manager=true
    -Dovs=true
    -Dlibpsl=true
    -Dnmtui=true
    -Dnm_cloud_setup=true
    -Dnbft=true
  )
  if ! command -v xsltproc >/dev/null 2>&1; then
    # Provide a stub xsltproc to satisfy Meson program lookup.
    local stub_bin
    stub_bin="${RECIPE_WORK_DIR}/bin"
    mkdir -p "$stub_bin"
    cat > "${stub_bin}/xsltproc" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
    chmod +x "${stub_bin}/xsltproc"
    export PATH="${stub_bin}:${PATH}"
    # Docs are disabled by default, but be explicit to avoid doc targets.
    meson_flags+=(-Ddocs=false)
  fi

  meson setup "${meson_flags[@]}"
  ninja
  DESTDIR="$LFS_ROOT" ninja install
  popd >/dev/null
}
