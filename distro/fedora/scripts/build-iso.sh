#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KS="$ROOT/kickstarts/athenaos.ks"
OUT="$ROOT/out"
REPO="$ROOT/repo"

RELEASEVER="${RELEASEVER:-40}"
ARCH="${ARCH:-x86_64}"
VERSION="${VERSION:-0.1}"
PROJECT="AthenaOS"
VOLID="ATHENAOS-${VERSION}"

if [[ ! -f "$KS" ]]; then
  echo "Kickstart not found: $KS" >&2
  exit 1
fi

if [[ ! -d "$REPO/repodata" ]]; then
  echo "Local repo not found: $REPO" >&2
  echo "Run ./distro/fedora/scripts/build-packages.sh first." >&2
  exit 1
fi

mkdir -p "$OUT"

sudo livemedia-creator \
  --make-iso \
  --iso-only \
  --no-virt \
  --ks "$KS" \
  --resultdir "$OUT" \
  --project "$PROJECT" \
  --releasever "$RELEASEVER" \
  --volid "$VOLID" \
  --repo "https://mirrors.fedoraproject.org/metalink?repo=fedora-${RELEASEVER}&arch=${ARCH}" \
  --repo "https://mirrors.fedoraproject.org/metalink?repo=updates-released-f${RELEASEVER}&arch=${ARCH}" \
  --repo "file://${REPO}"
