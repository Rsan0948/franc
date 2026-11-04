#!/usr/bin/env bash
# Independent seed check. Builds a kernel with the separate stage4/compiler.py,
# boots it, lets it compile the kernel sources natively, and requires both
# generations to equal the pinned seed. A seed altered by anything other than
# its sources cannot pass, because this path never reads it.
# Verification only: no build or runtime path depends on compiler.py.
#   usage: bash tests/verify_independent_seed.sh [PROOF_DIR]
# FRANC_EXPECTED_SEED selects the seed to compare. FRANC_REUSE_PROOF=1 skips
# the rebuild and compares an existing PROOF_DIR.
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
cd "$repo"
proof=${1:-build/out/independent-seed}
expected=${FRANC_EXPECTED_SEED:-compiler/bootstrap_seed.S}
test -f "$expected"
if [ "${FRANC_REUSE_PROOF:-0}" != 1 ]; then
    make -C stage4 franos-aot.img
    bash build/bootstrap.sh stage4/franos-aot.img "$proof"
fi
cmp "$expected" "$proof/gen2.S"
cmp "$expected" "$proof/gen3.S"
cmp "$proof/gen2.bin" "$proof/gen3.bin"
echo "PASS: independently compiled kernel reproduced the pinned seed"
