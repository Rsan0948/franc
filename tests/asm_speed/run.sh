#!/usr/bin/env bash
# Phase 3 step 1: can a Franc assembler handle the seed in a usable time?
# Builds a throwaway kernel containing assembler.frac, assembles the seed in the
# guest, reports how long each stage took, and compares the guest's bytes with
# GNU as. Needs as, ld, objcopy, python3 and QEMU. Does not change the repo.
#   usage: bash tests/asm_speed/run.sh
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    if [ -n "${FRANC_ASM_LOG:-}" ] && [ -f "$scratch/serial.log" ]; then cp "$scratch/serial.log" "$FRANC_ASM_LOG"; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM

cp -a "$repo" "$scratch/tree"
tree=$scratch/tree
# The kernel size limit leaves no room for both, and this kernel never compiles anything.
sed -i 's#upgrade.frac aot.frac bundle.frac apps/registry.frac kernel.frac -o#upgrade.frac bundle.frac apps/registry.frac ../tests/asm_speed/assembler.frac kernel.frac -o#' "$tree/stage4/Makefile"
sed -i --follow-symlinks -e 's/^def bundle-demo .*/def bundle-demo 0 drop ;/' -e 's/^def bundle-kernel .*/def bundle-kernel 0 drop ;/' "$tree/compiler/bundle.frac"
sed -i "s/^OPS = { /OPS = { 'shl':'fr_lshift','shr':'fr_rshift',/" "$tree/stage4/compiler.py"
for word in aot-demo aot-program-demo aot-control-demo aot-string-reg-demo; do echo "def $word 0 drop ;" >> "$tree/compiler/bundle.frac"; done
make -C "$tree/stage4" franos-aot.img >"$scratch/build.log" 2>&1 || { tail -20 "$scratch/build.log" >&2; exit 1; }
echo "kernel bytes: $(wc -c < "$tree/stage4/kernel.bin") of 195584"

grep -v '\.incbin' "$repo/compiler/bootstrap_seed.S" > "$scratch/seed.S"
as --64 -o "$scratch/seed.o" "$scratch/seed.S"
for section in text rodata data; do
    objcopy -O binary -j ".$section" "$scratch/seed.o" "$scratch/want.$section"
done

disk=$scratch/disk.img
cp "$tree/stage4/franos-aot.img" "$disk"
printf 'def apps-init as-run ;\n' > "$scratch/bundle.frac"
(cd "$tree" && FRANC_SOURCE_LBA=1024 sh build/source_pack.sh "$disk" "$scratch/bundle.frac")
dd if="$repo/compiler/bootstrap_seed.S" of="$disk" bs=512 seek=2048 conv=notrunc status=none
size=$(wc -c < "$repo/compiler/bootstrap_seed.S")
dd if=/dev/zero of="$disk" bs=1 seek=$((2048 * 512 + size)) count=1024 conv=notrunc status=none
truncate -s 2M "$disk"

fifo=$scratch/keys
log=$scratch/serial.log
mkfifo "$fifo"
: > "$log"
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
    -serial stdio -drive "file=$disk,format=raw,if=ide" <"$fifo" >"$log" 2>&1 &
guest_pid=$!
exec 3>"$fifo"
now() { date +%s.%N; }
wait_for() {
    limit=$((SECONDS + $2))
    until grep -Fq "$1" "$log"; do
        if grep -Fq 'AS-FAILED' "$log" || [ "$SECONDS" -ge "$limit" ] || ! kill -0 "$guest_pid" 2>/dev/null; then
            echo "FAIL: guest did not print $1" >&2
            tail -c 300 "$log" >&2
            exit 1
        fi
        sleep 0.1
    done
}
wait_for 'Franc> ' 120
printf l >&3
start=$(now)
last=$start
for marker in AS-LOADED AS-PARSED AS-RELAXED AS-DONE; do
    wait_for "$marker" "${FRANC_ASM_LIMIT:-3600}"
    t=$(now)
    printf '%-11s %8.2fs  (total %8.2fs)\n' "$marker" "$(awk "BEGIN { print $t - $last }")" "$(awk "BEGIN { print $t - $start }")"
    last=$t
done
tr -d '\r' < "$log" | grep -E '^AS-(LOADED|PARSED|RELAXED|DONE)' || true
wait_for 'AS-END' 600
exec 3>&-

tr -d '\r' < "$log" > "$scratch/clean.log"
extract() { awk -v from="$1" -v to="$2" '$0 == to { on = 0 } on { printf "%s", $0 } $0 == from { on = 1 }' "$scratch/clean.log"; }
status=0
compare() {
    want=$(od -An -v -tx1 "$scratch/want.$1" | tr -d ' \n')
    got=$(extract "$2" "$3")
    if [ "$want" = "$got" ]; then
        echo "PASS: .$1 matches GNU as ($(( ${#want} / 2 )) bytes)"
    else
        echo "FAIL: .$1 differs: want $(( ${#want} / 2 )) bytes, got $(( ${#got} / 2 ))"
        printf '%s\n' "$want" | fold -w 2 > "$scratch/w"
        printf '%s\n' "$got" | fold -w 2 > "$scratch/g"
        cmp "$scratch/w" "$scratch/g" | head -1 || true
        status=1
    fi
}
compare text AS-TEXT AS-RO
compare rodata AS-RO AS-DATA
compare data AS-DATA AS-END
exit "$status"
