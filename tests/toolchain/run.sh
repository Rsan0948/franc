#!/usr/bin/env bash
# Checks the toolchain archive in the guest: every file loads with the host's
# hash, a tool compiles out of the archive, and each kind of damaged disk is
# refused with its own message. The guest must not write to the archive.
#   usage: bash tests/toolchain/run.sh IMAGE
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
cleanup() { stop_guest; rm -rf "$scratch"; }
trap cleanup EXIT HUP INT TERM

lba=2048
printf 'def tool-answer 42 ;\n' > "$scratch/demo-tool.frac"
cat lib/toolchain.frac > "$scratch/bundle.frac"
cat >> "$scratch/bundle.frac" <<'F'
def tc-list 1 :tl-n begin tl-n tc-count 1 + - while tl-n tc-record :tl-r tl-r tc-type-name cr tl-r tc-size . tl-r tc-addr tl-r tc-size sha256-long type cr tl-n 1 + :tl-n repeat ;
def apps-init "TC-BEGIN" type cr "runtime/abi.S" tc-find . tc-load . tc-list "TC-LOOKUP" type cr "no/such/file" tc-find . "runtime/abi" tc-find . "runtime/abi.S" tc-find if0 "TC-NO-ABI" type cr then "no/such/file" tc-compile . "demo-tool.frac" tc-compile . "tool-answer" s2-find :tc-tool tc-tool ifnz tc-tool s2-run . then "TC-END" type cr ;
F
base=$scratch/base.img
cp "$image" "$base"
FRANC_SOURCE_LBA=1024 sh build/source_pack.sh "$base" "$scratch/bundle.frac"
ln -s "$scratch/demo-tool.frac" demo-tool.frac
trap 'rm -f "$repo/demo-tool.frac"; cleanup' EXIT HUP INT TERM
sh build/toolchain_pack.sh "$base" demo-tool.frac
rm -f demo-tool.frac

guest() {
    disk=$1
    log=$2
    fifo=$scratch/keys
    rm -f "$fifo"
    mkfifo "$fifo"
    : > "$log"
    qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
        -serial stdio -drive "file=$disk,format=raw,if=ide" <"$fifo" >"$log" 2>&1 &
    guest_pid=$!
    exec 3>"$fifo"
    limit=$((SECONDS + 120))
    until grep -Fq 'Franc> ' "$log"; do
        if [ "$SECONDS" -ge "$limit" ]; then echo "FAIL: guest did not boot" >&2; exit 1; fi
        sleep 0.1
    done
    printf l >&3
    until grep -Fq 'TC-END' "$log"; do
        if [ "$SECONDS" -ge "$limit" ]; then echo "FAIL: guest did not finish" >&2; tail -c 400 "$log" >&2; exit 1; fi
        sleep 0.1
    done
    exec 3>&-
    stop_guest
    tr -d '\r' < "$log" | awk '/^TC-BEGIN/ { on = 1; next } /^TC-END/ { on = 0 } on && NF' > "$log.clean"
}

# Edits the table and writes a matching table hash, so only the file check can object.
rehash() {
    disk=$1
    count=$(dd if="$disk" bs=1 skip=$((lba * 512 + 11)) count=8 status=none)
    hash=$(dd if="$disk" bs=1 skip=$((lba * 512 + 128)) count=$((10#$count * 128)) status=none | sha256sum | cut -d ' ' -f 1)
    printf '%s' "$hash" | dd of="$disk" bs=1 seek=$((lba * 512 + 29)) conv=notrunc status=none
}
poke() { printf '%s' "$3" | dd of="$1" bs=1 seek=$(($2)) conv=notrunc status=none; }

status=0
pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; status=1; }

# The whole table, hashed on the host, is what the guest must report.
count=$(dd if="$base" bs=1 skip=$((lba * 512 + 11)) count=8 status=none)
count=$((10#$count))
{
    echo 0
    echo "$count"
    i=1
    while [ "$i" -le "$count" ]; do
        record=$(dd if="$base" bs=1 skip=$((lba * 512 + i * 128)) count=127 status=none)
        name=$(printf '%s' "$record" | cut -c1-44 | sed 's/ *$//')
        offset=$(printf '%s' "$record" | cut -c46-53)
        size=$(printf '%s' "$record" | cut -c55-62)
        printf '%s\n%s\n' "$name" "$((10#$size))"
        dd if="$base" bs=512 skip=$((lba + 10#$offset / 512)) count=$(( (10#$size + 511) / 512 )) status=none | head -c "$((10#$size))" | sha256sum | cut -d ' ' -f 1
        i=$((i + 1))
    done
    printf 'TC-LOOKUP\n0\n0\n0\n1\n42\n'
} > "$scratch/expected"
good=$scratch/good.img
cp "$base" "$good"
before=$(dd if="$good" bs=512 skip="$lba" status=none | sha256sum)
guest "$good" "$scratch/good.log"
if diff "$scratch/expected" "$scratch/good.log.clean" > "$scratch/diff"; then pass "all $count files load with the host's hashes"; else fail "good archive"; head -20 "$scratch/diff"; fi
after=$(dd if="$good" bs=512 skip="$lba" status=none | sha256sum)
if [ "$before" = "$after" ]; then pass "the guest left the archive unchanged"; else fail "the guest wrote to the archive"; fi

refused() {
    name=$1
    want=$2
    guest "$scratch/case.img" "$scratch/case.log"
    # After a refusal nothing can be found or compiled.
    if grep -Fxq "$want" "$scratch/case.log.clean" && [ "$(tail -n 3 "$scratch/case.log.clean" | tr '\n' ' ')" = "TC-NO-ABI 0 0 " ]; then
        pass "$name: $want"
    else
        fail "$name: wanted $want"
        cat "$scratch/case.log.clean"
    fi
}
fresh() { cp "$base" "$scratch/case.img"; }
record_of() { echo $((lba * 512 + $1 * 128)); }
abi_offset=$(dd if="$base" bs=1 skip=$(($(record_of 2) + 45)) count=8 status=none)

fresh; poke "$scratch/case.img" $((lba * 512 + 10#$abi_offset + 100)) X
refused 'a changed byte in a file' 'TOOLCHAIN BAD FILE runtime/abi.S'
fresh; poke "$scratch/case.img" "$(record_of 2)" X
refused 'a changed name in the table' 'TOOLCHAIN BAD TABLE'
fresh; poke "$scratch/case.img" $((lba * 512)) X
refused 'no archive marker' 'TOOLCHAIN MISSING'
fresh; poke "$scratch/case.img" $((lba * 512 + 20)) 99999999
refused 'an archive larger than its region' 'TOOLCHAIN INVALID'
fresh; poke "$scratch/case.img" $((lba * 512 + 11)) 00000000
refused 'an empty table' 'TOOLCHAIN INVALID'
fresh; poke "$scratch/case.img" $((lba * 512 + 11)) 0000000x
refused 'a count that is not a number' 'TOOLCHAIN INVALID'
fresh; poke "$scratch/case.img" $(($(record_of 2) + 54)) 99999999; rehash "$scratch/case.img"
refused 'a file running past the archive' 'TOOLCHAIN BAD FILE runtime/abi.S'
fresh; poke "$scratch/case.img" $(($(record_of 2) + 45)) 00000000; rehash "$scratch/case.img"
refused 'a file overlapping the table' 'TOOLCHAIN BAD FILE runtime/abi.S'
fresh; truncate -s $(( (lba + 40) * 512 )) "$scratch/case.img"
refused 'a disk cut short' 'TOOLCHAIN READ FAILED'
exit "$status"
