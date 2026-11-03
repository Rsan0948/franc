#!/bin/sh
# Stage trusted Franc source files as a NUL-terminated stream on a QEMU disk.
# No Python, awk, C compiler or C runtime is used in this packaging path.
set -eu
if [ "$#" -lt 2 ]; then
    echo "usage: sh source_pack.sh IMAGE SOURCE.frac..." >&2
    exit 2
fi
image=$1
shift
scratch=$(mktemp)
trap 'rm -f "$scratch"' EXIT HUP INT TERM
for source in "$@"; do
    cat "$source" >> "$scratch"
    printf '\n' >> "$scratch"
done
printf '\000' >> "$scratch"
bytes=$(wc -c < "$scratch" | tr -d ' ')
if [ "$bytes" -gt 131071 ]; then
    echo "Franc source bundle exceeds 131071 bytes" >&2
    exit 1
fi
sectors=$(( (bytes + 511) / 512 ))
dd if=/dev/zero of="$image" bs=512 seek=512 count=$((sectors + 1)) conv=notrunc status=none
printf FRANCSRC | dd of="$image" bs=512 seek=512 conv=notrunc status=none
dd if="$scratch" of="$image" bs=512 seek=513 conv=notrunc status=none
