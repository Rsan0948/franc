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
if [ "$boot_bytes" -ne 512 ] || [ "$kernel_bytes" -le 0 ] || [ "$kernel_bytes" -gt 158720 ]; then
    echo "invalid FrancOS boot sector or kernel size: $boot_bytes / $kernel_bytes" >&2
    exit 1
fi
dd if=/dev/zero of="$image" bs=512 count=512 status=none
dd if="$boot" of="$image" conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 count=127 seek=1 conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 skip=127 count=56 seek=200 conv=notrunc status=none
dd if="$kernel" of="$image" bs=512 skip=183 count=127 seek=256 conv=notrunc status=none
printf FRANCFS1 | dd of="$image" bs=512 seek=128 conv=notrunc status=none

# Preserve the original Franc libraries as a disk-backed native source bundle.
# The C-free OS JIT-compiles these sources on demand; no C or Python tool.
FRANC_SOURCE_LBA=1024 sh stage4/source_pack.sh "$image" \
  stage4/apps/native-compat.frac \
  lib/fixpt.frac lib/cf.frac lib/approx.frac lib/iv.frac lib/trans.frac \
  lib/graphics.frac lib/ford.frac lib/spiro.frac \
  lib/calc.frac lib/edit.frac lib/walk.frac lib/dd.frac \
  stage4/apps/native-programs.frac \
  lib/bignum.frac lib/float.frac lib/litetofrac.frac lib/pkg.frac \
  lib/ide.frac stage4/pci.frac stage4/tasks.frac stage4/net.frac stage4/fibers.frac
