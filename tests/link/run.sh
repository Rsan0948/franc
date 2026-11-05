#!/usr/bin/env bash
# Links the boot sector and kernel in the guest with the Franc assembler and linker,
# and compares both with what GNU as, ld and objcopy built into IMAGE's build
# directory. Then checks that links which cannot work are refused.
#   usage: bash tests/link/run.sh IMAGE BOOT.bin KERNEL.bin
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "$1")
boot=$(realpath "$2")
kernel=$(realpath "$3")
cd "$repo"
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    if [ -n "${FRANC_LINK_LOG:-}" ] && [ -f "$scratch/serial.log" ]; then cp "$scratch/serial.log" "$FRANC_LINK_LOG"; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM

disk=$scratch/disk.img
cp "$image" "$disk"
sh build/toolchain_pack.sh "$disk" compiler/bootstrap_seed.S tests/link/bad/undefined.S tests/link/bad/twice.S tests/link/bad/common.S tests/link/bad/range.S
cat lib/toolchain.frac > "$scratch/bundle.frac"
cat >> "$scratch/bundle.frac" <<'F'
def lt-call s2-find s2-run ;
def lt-pair :lt-b :lt-a "ld-reset" lt-call lt-a "ld-add" lt-call lt-b "ld-add" lt-call 65536 "ld-finish" lt-call "ld-report" lt-call ;
def lt-one :lt-a "ld-reset" lt-call lt-a "ld-add" lt-call 31744 "ld-finish" lt-call "ld-report" lt-call ;
def lt-dump drop ;
def apps-init tc-load . "compiler/toolchain/assembler.frac" tc-compile . "compiler/toolchain/linker.frac" tc-compile . "LT-BOOT" type cr "ld-boot" lt-call "ld-report" lt-call "LT-KERNEL" type cr "compiler/bootstrap_seed.S" "ld-kernel" lt-call dup "ld-report" lt-call lt-dump "LT-UNDEFINED" type cr "tests/link/bad/undefined.S" lt-one "LT-TWICE" type cr "tests/link/bad/twice.S" "tests/link/bad/twice.S" lt-pair "LT-COMMON" type cr "tests/link/bad/common.S" lt-one "LT-RANGE" type cr "tests/link/bad/range.S" lt-one "LT-END" type cr ;
F
# On a failed comparison, FRANC_LINK_DUMP=1 prints the guest's kernel image in the log.
if [ -n "${FRANC_LINK_DUMP:-}" ]; then sed -i 's/^def lt-dump drop ;/def lt-dump "ld-dump" lt-call ;/' "$scratch/bundle.frac"; fi
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
            tr -d '\r' < "$log" | grep -a -E '^(AS|LD|LT)-|FAULT' | tail -n 30 | cut -c1-150 >&2
            exit 1
        fi
        sleep 0.2
    done
}
wait_for 'Franc> ' 120
start=$SECONDS
printf l >&3
wait_for LT-END "${FRANC_LINK_LIMIT:-600}"
echo "guest took $((SECONDS - start)) seconds"
exec 3>&-
kill "$guest_pid" 2>/dev/null || true
wait "$guest_pid" 2>/dev/null || true
guest_pid=""

tr -d '\r' < "$log" > "$scratch/clean.log"
block() { awk -v from="$1" -v to="$2" '$0 == to { on = 0 } on { print } $0 == from { on = 1 }' "$scratch/clean.log"; }
status=0
same() {
    want=$(sha256sum "$3" | cut -d ' ' -f 1)
    size=$(wc -c < "$3" | tr -d ' ')
    block "$1" "$2" > "$scratch/block"
    if grep -Fxq "LD-SHA $want" "$scratch/block"; then
        echo "PASS: $(basename "$3") matches GNU as, ld and objcopy ($size bytes)"
    else
        echo "FAIL: $(basename "$3") differs from the GNU build (want $size bytes, $want)"
        grep -a -E '^(LD|AS-BAD|AS-FAILED)' "$scratch/block" | head -n 20 | cut -c1-120
        status=1
    fi
}
same LT-BOOT LT-KERNEL "$boot"
same LT-KERNEL LT-UNDEFINED "$kernel"
refused() {
    block "$1" "$2" > "$scratch/block"
    if grep -Fxq "$3" "$scratch/block"; then
        if grep -Fq LD-SHA "$scratch/block"; then echo "FAIL: $1 produced an image"; status=1; else echo "PASS: refused: $3"; fi
    else
        echo "FAIL: $1: wanted $3"
        tail -n 8 "$scratch/block" | cut -c1-120
        status=1
    fi
}
refused LT-UNDEFINED LT-TWICE 'LD-UNDEFINED nowhere'
refused LT-TWICE LT-COMMON 'LD-DUPLICATE runtime_twice'
refused LT-COMMON LT-RANGE 'LD-COMMON'
refused LT-RANGE LT-END 'LD-RANGE'
exit "$status"
