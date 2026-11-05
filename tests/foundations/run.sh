#!/usr/bin/env bash
# Checks the Phase 3 foundations in the guest: code space, dictionary size, runtime
# variables, output capture, wide disk reads, the second drive and write regions.
#   usage: bash tests/foundations/run.sh IMAGE
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "$1")
cd "$repo"
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM

# 1,000 definitions and 1,000 variables pass the old limits of 448 and 512.
{
    awk 'BEGIN { for (i = 0; i < 1000; i++) printf "def w%d %d :v%d v%d 1 + ;\n", i, i, i, i }'
    cat <<'F'
def sum-check 0 w0 + w499 + w999 + . cr ;
def var-keeps 41 :keep 1 keep + :keep ;
def capture-ok 4096 alloc :cb cb cb 4096 + capture-start "hello" type 33 emit capture-stop :ce ce cb - . cb byte@ . cb 5 + byte@ . cr ;
def capture-full 4096 alloc :cb cb cb 3 + capture-start "hello" type capture-stop . cr ;
def wide-read 5000 ata-read-sector . 0 sector-byte@ . cr ;
def drive-read 1 ata-drive! 1000 ata-read-sector . 0 sector-byte@ . 0 ata-drive! cr ;
def fill 0 66 sector-byte! ;
def write-none 1 ata-drive! fill 1000 ata-write-sector . 0 ata-drive! cr ;
def write-inside 1 ata-drive! 900 1100 ata-write-region fill 1000 ata-write-sector . 0 ata-drive! cr ;
def write-outside 1 ata-drive! fill 1100 ata-write-sector . 0 ata-drive! cr ;
def write-boot-disk fill 1000 ata-write-sector . 5000 ata-write-sector . cr ;
def apps-init "F-BEGIN" type cr sum-check var-keeps keep . cr capture-ok capture-full wide-read drive-read write-none write-inside write-outside write-boot-disk "F-END" type cr ;
F
} > "$scratch/bundle.frac"
cat > "$scratch/expected" <<'F'
1501

42

6
104
33

0

1
77

1
68

0

1

0

0
0

F

disk=$scratch/disk.img
second=$scratch/second.img
cp "$image" "$disk"
truncate -s 4M "$disk"
FRANC_SOURCE_LBA=1024 sh build/source_pack.sh "$disk" "$scratch/bundle.frac"
before=$(od -An -tx1 -j $((1000 * 512)) -N 1 "$disk")
printf M | dd of="$disk" bs=512 seek=5000 conv=notrunc status=none
truncate -s 1M "$second"
printf D | dd of="$second" bs=512 seek=1000 conv=notrunc status=none

fifo=$scratch/keys
log=$scratch/serial.log
mkfifo "$fifo"
: > "$log"
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot -serial stdio \
    -drive "file=$disk,format=raw,if=ide,index=0" -drive "file=$second,format=raw,if=ide,index=1" \
    <"$fifo" >"$log" 2>&1 &
guest_pid=$!
exec 3>"$fifo"
wait_for() {
    limit=$((SECONDS + $2))
    until grep -Fq "$1" "$log"; do
        if [ "$SECONDS" -ge "$limit" ] || ! kill -0 "$guest_pid" 2>/dev/null; then
            echo "FAIL: guest did not print $1" >&2
            tail -c 400 "$log" >&2
            exit 1
        fi
        sleep 0.2
    done
}
wait_for 'Franc> ' 120
printf l >&3
wait_for 'F-END' 300
exec 3>&-
kill "$guest_pid"; wait "$guest_pid" 2>/dev/null || true; guest_pid=""

tr -d '\r' < "$log" | awk '/F-END/ { on = 0 } on { print } /F-BEGIN/ { on = 1 }' | sed 's/ *$//' > "$scratch/actual"
if ! diff "$scratch/expected" "$scratch/actual"; then
    echo "FAIL: guest results differ" >&2
    exit 1
fi
check_byte() {
    got=$(od -An -tx1 -j $(($2 * 512)) -N 1 "$1" | tr -d ' ')
    if [ "$got" != "$3" ]; then echo "FAIL: LBA $2 of $1 holds $got, expected $3" >&2; exit 1; fi
}
check_byte "$second" 1000 42
check_byte "$second" 1100 00
check_byte "$disk" 5000 4d
check_byte "$disk" 1000 "$(echo "$before" | tr -d ' ')"
echo "PASS: foundations hold in the guest"
