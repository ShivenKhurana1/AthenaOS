#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOPDIR="$ROOT/packaging/rpmbuild"
REPO="$ROOT/repo"
VERSION="${VERSION:-0.1.0}"

mkdir -p "$TOPDIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS} "$REPO"

cp "$ROOT/packaging/athena-theme/athena-theme.spec" "$TOPDIR/SPECS/"
cp "$ROOT/packaging/athena-shell-extension/athena-shell-extension.spec" "$TOPDIR/SPECS/"

tar --transform "s,^,athena-theme-${VERSION}/," -C "$ROOT" -czf \
  "$TOPDIR/SOURCES/athena-theme-${VERSION}.tar.gz" theme branding config LICENSE

tar --transform "s,^,athena-shell-extension-${VERSION}/," -C "$ROOT" -czf \
  "$TOPDIR/SOURCES/athena-shell-extension-${VERSION}.tar.gz" extensions/athena-shell LICENSE

rpmbuild --define "_topdir $TOPDIR" -ba "$TOPDIR/SPECS/athena-theme.spec"
rpmbuild --define "_topdir $TOPDIR" -ba "$TOPDIR/SPECS/athena-shell-extension.spec"

find "$TOPDIR/RPMS" -name "*.rpm" -exec cp -v {} "$REPO" \;

createrepo_c "$REPO"
