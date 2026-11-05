#!/usr/bin/env bash
# The final self-hosting proof. Runs tests/image with every host compiler, assembler
# and linker blocked: each one fails and is recorded if anything calls it. IMAGE is
# the only thing that comes from them, and the guest must reproduce it exactly.
# CI also deletes these tools from the machine before running this.
#   usage: bash tests/selfhost/run.sh IMAGE
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "$1")
cd "$repo"
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT HUP INT TERM

blocked=$scratch/blocked
mkdir "$blocked"
log=$scratch/calls
: > "$log"
for tool in as ld ld.bfd ld.gold objcopy objdump gcc cc clang python3 python make; do
    printf '#!/bin/sh\necho %s >> %s\nexit 127\n' "$tool" "$log" > "$blocked/$tool"
    chmod +x "$blocked/$tool"
done
PATH=$blocked:$PATH
if as --version >/dev/null 2>&1; then echo "FAIL: as is not blocked"; exit 1; fi
: > "$log"

status=0
bash tests/image/run.sh "$image" || status=1
if [ -s "$log" ]; then
    echo "FAIL: the rebuild called blocked tools: $(sort -u "$log" | tr '\n' ' ')"
    status=1
else
    echo "PASS: no compiler, assembler, linker or Python ran during the rebuild"
fi
exit "$status"
