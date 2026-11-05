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

# A picture must stay up until a key is pressed; Home used to paint over it at once.
dump() { rm -f "$1"; printf 'screendump %s\n' "$1" >&4; limit=$((SECONDS + 10)); until [ -s "$1" ]; do [ "$SECONDS" -lt "$limit" ] || { echo "FAIL: no screen dump"; exit 1; }; sleep 0.1; done; sleep 0.3; }
sleep 1
dump "$scratch/home.ppm"
press 4
sleep 4
dump "$scratch/picture.ppm"
if cmp -s "$scratch/home.ppm" "$scratch/picture.ppm"; then echo "FAIL: the picture did not stay on screen"; exit 1; fi
echo "PASS: a picture stays until a key is pressed"
press u
sleep 2
dump "$scratch/after.ppm"
if cmp -s "$scratch/picture.ppm" "$scratch/after.ppm"; then echo "FAIL: a key did not leave the picture"; exit 1; fi
echo "PASS: a key returns from the picture"
