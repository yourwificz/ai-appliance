#!/usr/bin/env bash

set -Eeuo pipefail

TARGET="${1:-}"

if [[ -z "${TARGET}" ]]; then
    echo "Usage: $0 <block-device-or-file>"
    echo
    echo "Examples:"
    echo "  $0 /dev/md0"
    echo "  $0 /dev/xvdb"
    echo "  $0 /run/sr-mount/<sr-uuid>/<vdi-uuid>.vhd"
    exit 1
fi

if [[ ! -e "${TARGET}" ]]; then
    echo "Error: target does not exist: ${TARGET}" >&2
    exit 1
fi

echo "Storage benchmark"
echo "Target: ${TARGET}"
echo

echo "== Direct sequential read (dd) =="

dd \
    if="${TARGET}" \
    of=/dev/null \
    bs=64M \
    count=256 \
    iflag=direct \
    status=progress

if command -v fio >/dev/null 2>&1; then
    echo
    echo "== Sequential read (fio) =="

    fio \
        --name=sequential-read \
        --filename="${TARGET}" \
        --readonly \
        --direct=1 \
        --ioengine=libaio \
        --rw=read \
        --bs=256k \
        --iodepth=64 \
        --numjobs=4 \
        --size=4G \
        --group_reporting
else
    echo
    echo "fio not installed; skipping fio test."
fi
