#!/bin/sh
# Launch canonical images; preserve user FRANCFS1 slots across rebuilds.
set -eu
cd "$(dirname "$0")/.."
mode=${1:-uefi}
qemu=${QEMU:-qemu-system-x86_64}
command -v "$qemu" >/dev/null
image=build/out/francos-bios.img
test -f "$image" || { echo 'Build the native image first: make os' >&2; exit 1; }
case "$mode" in bios|uefi) ;; *) echo "usage: $0 [uefi|bios]" >&2; exit 2 ;; esac
if [ "$mode" = uefi ]; then
    esp=build/out/francos-uefi-esp.img
    test -f "$esp" || { echo 'Build the UEFI adapter first: make os-uefi' >&2; exit 1; }
    code=${FRANC_OVMF_CODE:-}; vars=${FRANC_OVMF_VARS:-}
    if [ -z "$code" ]; then
        for base in /usr/share/OVMF /usr/share/edk2/x64 /opt/homebrew/share/qemu /usr/local/share/qemu; do
            for pair in 'OVMF_CODE_4M.fd OVMF_VARS_4M.fd' 'OVMF_CODE.fd OVMF_VARS.fd' 'edk2-x86_64-code.fd edk2-i386-vars.fd'; do
                set -- $pair
                if [ -f "$base/$1" ] && [ -f "$base/$2" ]; then code=$base/$1; vars=$base/$2; break 2; fi
            done
        done
    fi
    test -f "$code" && test -f "$vars" || {
        echo 'Set FRANC_OVMF_CODE and FRANC_OVMF_VARS to existing OVMF firmware files.' >&2; exit 1;
    }
fi
data_dir=${XDG_DATA_HOME:-"$HOME/.local/share"}/francos
mkdir -p "$data_dir"
disk=${FRANC_DISK:-"$data_dir/disk.img"}
mkdir -p "$(dirname "$disk")"
# Hold one portable lock for the whole session, before touching its disk.
lock=$disk.lock
if ! mkdir "$lock" 2>/dev/null; then
    if [ -f "$lock/pid" ]; then
        read -r owner < "$lock/pid"
        case "$owner" in ''|*[!0-9]*) owner=0 ;; esac
        if [ "$owner" -gt 0 ] && ! kill -0 "$owner" 2>/dev/null; then
            rm -f "$lock/pid"; rmdir "$lock"; mkdir "$lock"
        else
            echo 'FrancOS is already using this session disk. Close that window first.' >&2; exit 1
        fi
    else
        echo 'FrancOS session disk is locked by another launch.' >&2; exit 1
    fi
fi
printf '%s\n' "$$" > "$lock/pid"
tmp=''; child=''
cleanup() { [ -z "$tmp" ] || rm -f "$tmp"; rm -f "$lock/pid"; rmdir "$lock"; }
stop() { [ -z "$child" ] || kill "$child" 2>/dev/null || true; exit 130; }
trap cleanup EXIT
trap stop HUP INT TERM
# Slots 0 and 1 carry fresh kernel/system metadata. The ten user slots
# (directory bytes 64..383 and data LBAs 144..183) retain their exact bytes.
tmp=$(mktemp "$(dirname "$disk")/.francos-refresh.XXXXXX")
cp "$image" "$tmp"
if [ -f "$disk" ]; then
    test "$(wc -c < "$disk")" -ge 94208 || { echo "Existing session disk is truncated; retained without changes." >&2; exit 1; }
    magic=$(dd if="$disk" bs=1 skip=65536 count=8 2>/dev/null)
    test "$magic" = FRANCFS1 || { echo 'Existing session disk is not FRANCFS1; retained without changes.' >&2; exit 1; }
    dd if="$disk" bs=1 skip=66112 count=320 2>/dev/null | dd of="$tmp" bs=1 seek=66112 conv=notrunc 2>/dev/null
    dd if="$disk" bs=512 skip=144 count=40 2>/dev/null | dd of="$tmp" bs=512 seek=144 conv=notrunc 2>/dev/null
fi
mv "$tmp" "$disk"; tmp=''
echo 'FrancOS: arrows + Enter or number keys. Esc returns. Keyboard navigation.'
echo "Saved notes and programs: $disk"
if [ "$mode" = bios ]; then
    "$qemu" -m 128M -accel tcg -vga std -monitor none -no-reboot -serial stdio \
        -drive "file=$disk,format=raw,if=ide,index=0" <&0 &
else
    firmware_vars=$data_dir/ovmf-vars.fd
    test -f "$firmware_vars" || cp "$vars" "$firmware_vars"
    "$qemu" -m 128M -accel tcg -vga std -monitor none -no-reboot -serial stdio \
        -drive "file=$disk,format=raw,if=ide,index=0" \
        -drive "file=$esp,format=raw,if=virtio,readonly=on" \
        -drive "if=pflash,format=raw,unit=0,readonly=on,file=$code" \
        -drive "if=pflash,format=raw,unit=1,file=$firmware_vars" <&0 &
fi
child=$!
wait "$child"
