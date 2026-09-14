#!/bin/sh
# Fetch and stage Limine bootloader files for FerrumKern.
# Usage: VERSION=v9.3.0 sh boot/get-limine.sh
set -eu

VERSION="${VERSION:-v9.3.0}"
LIMINE_DIR="${LIMINE_DIR:-build/limine}"
BOOT_DIR="boot"

VER="${VERSION#v}"
TARBALL="limine-${VER}.tar.xz"
URL="https://github.com/limine-bootloader/limine/releases/download/${VERSION}/${TARBALL}"

echo "Fetching Limine ${VERSION} from ${URL}"
mkdir -p "${LIMINE_DIR}" "${BOOT_DIR}" build

TMP_TAR="build/${TARBALL}"
if [ ! -f "${TMP_TAR}" ]; then
  if command -v curl >/dev/null 2>&1; then
    curl -fL -o "${TMP_TAR}" "${URL}"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "${TMP_TAR}" "${URL}"
  else
    echo "error: need curl or wget" >&2
    exit 1
  fi
fi

tar -xf "${TMP_TAR}" -C build
EXTRACTED="build/limine-${VER}"
if [ "${LIMINE_DIR}" != "${EXTRACTED}" ]; then
  mkdir -p "${LIMINE_DIR}"
  cp -a "${EXTRACTED}/." "${LIMINE_DIR}/"
  SRC="${LIMINE_DIR}"
else
  SRC="${EXTRACTED}"
fi

for f in limine-bios.sys limine-bios-cd.bin limine-uefi-cd.bin BOOTX64.EFI; do
  cp -f "${SRC}/${f}" "${BOOT_DIR}/${f}"
done
echo "Staged into ${BOOT_DIR}/"
