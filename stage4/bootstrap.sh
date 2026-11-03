#!/usr/bin/env bash
# Complete generation-2 and generation-3 Franc-native rebuild driver.
# Requires an already bootable Franc compiler seed. Its provenance matters:
# a Python-built initial seed is not a source-only assembly/Franc bootstrap.
set -euo pipefail
if [ "$#" -ne 2 ]; then
    echo "usage: bash stage4/bootstrap.sh SEED.img OUTPUT_DIR" >&2
    exit 2
fi
seed=$(realpath "$1")
mkdir -p "$2"
dest=$(cd "$2" && pwd)
repo=$(cd "$(dirname "$0")/.." && pwd)
cd "$repo"
test -f "$seed"
for tool in qemu-system-x86_64 as ld objcopy dd awk; do command -v "$tool" >/dev/null; done
# Ask make for assembly targets only. Never build the Python-produced kernel.
make -C stage4 runtime.o font.o boot.bin
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM
set -- stage3/ata.frac stage3/storage.frac stage4/display.frac \
       stage4/keyboard.frac stage2/compiler.frac stage4/repl.frac \
       stage4/upgrade.frac stage4/aot.frac stage4/bundle.frac \
       stage4/kernel.frac
for generation in 2 3; do
    disk="$scratch/input-$generation.img"
    cp "$seed" "$disk"
    sh stage4/source_pack.sh "$disk" "$@"
    fifo="$scratch/keyboard-$generation"
    log="$dest/gen$generation.serial.log"
    mkfifo "$fifo"
    qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none \
        -no-reboot -serial stdio -drive "file=$disk,format=raw,if=ide" \
        <"$fifo" >"$log" 2>&1 &
    guest_pid=$!
    exec 3>"$fifo"
    limit=$((SECONDS+540))
    while ! grep -Fq 'Franc> ' "$log"; do
        if [ "$SECONDS" -ge "$limit" ]; then
            echo "gen$generation did not reach console" >&2
            tail -c 2000 "$log" >&2 || true
            exit 1
        fi
        if ! kill -0 "$guest_pid" 2>/dev/null; then echo "gen$generation guest exited" >&2; exit 1; fi
        sleep 0.2
    done
    printf k >&3
    while ! grep -Fq 'FRANC-KERNEL-END' "$log"; do
        if grep -Fq 'FRANC-PROGRAM-ERROR' "$log"; then
            echo "Franc AOT rejected kernel source in gen$generation" >&2
            tail -c 1000 "$log" >&2
            exit 1
        fi
        if [ "$SECONDS" -ge "$limit" ]; then
            echo "gen$generation compilation timed out" >&2
            tail -c 1000 "$log" >&2 || true
            exit 1
        fi
        if ! kill -0 "$guest_pid" 2>/dev/null; then echo "gen$generation guest exited" >&2; exit 1; fi
        sleep 0.2
    done
    exec 3>&-
    kill "$guest_pid" 2>/dev/null || true
    wait "$guest_pid" 2>/dev/null || true
    guest_pid=""
    output="$dest/gen$generation.S"
    awk '
      /^FRANC-PROGRAM-BEGIN$/ { inside=1; count++; next }
      /^FRANC-PROGRAM-END$/ { inside=0; done++; next }
      inside { print }
      END { if(count!=1 || done!=1) exit 1 }
    ' "$log" > "$output"
    as --64 -o "$dest/gen$generation.o" "$output"
    ld -m elf_x86_64 -nostdlib -T stage4/kernel.ld \
        -o "$dest/gen$generation.elf" \
        stage4/runtime.o stage4/font.o "$dest/gen$generation.o"
    objcopy -O binary -j .text -j .rodata -j .data \
        "$dest/gen$generation.elf" "$dest/gen$generation.bin"
    sh stage4/pack_native.sh stage4/boot.bin "$dest/gen$generation.bin" \
        "$dest/gen$generation.img"
    size=$(wc -c < "$dest/gen$generation.bin")
    echo "PASS: Franc generation $generation produced $size native kernel bytes"
    seed="$dest/gen$generation.img"
done
cmp "$dest/gen2.bin" "$dest/gen3.bin"
echo "PASS: Franc-native generations 2 and 3 are byte-for-byte reproducible"
