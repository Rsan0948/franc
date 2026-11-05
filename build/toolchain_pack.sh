#!/bin/sh
# Stage the guest toolchain as a verified archive at LBA 2048 of a disk image.
# Sector 0 onward is a text table of 128-byte records, then each file, sector
# aligned and NUL terminated. Record 0 is "FRANCTCH 1 COUNT SECTORS TABLE-SHA256";
# every other record is "NAME OFFSET SIZE SHA256". Offsets are from the archive
# start. Needs only shell, dd, wc and sha256sum. Run from the repository root.
#   usage: sh build/toolchain_pack.sh IMAGE [EXTRA-FILE...]
set -eu
if [ "$#" -lt 1 ]; then
    echo "usage: sh build/toolchain_pack.sh IMAGE [EXTRA-FILE...]" >&2
    exit 2
fi
image=$1
shift
lba=2048
limit=4194304
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT HUP INT TERM

# The kernel's Franc sources travel as the one ordered stream the AOT compiler reads.
: > "$scratch/kernel-source.stream"
while IFS= read -r src || [ -n "$src" ]; do
    case "$src" in ''|'#'*) continue ;; esac
    cat "$src" >> "$scratch/kernel-source.stream"
    printf '\n' >> "$scratch/kernel-source.stream"
done < build/seed_sources.list

sed '/^#/d; /^[[:space:]]*$/d' build/toolchain_sources.list > "$scratch/names"
echo kernel-source.stream >> "$scratch/names"
for extra in "$@"; do echo "$extra" >> "$scratch/names"; done

count=$(wc -l < "$scratch/names" | tr -d ' ')
table_sectors=$(( ((count + 1) * 128 + 511) / 512 ))
offset=$((table_sectors * 512))
: > "$scratch/table"
: > "$scratch/data"
while IFS= read -r name; do
    file=$name
    if [ "$name" = kernel-source.stream ]; then file=$scratch/kernel-source.stream; fi
    test -f "$file" || { echo "missing toolchain source: $name" >&2; exit 1; }
    if [ "${#name}" -gt 44 ]; then echo "toolchain name too long: $name" >&2; exit 1; fi
    size=$(wc -c < "$file" | tr -d ' ')
    hash=$(sha256sum "$file" | cut -d ' ' -f 1)
    printf '%-44s %08d %08d %s\n' "$name" "$offset" "$size" "$hash" >> "$scratch/table"
    sectors=$(( (size + 512) / 512 ))
    cat "$file" >> "$scratch/data"
    dd if=/dev/zero bs=1 count=$((sectors * 512 - size)) status=none >> "$scratch/data"
    offset=$((offset + sectors * 512))
done < "$scratch/names"
if [ "$offset" -gt "$limit" ]; then
    echo "toolchain archive exceeds $limit bytes" >&2
    exit 1
fi
table_hash=$(sha256sum "$scratch/table" | cut -d ' ' -f 1)
printf '%-127s\n' "$(printf 'FRANCTCH 1 %08d %08d %s' "$count" "$((offset / 512))" "$table_hash")" > "$scratch/header"
dd if=/dev/zero of="$image" bs=512 seek="$lba" count="$table_sectors" conv=notrunc status=none
cat "$scratch/header" "$scratch/table" | dd of="$image" bs=512 seek="$lba" conv=notrunc status=none
dd if="$scratch/data" of="$image" bs=512 seek=$((lba + table_sectors)) conv=notrunc status=none
