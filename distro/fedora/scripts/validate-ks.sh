#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KS="$ROOT/kickstarts/athenaos.ks"
KS_VERSION="${KS_VERSION:-F40}"

ksvalidator --version "$KS_VERSION" "$KS"
