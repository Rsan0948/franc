#!/usr/bin/env bash
# Assembles every assembly input of the kernel in the guest with the Franc
# assembler, loaded from the toolchain archive through the JIT, and compares each
# section with GNU as. Needs as, objcopy, objdump and QEMU. Does not change the repo.
#   usage: bash tests/asm_speed/run.sh [IMAGE] [FILE...]
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "${1:-$repo/build/out/francos-bios.img}")
shift || true
if [ "$#" -eq 0 ]; then set -- tests/asm_speed/forms.S drivers/video/font.S boot/bios/boot.S runtime/abi.S compiler/bootstrap_seed.S; fi
cd "$repo"
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    if [ -n "${FRANC_ASM_LOG:-}" ] && [ -f "$scratch/serial.log" ]; then cp "$scratch/serial.log" "$FRANC_ASM_LOG"; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM

# Each file must be refused with this line, and must produce no sections.
refusals=$scratch/refusals
cat > "$refusals" <<'R'
unknown|AS-BAD-LINE frobnicate %rax
register|AS-BAD-LINE movq %zzz,%rax
duplicate|AS-BAD-LINE x:
include|AS-NO-FILE no/such/file.S
macro|AS-UNTERMINATED
align|AS-BAD-LINE .balign 16
too-many|AS-BAD-LINE movq %rax,%rbx,%rcx
too-few|AS-BAD-LINE addq %rax
two-memory|AS-BAD-LINE movq (%rax),(%rbx)
size|AS-BAD-LINE movq %eax,%rbx
no-size|AS-BAD-LINE mov $1,(%rax)
immediate|AS-BAD-LINE movq %rax,$1
loop-range|AS-BAD-LINE loop target out of range
R
cut -d '|' -f 1 "$refusals" | sed 's#.*#tests/asm_speed/bad/&.S#' > "$scratch/bad.list"

disk=$scratch/disk.img
cp "$image" "$disk"
# shellcheck disable=SC2046
sh build/toolchain_pack.sh "$disk" compiler/bootstrap_seed.S tests/asm_speed/forms.S $(cat "$scratch/bad.list")
cat lib/toolchain.frac > "$scratch/bundle.frac"
{
    printf 'def apps-init tc-load . "compiler/toolchain/assembler.frac" tc-compile . "as-run" s2-find :as-entry '
    for file in "$@" $(cat "$scratch/bad.list"); do printf '"%s" as-entry s2-run ' "$file"; done
    printf '"AS-ALL-DONE" type cr ;\n'
} >> "$scratch/bundle.frac"
FRANC_SOURCE_LBA=1024 sh build/source_pack.sh "$disk" "$scratch/bundle.frac"

fifo=$scratch/keys
log=$scratch/serial.log
mkfifo "$fifo"
: > "$log"
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
    -serial stdio -drive "file=$disk,format=raw,if=ide" <"$fifo" >"$log" 2>&1 &
guest_pid=$!
exec 3>"$fifo"
wait_for() {
    limit=$((SECONDS + $2))
    until grep -Fq "$1" "$log"; do
        if [ "$SECONDS" -ge "$limit" ] || ! kill -0 "$guest_pid" 2>/dev/null; then
            echo "FAIL: guest did not print $1" >&2
            tr -d '\r' < "$log" | grep -a -E 'AS-|ERROR|error|FAULT' | tail -n 30 | cut -c1-150 >&2
            exit 1
        fi
        sleep 0.2
    done
}
wait_for 'Franc> ' 120
start=$SECONDS
printf l >&3
wait_for AS-ALL-DONE "${FRANC_ASM_LIMIT:-900}"
echo "guest took $((SECONDS - start)) seconds for $# files"
exec 3>&-
kill "$guest_pid" 2>/dev/null || true
wait "$guest_pid" 2>/dev/null || true
guest_pid=""

tr -d '\r' < "$log" > "$scratch/clean.log"
status=0
# The nth AS-BEGIN..AS-END block belongs to the nth file.
index=0
for file in "$@"; do
    index=$((index + 1))
    awk -v n="$index" '$0 == "AS-BEGIN" { block++ } block == n { print }' "$scratch/clean.log" > "$scratch/block"
    if grep -a -E '^AS-(BAD-LINE|FAILED|TOO-MANY|NO-FILE|UNTERMINATED)' "$scratch/block" | head -n 20 | cut -c1-120 | grep .; then status=1; fi
    extract() { awk -v from="$1" -v to="$2" '$0 == to { on = 0 } on { printf "%s", $0 } $0 == from { on = 1 }' "$scratch/block"; }
    as --64 -o "$scratch/want.o" "$file"
    compare() {
        : > "$scratch/want.bin"
        objcopy -O binary --only-section="$1" "$scratch/want.o" "$scratch/want.bin" 2>/dev/null || true
        want=$(od -An -v -tx1 "$scratch/want.bin" | tr -d ' \n')
        got=$(extract "$2" "$3")
        if [ "$want" = "$got" ]; then
            echo "PASS: $file $1 matches GNU as ($(( ${#want} / 2 )) bytes)"
        else
            echo "FAIL: $file $1 differs: want $(( ${#want} / 2 )) bytes, got $(( ${#got} / 2 ))"
            printf '%s\n' "$want" | fold -w 2 > "$scratch/w"
            printf '%s\n' "$got" | fold -w 2 > "$scratch/g"
            at=$(cmp "$scratch/w" "$scratch/g" 2>/dev/null | awk '{ print int(($5 - 1)) }' | tr -d ',' || true)
            cmp "$scratch/w" "$scratch/g" | head -1 | cut -c1-100 || true
            status=1
        fi
    }
    compare .text AS-TEXT AS-ENTRY
    compare .text.entry AS-ENTRY AS-RO
    compare .rodata AS-RO AS-DATA
    compare .data AS-DATA AS-BSS
    want=$(objdump -h "$scratch/want.o" | awk '$2 == ".bss" { print $3 }')
    got=$(awk '$0 == "AS-BSS" { getline; print; exit }' "$scratch/block")
    if [ "$((16#$want))" = "$got" ]; then echo "PASS: $file .bss size $got"; else echo "FAIL: $file .bss want $((16#$want)) got $got"; status=1; fi
done
while IFS='|' read -r name want; do
    index=$((index + 1))
    awk -v n="$index" '$0 == "AS-BEGIN" { block++ } block == n { print }' "$scratch/clean.log" > "$scratch/block"
    if grep -Fxq "$want" "$scratch/block" && grep -Fxq AS-FAILED "$scratch/block" && ! grep -Fxq AS-TEXT "$scratch/block"; then
        echo "PASS: refused $name: $want"
    else
        echo "FAIL: $name: wanted $want"
        cut -c1-120 "$scratch/block" | head -n 6
        status=1
    fi
done < "$refusals"
exit "$status"
