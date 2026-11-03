#!/bin/sh
# Build a full bootable FrancOS image with Franc AOT + x86-64 assembly only.
# The seed image already contains a compiled Franc compiler. No Python/C here.
set -eu
if [ "$#" -ne 2 ]; then
    echo "usage: sh build_selfhost.sh SEED.img OUTPUT.img" >&2
    exit 2
fi
seed=$1
output=$2
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
stage="$root/stage4"
tmp=$(mktemp -d)
qpid=
cleanup() {
    if [ -n "$qpid" ]; then kill "$qpid" 2>/dev/null || :; fi
    rm -rf "$tmp"
}
trap cleanup EXIT HUP INT TERM
cp "$seed" "$tmp/source.img"
sh "$stage/source_pack.sh" --auto "$tmp/source.img" \
    "$root/stage3/ata.frac" "$root/stage3/storage.frac" \
    "$stage/display.frac" "$stage/keyboard.frac" \
    "$root/stage2/compiler.frac" "$stage/repl.frac" \
    "$stage/upgrade.frac" "$stage/aot.frac" \
    "$stage/aot_dict.frac" "$stage/bundle.frac" "$stage/kernel.frac"
mkfifo "$tmp/serial"
# Compiler diagnostics are excluded; only the Franc-generated assembly is
# captured. The sed process exits on the exact end marker, then QEMU is killed.
timeout 600 qemu-system-x86_64 -m 128M -accel tcg -display none \
    -monitor none -no-reboot -serial stdio \
    -drive "file=$tmp/source.img,format=raw,if=ide" \
    </dev/null >"$tmp/serial" 2>"$tmp/qemu.stderr" &
qpid=$!
sed -n '/^FRANC-PROGRAM-BEGIN$/{:body;n;/^FRANC-PROGRAM-END$/q;p;b body;}' \
    <"$tmp/serial" >"$tmp/kernel.S"
kill "$qpid" 2>/dev/null || :
wait "$qpid" 2>/dev/null || :
qpid=
test -s "$tmp/kernel.S" || { echo "Franc emitted no kernel assembly" >&2; exit 1; }
grep -q '^.global franc_dict_initial$' "$tmp/kernel.S" || {
    echo "Franc did not emit a native dictionary" >&2; exit 1;
}
grep -q '^franc_stage2_source:$' "$tmp/kernel.S" || {
    echo "Franc did not emit the self-host compiler source" >&2; exit 1;
}
# .incbin "stage2/compiler.frac" paths in Franc's assembly are repo-relative.
(cd "$root" && as --64 -o "$tmp/program.o" "$tmp/kernel.S")
as --64 -o "$tmp/runtime.o" "$stage/runtime.S"
as --64 -o "$tmp/font.o" "$stage/font.S"
as --64 -o "$tmp/entry.o" "$stage/aot_entry.S"
ld -m elf_x86_64 -nostdlib -T "$stage/kernel.ld" -o "$tmp/kernel.elf" \
    "$tmp/runtime.o" "$tmp/font.o" "$tmp/entry.o" "$tmp/program.o"
objcopy -O binary -j .text -j .rodata -j .data \
    "$tmp/kernel.elf" "$tmp/kernel.bin"
bytes=$(wc -c <"$tmp/kernel.bin" | tr -d ' ')
test "$bytes" -gt 0 && test "$bytes" -le 158720 || {
    echo "Franc kernel exceeds 310-sector BIOS loader: $bytes" >&2; exit 1;
}
dd if=/dev/zero of="$output" bs=512 count=512 status=none
dd if="$stage/boot.bin" of="$output" conv=notrunc status=none
dd if="$tmp/kernel.bin" of="$output" bs=512 count=127 \
    seek=1 conv=notrunc status=none
dd if="$tmp/kernel.bin" of="$output" bs=512 skip=127 count=56 \
    seek=200 conv=notrunc status=none
dd if="$tmp/kernel.bin" of="$output" bs=512 skip=183 count=127 \
    seek=256 conv=notrunc status=none
printf FRANCFS1 | dd of="$output" bs=512 seek=128 \
    conv=notrunc status=none
echo "PASS: Franc compiled complete C-free kernel ($bytes bytes); Python not invoked"
