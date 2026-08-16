#!/bin/bash

set -euo pipefail

INSTALL_DIR="${1:-/opt/bcmb_bootcamp/references/hg19}"
BASE_URL="https://ngi-igenomes.s3.amazonaws.com/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex"
SUFFIXES=("" .amb .ann .bwt .pac .sa)

if ! command -v wget >/dev/null 2>&1; then
  echo "Error: required command not found: wget" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"

for SUFFIX in "${SUFFIXES[@]}"; do
  FILE="genome.fa$SUFFIX"
  wget -c "$BASE_URL/$FILE" -O "$INSTALL_DIR/$FILE"
done

for SUFFIX in "${SUFFIXES[@]}"; do
  FILE="$INSTALL_DIR/genome.fa$SUFFIX"
  if [[ ! -s "$FILE" ]]; then
    echo "Error: downloaded file is missing or empty: $FILE" >&2
    exit 1
  fi
done

chmod -R a+rX "$INSTALL_DIR"

echo "Prebuilt hg19 reference and BWA index are ready in $INSTALL_DIR"
