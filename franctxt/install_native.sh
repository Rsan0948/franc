#!/bin/sh
# Install canonical Franctxt identity + config into FRANCFS1 on the native disk.
# Called by the GNU/shell packer, without Python/C/Node or extra kernel code.
# Slot 0 = kernel.franctxt, slot 1 = system.franctxt. Existing source
# library bundles are outside FRANCFS1, so no sectors collide.
set -eu
if [ "$#" -ne 4 ]; then
    echo "usage: sh franctxt/install_native.sh IMAGE KERNEL.bin GIT_REVISION BOOT.bin" >&2
    exit 2
fi
image=$1
kernel=$2
revision=$3
boot=$4
case "$revision" in
  *[!a-zA-Z0-9.-]*|'') echo "invalid source revision" >&2; exit 2;;
esac
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
cat > "$tmp/system.franctxt" <<'EOF'
franctxt 1
boot.default = "bios"
history.parent = null
memory.heap-size = 4194304
memory.page-size = 4096
network.driver = "e1000"
network.enabled = false
scheduler.max-tasks = 2
schema = "francos.kernel.v1"
system.name = "FrancOS"
EOF
# Exact NUL-terminated application bundle bytes are hashed in their
# authoritative declared order; no second manually maintained source list.
apps_hash=$(
    {
        while IFS= read -r src || [ -n "$src" ]; do
            case "$src" in ''|'#'*) continue ;; esac
            cat "$src"
            printf '\n'
        done < stage4/app_sources.list
        printf '\000'
    } | sha256sum | cut -d ' ' -f1
)
boot_hash=$(sha256sum "$boot" | cut -d ' ' -f1)
seed_hash=$(sha256sum stage4/bootstrap_seed.S | cut -d ' ' -f1)
registry_hash=$(sha256sum stage4/apps/registry.frac | cut -d ' ' -f1)
runtime_hash=$(sha256sum stage4/runtime.S | cut -d ' ' -f1)
kernel_hash=$(sha256sum "$kernel" | cut -d ' ' -f1)
config_hash=$({ printf 'franctxt/1\000'; cat "$tmp/system.franctxt"; } | sha256sum | cut -d ' ' -f1)
cat > "$tmp/kernel.franctxt" <<EOF
franctxt 1
build.apps-sha256 = "sha256:$apps_hash"
build.arch = "x86_64"
build.boot-sha256 = "sha256:$boot_hash"
build.config-sha256 = "sha256:$config_hash"
build.kernel-sha256 = "sha256:$kernel_hash"
build.registry-sha256 = "sha256:$registry_hash"
build.runtime-sha256 = "sha256:$runtime_hash"
build.seed-assembly-sha256 = "sha256:$seed_hash"
build.source-revision = "$revision"
build.version = "0.6.0-dev"
schema = "francos.kernel-build.v1"
system.name = "FrancOS"
EOF
# Manifest is canonical: keys sorted ASCII; no comments or dynamic data
# beyond the explicit Git revision and digest of compiled kernel bytes.
install_entry() {
    slot=$1
    name=$2
    data="$tmp/$name"
    size=$(wc -c < "$data" | tr -d ' ')
    name_size=$(printf '%s' "$name" | wc -c | tr -d ' ')
    if [ "$size" -eq 0 ] || [ "$size" -gt 2047 ] || [ "$name_size" -gt 23 ]; then
        echo "Franctxt file violates FRANCFS1 limits: $name" >&2
        exit 1
    fi
    dd if="$data" of="$image" bs=512 seek=$((136 + slot * 4)) conv=notrunc status=none
    printf '%s' "$name" | dd of="$image" bs=1 seek=$((129 * 512 + slot * 32)) conv=notrunc status=none
    low=$((size % 256))
    high=$((size / 256))
    {
        printf '%b' "$(printf '\\%03o' "$low")"
        printf '%b' "$(printf '\\%03o' "$high")"
    } | dd of="$image" bs=1 seek=$((129 * 512 + slot * 32 + 24)) conv=notrunc status=none
}
install_entry 0 kernel.franctxt
install_entry 1 system.franctxt
echo "Franctxt: embedded source=$revision kernel_sha256=$kernel_hash config_sha256=$config_hash"
