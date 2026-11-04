#!/usr/bin/env bash
# Boots FrancOS and types tests/crash/cases.txt into the REPL over serial.
#   usage: bash tests/crash/run.sh IMAGE
set -euo pipefail
repo=$(cd "$(dirname "$0")/../.." && pwd)
image=$(realpath "$1")
cd "$repo"
scratch=$(mktemp -d)
guest_pid=""
stop_guest() {
    if [ -n "$guest_pid" ]; then kill "$guest_pid" 2>/dev/null || true; wait "$guest_pid" 2>/dev/null || true; guest_pid=""; fi
    exec 3>&- 2>/dev/null || true
}
trap 'stop_guest; rm -rf "$scratch"' EXIT HUP INT TERM
log="$scratch/serial.log"
prompts() { grep -aoF "$1" "$log" | wc -l; }
wait_more() {
    limit=$((SECONDS + $3))
    until [ "$(prompts "$1")" -gt "$2" ]; do
        if [ "$SECONDS" -ge "$limit" ] || ! kill -0 "$guest_pid" 2>/dev/null; then return 1; fi
        sleep 0.05
    done
}
boot() {
    stop_guest
    cp "$image" "$scratch/disk.img"
    rm -f "$scratch/keys"
    mkfifo "$scratch/keys"
    : > "$log"
    qemu-system-x86_64 -m 128M -accel tcg -display none -monitor none -no-reboot \
        -serial stdio -drive "file=$scratch/disk.img,format=raw,if=ide" \
        <"$scratch/keys" >"$log" 2>&1 &
    guest_pid=$!
    exec 3>"$scratch/keys"
    wait_more 'Franc> ' 0 120
    printf r >&3
    wait_more 'Frac> ' 0 20
}
failed=0
checked=0
while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in ''|'#'*) continue ;; BOOT) boot; continue ;; esac
    input=${line%% => *}
    expected=${line#* => }
    case "$line" in *' => ') input=${line% => }; expected='' ;; esac
    before=$(prompts 'Frac> ')
    start=$(wc -c < "$log")
    n=0
    while [ "$n" -lt "${#input}" ]; do printf '%s' "${input:$n:1}" >&3; sleep 0.01; n=$((n + 1)); done
    printf '\r' >&3
    checked=$((checked + 1))
    if ! wait_more 'Frac> ' "$before" 30; then
        echo "FAIL: no prompt after: $input"
        tail -c 200 "$log"
        failed=$((failed + 1))
        boot
        continue
    fi
    output=$(tail -c +"$((start + 1))" "$log" | tr -d '\r')
    if [ -n "$expected" ] && ! printf '%s' "$output" | grep -aqF -- "$expected"; then
        echo "FAIL: $input"
        echo "  expected: $expected"
        echo "  actual:   $(printf '%s' "$output" | tail -c 120)"
        failed=$((failed + 1))
    fi
done < tests/crash/cases.txt
echo "$failed of $checked crash cases failed"
test "$failed" -eq 0
echo "PASS: FrancOS survives every crash case"
