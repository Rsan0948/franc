#!/bin/sh
# Report whether an immutable release tag still needs publication.
set -eu
test "$#" -eq 1 || { echo 'usage: release_tag_state.sh TAG' >&2; exit 2; }
git check-ref-format "refs/tags/$1"
if git ls-remote --exit-code --tags origin "refs/tags/$1" >/dev/null; then
    echo 'publish=false'
else
    status=$?
    case "$status" in
        2) echo 'publish=true' ;;
        *) echo 'Cannot determine release tag state; refusing publication' >&2
           exit "$status" ;;
    esac
fi
