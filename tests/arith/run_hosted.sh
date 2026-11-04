#!/usr/bin/env bash
# Runs tests/arith/vectors.txt against the hosted interpreter while it exists.
#   usage: bash tests/arith/run_hosted.sh ./frac
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
frac=$(realpath "$1")
cd "$repo"
vectors=tests/arith/vectors.txt
awk -F' => ' '/^#/ || NF==0 { next } { print $1 " ." }' "$vectors" |
    "$frac" 2>&1 | sed -e 's/^Frac> //' -e 's/∞/inf/' -e 's/⊥/NaN/' -e '/^$/d' -e '/^Frac>/d' |
    paste -d'|' <(awk -F' => ' '/^#/ || NF==0 { next } { print $1 "|" $2 }' "$vectors") - |
    awk -F'|' '$2 != $3 { bad++; if (bad <= 40) printf "FAIL: %s\n  expected %s\n  actual   %s\n", $1, $2, $3 }
               END { printf "%d of %d vectors differ\n", bad + 0, NR; exit bad != 0 }'
echo "PASS: hosted interpreter matches tests/arith/vectors.txt"
