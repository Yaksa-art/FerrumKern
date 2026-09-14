#!/bin/sh
# Build FerrumKern ISO with xorriso + limine bios-install.
set -eu
SYSROOT="${SYSROOT:-sysroot}"
ISO="${ISO:-ferrumkern.iso}"
LIMINE_DIR="${LIMINE_DIR:-build/limine}"
LIMINE_BIN=""
for c in "${LIMINE_DIR}/limine" "${LIMINE_DIR}/bin/limine" "build/limine/limine"; do
  if [ -x "$c" ]; then LIMINE_BIN="$c"; break; fi
done
[ -d "${SYSROOT}" ] || { echo "error: SYSROOT missing" >&2; exit 1; }
command -v xorriso >/dev/null 2>&1 || { echo "error: xorriso not found" >&2; exit 1; }
xorriso -as mkisofs -R -r -J \
  -b boot/limine-bios-cd.bin \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -hfsplus -apm-block-size 2048 \
  --efi-boot boot/limine-uefi-cd.bin \
  -efi-boot-part --efi-boot-image --protective-msdos-label \
  "${SYSROOT}" -o "${ISO}"
if [ -z "${LIMINE_BIN}" ]; then echo "warning: limine tool not found, skipping bios-install" >&2; exit 0; fi
"${LIMINE_BIN}" bios-install "${ISO}"
echo "Done: ${ISO}"
