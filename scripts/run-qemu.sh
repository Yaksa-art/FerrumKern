#!/bin/sh
# Run FerrumKern ISO in QEMU (BIOS + optional UEFI).
set -eu
ISO="${ISO:-ferrumkern.iso}"
case "${1:-}" in *.iso) ISO="$1"; shift;; esac
OVMF_CODE="${OVMF_CODE:-/usr/share/OVMF/OVMF_CODE_4M.fd}"
OVMF_VARS="${OVMF_VARS:-/usr/share/OVMF/OVMF_VARS_4M.fd}"
MEM="${MEM:-512M}"
[ -f "${ISO}" ] || { echo "error: ISO '${ISO}' not found" >&2; exit 1; }
if [ -f "${OVMF_CODE}" ] && [ -f "${OVMF_VARS}" ]; then
  VARS_TMP="${TMPDIR:-/tmp}/ferrumkern_VARS.fd"
  cp -f "${OVMF_VARS}" "${VARS_TMP}"
  exec qemu-system-x86_64 -m "${MEM}" -cdrom "${ISO}" -serial stdio -no-reboot \
    -drive if=pflash,format=raw,unit=0,file="${OVMF_CODE}",readonly=on \
    -drive if=pflash,format=raw,unit=1,file="${VARS_TMP}" "$@"
else
  exec qemu-system-x86_64 -m "${MEM}" -cdrom "${ISO}" -serial stdio -no-reboot "$@"
fi
