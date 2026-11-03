#!/bin/sh
# Native FrancOS BIOS image packer. Only shell and GNU dd/wc.
set -eu
if [ "$#" -ne 3 ]; then
    echo "usage: sh stage4/pack_native.sh BOOT.bin KERNEL.bin OUTPUT.img" >&2
    exit 2
fi
boot=$1; kernel=$2; image=$3
boot_bytes=$(wc -c < "$boot")
kernel_bytes=$(wc -c < "$kernel")
if [ "$boot_bytes" -ne 512 ] || [ "$kernel_bytes" -le 0 ] || [ "$kernel_bytes" -gt 195584 ]; then
    echo "invalid FrancOS boot sector or kernel size: $boot_bytes / $kernel_bytes" >&2
    exit 1
fi
dd if=/dev/zero of="$image" bs=512 count=512 status=none
dd if="$boot" of="$image" conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 count=127 seek=1 conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 skip=127 count=64 seek=200 conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 skip=191 count=127 seek=264 conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 skip=318 count=64 seek=391 conv=notrunc status=none
printf FRANCFS1 | dd of="$image" bs=512 seek=128 conv=notrunc status=none

# Preserve the original Franc libraries as a disk-backed native source bundle.
# The C-free OS JIT-compiles these sources on demand; no C or Python tool.
set --
while IFS= read -r src || [ -n "$src" ]; do
  case "$src" in ''|'#'*) continue ;; esac
  case "$src" in *[!a-zA-Z0-9._/-]*|/*|*..*) echo "invalid app source path: $src" >&2; exit 1 ;; esac
  test -f "$src" || { echo "missing native app source: $src" >&2; exit 1; }
  set -- "$@" "$src"
done < stage4/app_sources.list
test "$#" -gt 0
FRANC_SOURCE_LBA=1024 sh stage4/source_pack.sh "$image" "$@"

# Persist Franctxt kernel build identity and editable initial config.
revision=$(git rev-parse --verify HEAD 2>/dev/null || printf untracked)
sh franctxt/install_native.sh "$image" "$kernel" "$revision" "$boot"
