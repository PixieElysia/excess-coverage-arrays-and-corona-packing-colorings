#!/usr/bin/env bash
# Produce the Chinese PDF and intermediate TeX from the Markdown manuscript.
set -euo pipefail

if [[ $# != 2 || ( "$1" != excess-arrays && "$1" != packing-corona ) ]]; then
  printf '%s\n' 'Usage: build_chinese_paper.sh {excess-arrays|packing-corona} OUTPUT_DIRECTORY' >&2
  exit 2
fi

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.."
project=$1
mkdir -p -- "$2"
output=$(cd -- "$2" && pwd)
title=$(sed -n '1s/^# //p' "$project/paper.zh-CN.md")
header="$output/cjk-header.tex"
cat > "$header" <<'TEX'
\XeTeXlinebreaklocale "zh"
\XeTeXlinebreakskip = 0pt plus 1pt
\setlength{\emergencystretch}{2em}
TEX
printf '\\AtBeginDocument{\\hypersetup{pdftitle={%s},pdfauthor={CHATGPT ASTRA 6.2}}}\n' "$title" >> "$header"
pandoc --standalone --from=gfm+tex_math_dollars --to=latex \
    --metadata="pagetitle:$title" --metadata="author:CHATGPT ASTRA 6.2" --variable=mainfont:'Noto Serif CJK SC' \
    --variable=monofont:'Noto Sans Mono CJK SC' --variable=fontsize:11pt \
    --variable=papersize:a4 --variable=geometry:margin=25mm --variable=colorlinks:true \
    --variable=microtypeoptions:protrusion=false --lua-filter=research/audit/cjk_tables.lua \
    --include-in-header="$header" "$project/paper.zh-CN.md" --output="$output/paper.zh-CN.tex"
latexmk -xelatex -halt-on-error -interaction=nonstopmode -outdir="$output" "$output/paper.zh-CN.tex"
pdfinfo "$output/paper.zh-CN.pdf"
if grep -E 'Overfull|Missing character|undefined references|undefined citations|undefined on input|multiply defined|Undefined control sequence' "$output/paper.zh-CN.log"; then
  printf '%s\n' 'Actionable Chinese manuscript diagnostics found.' >&2
  exit 1
fi
