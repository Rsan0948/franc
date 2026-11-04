#!/usr/bin/env bash
# FrancOS must not write to a disk without its signature, at boot or from the
# storage diagnostic. Fills the storage area with a pattern, removes the
# signature, boots, presses s, and requires every sector to be unchanged.
#   usage: bash tests/crash/run_foreign_disk.sh IMAGE
set -euo pipefail
image=$(realpath "$1")
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM
disk="$scratch/disk.img"
cp "$image" "$disk"
awk 'BEGIN { for (i = 0; i < 36864; i++) printf "Z" }' > "$scratch/pattern"
dd if="$scratch/pattern" of="$disk" bs=512 seek=128 conv=notrunc status=none
cp "$disk" "$scratch/before.img"
log="$scratch/serial.log"
mkfifo "$scratch/keys"
: > "$log"
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
    -serial stdio -drive "file=$disk,format=raw,if=ide" <"$scratch/keys" >"$log" 2>&1 &
guest_pid=$!
exec 3>"$scratch/keys"
wait_for() {
    limit=$((SECONDS + 120))
    until grep -aqF "$1" "$log"; do
        if [ "$SECONDS" -ge "$limit" ] || ! kill -0 "$guest_pid" 2>/dev/null; then
            echo "FAIL: guest did not print $1"
            tail -c 300 "$log"
            exit 1
        fi
        sleep 0.1
    done
}
wait_for 'Franc> '
sleep 0.5
printf s >&3
wait_for 'NOT A FRANCOS DISK'
sleep 1
kill "$guest_pid" 2>/dev/null || true
wait "$guest_pid" 2>/dev/null || true
guest_pid=""
cmp "$scratch/before.img" "$disk"
echo "PASS: FrancOS left a disk without its signature unchanged"
