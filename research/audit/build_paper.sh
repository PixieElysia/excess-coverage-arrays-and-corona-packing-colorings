#!/usr/bin/env bash
# Rebuild a manuscript outside the worktree and report actionable TeX diagnostics.
set -euo pipefail

if [[ $# != 2 || ( "$1" != excess-arrays && "$1" != packing-corona ) ]]; then
  printf '%s\n' 'Usage: build_paper.sh {excess-arrays|packing-corona} OUTPUT_DIRECTORY' >&2
  exit 2
fi

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.."
project=$1
mkdir -p -- "$2"
output=$(cd -- "$2" && pwd)
cd -- "$project"
latexmk -pdf -halt-on-error -interaction=nonstopmode -outdir="$output" paper.tex
pdfinfo "$output/paper.pdf"
if grep -E 'Overfull|undefined references|undefined citations|undefined on input|multiply defined|Undefined control sequence' "$output/paper.log"; then
  printf '%s\n' 'Actionable LaTeX diagnostics found.' >&2
  exit 1
fi
