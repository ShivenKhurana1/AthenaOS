#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_linux
ensure_dirs

ORDER_REF="${1:-}"
if [[ -z "$ORDER_REF" ]]; then
  log "Usage: run-recipes.sh <order-file>"
  exit 1
fi

ORDER_FILE="$ORDER_REF"
if [[ "$ORDER_FILE" != /* ]]; then
  ORDER_FILE="${RECIPES_DIR}/${ORDER_FILE}"
fi

if [[ ! -f "$ORDER_FILE" && -f "${ORDER_FILE}.order" ]]; then
  ORDER_FILE="${ORDER_FILE}.order"
fi

if [[ ! -f "$ORDER_FILE" ]]; then
  log "Order file not found: $ORDER_FILE"
  exit 1
fi

LFS_ROOT="${LFS_ROOT:-${ROOTFS_DIR}}"
mkdir -p "$LFS_ROOT"

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

run_recipe() {
  local recipe_ref="$1"
  local recipe_file="${RECIPES_DIR}/${recipe_ref}.sh"

  if [[ ! -f "$recipe_file" ]]; then
    log "Recipe not found: $recipe_file"
    exit 1
  fi

  local recipe_id
  recipe_id="${recipe_ref//\//-}"

  local recipe_work_dir
  recipe_work_dir="${BUILD_DIR}/recipes/${recipe_id}"
  mkdir -p "$recipe_work_dir"

  log "==> ${recipe_ref}"
  (
    export LFS_ROOT SOURCES_DIR PATCHES_DIR BUILD_DIR
    export RECIPE_WORK_DIR="$recipe_work_dir"
    export RECIPE_FILE="$recipe_file"
    export RECIPE_REF="$recipe_ref"

    # shellcheck source=lib/recipe-helpers.sh
    source "${SCRIPT_DIR}/lib/recipe-helpers.sh"

    # shellcheck source=/dev/null
    source "$recipe_file"

    local name="${recipe_name:-$recipe_ref}"
    log "Running ${name}"

    if declare -f recipe_build >/dev/null 2>&1; then
      recipe_build
    fi

    if declare -f recipe_install >/dev/null 2>&1; then
      recipe_install
    else
      log "Missing recipe_install in $recipe_file"
      exit 1
    fi

    if declare -f recipe_post >/dev/null 2>&1; then
      recipe_post
    fi
  )
}

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%%#*}"
  line="$(trim "$line")"
  if [[ -z "$line" ]]; then
    continue
  fi
  run_recipe "$line"
done < "$ORDER_FILE"
