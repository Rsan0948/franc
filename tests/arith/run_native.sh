#!/usr/bin/env bash
# Runs tests/arith/vectors.txt inside FrancOS and compares what the guest prints.
# Expressions become a Franc source bundle that the native JIT compiles, so the
# arithmetic under test is the real runtime. Uses shell and awk only.
#   usage: bash tests/arith/run_native.sh IMAGE
# FRANC_ARITH_LOG, if set, keeps the guest serial log at that path.
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "$1")
cd "$repo"
vectors=tests/arith/vectors.txt
scratch=$(mktemp -d)
guest_pid=""
cleanup() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; fi
    if [ -n "${FRANC_ARITH_LOG:-}" ] && [ -f "$scratch/serial.log" ]; then cp "$scratch/serial.log" "$FRANC_ARITH_LOG"; fi
    rm -rf "$scratch"
}
trap cleanup EXIT HUP INT TERM
awk -F' => ' '
  /^#/ || NF==0 { next }
  { body = body " " $1 " . cr"; if (++n % 40 == 0) { flush() } }
  function flush() { if (body != "") { printf "def arith-part-%d%s ;\n", ++parts, body; body = "" } }
  END {
    flush()
    printf "def apps-init \"ARITH-BEGIN\" type cr"
    for (i = 1; i <= parts; i++) printf " arith-part-%d", i
    printf " \"ARITH-END\" type cr ;\n"
  }' "$vectors" > "$scratch/vectors.frac"
awk -F' => ' '/^#/ || NF==0 { next } { print $2 }' "$vectors" > "$scratch/expected"
disk="$scratch/disk.img"
cp "$image" "$disk"
FRANC_SOURCE_LBA=1024 sh build/source_pack.sh "$disk" "$scratch/vectors.frac"
fifo="$scratch/keys"
log="$scratch/serial.log"
mkfifo "$fifo"
: > "$log"
qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
    -serial stdio -drive "file=$disk,format=raw,if=ide" <"$fifo" >"$log" 2>&1 &
guest_pid=$!
exec 3>"$fifo"
wait_for() {
    limit=$((SECONDS + $2))
    until grep -Fq "$1" "$log"; do
        if [ "$SECONDS" -ge "$limit" ] || ! kill -0 "$guest_pid" 2>/dev/null; then
            echo "FAIL: guest did not print $1" >&2
            kill -0 "$guest_pid" 2>/dev/null && echo "guest is still running" >&2 || echo "guest exited" >&2
            tail -c 200 "$log" >&2
            exit 1
        fi
        sleep 0.2
    done
}
wait_for 'Franc> ' 120
printf l >&3
wait_for 'ARITH-END' 300
exec 3>&-
tr -d '\r' < "$log" | awk '/ARITH-END/ { on = 0 } on && NF { print } /ARITH-BEGIN/ { on = 1 }' > "$scratch/actual"
awk -F' => ' '/^#/ || NF==0 { next } { print $1 }' "$vectors" > "$scratch/expressions"
if paste -d'|' "$scratch/expressions" "$scratch/expected" "$scratch/actual" |
    awk -F'|' '$2 != $3 { bad++; if (bad <= 40) printf "FAIL: %s\n  expected %s\n  actual   %s\n", $1, $2, $3 }
               END { printf "%d of %d vectors differ\n", bad + 0, NR; exit bad != 0 }'; then
    test "$(wc -l < "$scratch/actual")" -eq "$(wc -l < "$scratch/expected")"
    echo "PASS: native runtime matches tests/arith/vectors.txt"
else
    exit 1
fi
