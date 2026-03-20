#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
require_tools curl sha256sum md5sum
ensure_dirs

MANIFEST="${MANIFEST_DIR}/versions.lock"

if [[ ! -s "$MANIFEST" ]]; then
  log "No sources defined in $MANIFEST. Populate it before running this script."
  exit 1
fi

while read -r name version url checksum; do
  [[ -z "$name" ]] && continue
  [[ "$name" == \#* ]] && continue

  if [[ -z "$version" || -z "$url" || -z "$checksum" ]]; then
    log "Invalid manifest entry: $name $version $url $checksum"
    exit 1
  fi

  filename="$(basename "$url")"
  out="${SOURCES_DIR}/${filename}"

  if [[ ! -f "$out" ]]; then
    log "Downloading $name $version"
    curl -L -o "$out" "$url"
  else
    log "Using cached $filename"
  fi

  if [[ "$checksum" == "-" ]]; then
    log "Warning: missing checksum for $name"
    continue
  fi

  algo="sha256"
  value="$checksum"

  case "$checksum" in
    md5:*)
      algo="md5"
      value="${checksum#md5:}"
      ;;
    sha256:*)
      algo="sha256"
      value="${checksum#sha256:}"
      ;;
  esac

  if [[ "$algo" == "md5" ]]; then
    echo "$value  $out" | md5sum -c -
  else
    echo "$value  $out" | sha256sum -c -
  fi

done < "$MANIFEST"
