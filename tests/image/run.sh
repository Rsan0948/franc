#!/usr/bin/env bash
# Runs the Home build action: the guest compiles, assembles, links and writes a full
# image to a second disk. The result must equal the GNU build of IMAGE, must boot,
# and must rebuild itself exactly. A second disk that may hold data must be left alone.
#   usage: bash tests/image/run.sh IMAGE
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "$1")
cd "$repo"
scratch=$(mktemp -d)
guest_pid=""
stop_guest() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    guest_pid=""
}
cleanup() {
    stop_guest
    if [ -n "${FRANC_IMAGE_LOG:-}" ] && [ -f "$scratch/serial.log" ]; then cp "$scratch/serial.log" "$FRANC_IMAGE_LOG"; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM
cp "$image" "$scratch/source.img"
image=$scratch/source.img
size=$(wc -c < "$image" | tr -d ' ')
blank() { truncate -s $((size + 1048576)) "$1"; }

# build DISK [SECOND]: presses w and leaves the serial log; stops on any final message.
build() {
    log=$scratch/serial.log
    fifo=$scratch/keys
    rm -f "$fifo"
    mkfifo "$fifo"
    : > "$log"
    drives=(-drive "file=$1,format=raw,if=ide,index=0")
    if [ "$#" -gt 1 ]; then drives+=(-drive "file=$2,format=raw,if=ide,index=1"); fi
    qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
        -serial stdio "${drives[@]}" <"$fifo" >"$log" 2>&1 &
    guest_pid=$!
    exec 3>"$fifo"
    limit=$((SECONDS + 120))
    until grep -Fq 'Franc> ' "$log"; do
        if [ "$SECONDS" -ge "$limit" ]; then echo "FAIL: guest did not boot" >&2; tail -c 400 "$log" >&2; exit 1; fi
        sleep 0.2
    done
    printf w >&3
    limit=$((SECONDS + ${FRANC_IMAGE_LIMIT:-500}))
    until finished "$log"; do
        if [ "$SECONDS" -ge "$limit" ]; then echo "FAIL: build did not finish" >&2; tr -d '\r' < "$log" | grep -a -E '^(BUILD|AS-|LD-|APPS|TOOLCHAIN)' | tail -n 12 | cut -c1-120 >&2; exit 1; fi
        sleep 0.5
    done
    exec 3>&-
    stop_guest
    tr -d '\r' < "$log" > "$scratch/clean.log"
}

# read executes its body only for newline-terminated records. A prefix such
# as "BUILD FAILED: TOOLCH" is not a completed guest result.
finished() {
    while IFS= read -r record; do
        case "$record" in
            'IMAGE READY'|'BUILD REFUSED:'*|'BUILD FAILED:'*|'FAULT'*) return 0 ;;
        esac
    done < "$1"
    return 1
}

status=0
expect() {
    if grep -Fxq "$1" "$scratch/clean.log"; then
        echo "PASS: $2"
    else
        echo "FAIL: $2: wanted $1"
        grep -a -E '^(BUILD|IMAGE|LD-|AS-BAD|TOOLCHAIN|FAULT)' "$scratch/clean.log" | tail -n 10 | cut -c1-120
        status=1
    fi
}
same_prefix() { cmp -n "$size" "$1" "$2" > "$scratch/cmp" 2>&1; }

if [ "${FRANC_IMAGE_BUILD_ONLY:-0}" != 1 ]; then
# Refusals come first: they are quick and must not touch either disk.
cp "$image" "$scratch/a.img"
build "$scratch/a.img"
expect 'BUILD REFUSED: NO SECOND DISK' 'refuses with no second disk'
blank "$scratch/data.img"
printf 'precious user data' | dd of="$scratch/data.img" conv=notrunc status=none
before=$(sha256sum < "$scratch/data.img")
build "$scratch/a.img" "$scratch/data.img"
expect 'BUILD REFUSED: SECOND DISK IN USE' 'refuses a second disk that holds data'
if [ "$before" = "$(sha256sum < "$scratch/data.img")" ]; then echo "PASS: that disk is unchanged"; else echo "FAIL: that disk changed"; status=1; fi
cp "$image" "$scratch/damaged.img"
printf X | dd of="$scratch/damaged.img" bs=1 seek=$((2048 * 512 + 8192)) conv=notrunc status=none
blank "$scratch/b.img"
before=$(sha256sum < "$scratch/b.img")
build "$scratch/damaged.img" "$scratch/b.img"
expect 'BUILD FAILED: TOOLCHAIN' 'refuses a damaged toolchain archive'
if [ "$before" = "$(sha256sum < "$scratch/b.img")" ]; then echo "PASS: nothing was written"; else echo "FAIL: a damaged archive wrote to the disk"; status=1; fi

fi

if [ "${FRANC_IMAGE_REFUSALS_ONLY:-0}" = 1 ]; then exit "$status"; fi
if [ "${FRANC_IMAGE_BUILD_ONLY:-0}" = 1 ]; then
    cp "$image" "$scratch/a.img"
    blank "$scratch/b.img"
fi

start=$SECONDS
before=$(sha256sum < "$scratch/a.img")
build "$scratch/a.img" "$scratch/b.img"
echo "the build took $((SECONDS - start)) seconds"
expect 'IMAGE READY' 'the guest built an image'
if same_prefix "$image" "$scratch/b.img"; then echo "PASS: the guest's image equals the GNU build ($size bytes)"; else echo "FAIL: images differ: $(cut -c1-120 "$scratch/cmp")"; status=1; fi
if [ "$before" = "$(sha256sum < "$scratch/a.img")" ]; then echo "PASS: the running disk is unchanged"; else echo "FAIL: the running disk changed"; status=1; fi
want=$(head -c "$size" "$image" | sha256sum | cut -d ' ' -f 1)
expect "IMAGE SHA $want" 'the guest reports the same hash'

# The new image must boot on its own and rebuild itself.
blank "$scratch/c.img"
build "$scratch/b.img" "$scratch/c.img"
expect 'IMAGE READY' 'the built image boots and builds again'
if same_prefix "$scratch/b.img" "$scratch/c.img"; then echo "PASS: generation N+1 equals generation N"; else echo "FAIL: generations differ: $(cut -c1-120 "$scratch/cmp")"; status=1; fi
exit "$status"
