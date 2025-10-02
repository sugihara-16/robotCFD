#!/usr/bin/env bash
# dump_case.sh - OpenFOAMケースの主要設定ファイルを case.txt にまとめる（指定リスト & 0/cellToRegion 除外版）

set -euo pipefail

OUT="case.txt"
: > "$OUT"

# テキスト判定（辞書/設定ファイル想定）
is_text() {
  local f="$1"
  LC_ALL=C grep -Iq . "$f" 2>/dev/null
}

print_header() {
  local f="$1"
  {
    echo "============================================================"
    echo "FILE: $f"
    echo "============================================================"
  } >> "$OUT"
}

append_file() {
  local f="$1"
  [[ -f "$f" || -L "$f" ]] || return 0

  # 0/配下の cellToRegion を除外（ファイル名一致で除外、サブ領域側も保険で除外）
  case "$f" in
    0/cellToRegion|0/*/cellToRegion) return 0 ;;
  esac

  if is_text "$f"; then
    print_header "$f"
    cat -- "$f" >> "$OUT"
    echo -e "\n" >> "$OUT"
  else
    {
      echo "============================================================"
      echo "FILE: $f"
      echo "!! Skipped (binary-like file)"
      echo
    } >> "$OUT"
  fi
}

# --- 0/以外でデフォルトで探すファイル（ご指定のリストのみ） ---
declare -a CANDIDATES=(
  # system
  "system/controlDict"
  "system/fvSchemes"
  "system/fvSolution"
  "system/decomposeParDict"
  "system/blockMeshDict"
  "system/snappyHexMeshDict"
  "system/topoSetDict"
  "system/createBafflesDict"
  "system/topoSet_rotorZones.dict"
  "system/forces"
  "system/surfaces"
  "system/surfaceFeaturesDict"

  "Allrun"
  "Allclean"
  "Allmesh"

  # constant
  "constant/transportProperties"
  "constant/thermophysicalProperties"
  "constant/turbulenceProperties"
  "constant/RASProperties"
  "constant/LESProperties"
  "constant/regionProperties"
  "constant/MRFProperties"
  "constant/momentumTransport"
  "constant/physicalProperties"
  "constant/dynamicMeshDict"
  "constant/geometry/README"
)

# 指定された候補のみを走査
for f in "${CANDIDATES[@]}"; do
  [[ -e "$f" ]] && append_file "$f"
done

# --- 0/ 配下の場ファイルを自動収集（cellToRegion は除外） ---
if [[ -d "0" ]]; then
  # 0/ 直下のファイル
  while IFS= read -r -d '' f; do
    append_file "$f"
  done < <(find 0 -maxdepth 1 -type f -print0 | sort -z)

  # 0/regionName/*（サブ領域の場ファイルも拾う。ただし cellToRegion は除外される）
  while IFS= read -r -d '' d; do
    while IFS= read -r -d '' f; do
      append_file "$f"
    done < <(find "$d" -maxdepth 1 -type f -print0 | sort -z)
  done < <(find 0 -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
fi

echo "完了: case.txt に主要ファイルの内容をまとめました。"
#!/usr/bin/env bash
# dump_case.sh - OpenFOAMケースの主要設定ファイルを case.txt にまとめる（指定リスト & 0/cellToRegion 除外版）

set -euo pipefail

OUT="case.txt"
: > "$OUT"

# テキスト判定（辞書/設定ファイル想定）
is_text() {
  local f="$1"
  LC_ALL=C grep -Iq . "$f" 2>/dev/null
}

print_header() {
  local f="$1"
  {
    echo "============================================================"
    echo "FILE: $f"
    echo "============================================================"
  } >> "$OUT"
}

append_file() {
  local f="$1"
  [[ -f "$f" || -L "$f" ]] || return 0

  # 0/配下の cellToRegion を除外（ファイル名一致で除外、サブ領域側も保険で除外）
  case "$f" in
    0/cellToRegion|0/*/cellToRegion) return 0 ;;
  esac

  if is_text "$f"; then
    print_header "$f"
    cat -- "$f" >> "$OUT"
    echo -e "\n" >> "$OUT"
  else
    {
      echo "============================================================"
      echo "FILE: $f"
      echo "!! Skipped (binary-like file)"
      echo
    } >> "$OUT"
  fi
}

# --- 0/以外でデフォルトで探すファイル（ご指定のリストのみ） ---
declare -a CANDIDATES=(
  # system
  "system/controlDict"
  "system/fvSchemes"
  "system/fvSolution"
  "system/decomposeParDict"
  "system/blockMeshDict"
  "system/snappyHexMeshDict"
  "system/topoSetDict"
  "system/createBafflesDict"
  "system/topoSet_rotorZones.dict"
  "system/forces"
  "system/surfaces"
  "system/surfaceFeaturesDict"

  "Allrun"
  "Allclean"
  "Allmesh"

  # constant
  "constant/transportProperties"
  "constant/thermophysicalProperties"
  "constant/turbulenceProperties"
  "constant/RASProperties"
  "constant/LESProperties"
  "constant/regionProperties"
  "constant/MRFProperties"
  "constant/momentumTransport"
  "constant/physicalProperties"
  "constant/dynamicMeshDict"
  "constant/geometry/README"
)

# 指定された候補のみを走査
for f in "${CANDIDATES[@]}"; do
  [[ -e "$f" ]] && append_file "$f"
done

# --- 0/ 配下の場ファイルを自動収集（cellToRegion は除外） ---
if [[ -d "0" ]]; then
  # 0/ 直下のファイル
  while IFS= read -r -d '' f; do
    append_file "$f"
  done < <(find 0 -maxdepth 1 -type f -print0 | sort -z)

  # 0/regionName/*（サブ領域の場ファイルも拾う。ただし cellToRegion は除外される）
  while IFS= read -r -d '' d; do
    while IFS= read -r -d '' f; do
      append_file "$f"
    done < <(find "$d" -maxdepth 1 -type f -print0 | sort -z)
  done < <(find 0 -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
fi

echo "完了: case.txt に主要ファイルの内容をまとめました。"
