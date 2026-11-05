#!/usr/bin/env bash
# Presses real PS/2 keys through the QEMU monitor. Other tests type over serial, which
# skips the scan code path: Esc must leave an app, and Home must answer afterwards.
#   usage: bash tests/keyboard/run.sh IMAGE
set -euo pipefail
image=$(realpath "$1")
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM
cp "$image" "$scratch/disk.img"
log=$scratch/serial.log
port=$((20000 + RANDOM % 20000))
: > "$log"
qemu-system-x86_64 -m 128M -accel tcg -display none -no-reboot -serial "file:$log" \
    -monitor "tcp:127.0.0.1:$port,server,nowait" -drive "file=$scratch/disk.img,format=raw,if=ide" &
guest_pid=$!
limit=$((SECONDS + 20))
until exec 4<>"/dev/tcp/127.0.0.1/$port"; do
    if [ "$SECONDS" -ge "$limit" ]; then echo "FAIL: no monitor"; exit 1; fi
    sleep 0.2
done 2>/dev/null
press() { printf 'sendkey %s\n' "$1" >&4; }
count() { grep -aoF "$1" "$log" | wc -l | tr -d ' '; }
wait_for() {
    limit=$((SECONDS + $3))
    until [ "$(count "$1")" -ge "$2" ]; do
        if [ "$SECONDS" -ge "$limit" ]; then echo "FAIL: guest did not print $1"; tail -c 300 "$log"; exit 1; fi
        sleep 0.1
    done
}
wait_for 'Franc> ' 1 120
press 1
wait_for 'FracCalc' 1 90
wait_for 'ans: ' 1 10
for key in 2 spc 3 spc shift-equal ret; do press "$key"; sleep 0.2; done
wait_for 'ans: 5' 1 20
echo "PASS: digits, Shift and Enter reach an app"
press esc
wait_for 'Franc> ' 2 20
echo "PASS: Esc leaves an app"
press u
wait_for 'FrancOS HOME' 2 20
echo "PASS: Home answers after Esc"
