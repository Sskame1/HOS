#!/bin/sh

set -e

PROJECT_DIR="/mnt/shared"
CONFIGS_DIR="$PROJECT_DIR/configs"
ISO_OUTPUT="$PROJECT_DIR/output"

mkdir -p "$ISO_OUTPUT"

echo "Downloading Alpine ISO..."
wget -O "$ISO_OUTPUT/alpine-standard-3.22.2-x86_64.iso" \
    "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-standard-3.22.2-x86_64.iso"

WORK_DIR="$ISO_OUTPUT/iso-work"
mkdir -p "$WORK_DIR"

mkdir -p "$WORK_DIR/mnt"
mount -o loop "$ISO_OUTPUT/alpine-standard-3.22.2-x86_64.iso" "$WORK_DIR/mnt"

echo "Copying ISO contents..."
cp -r "$WORK_DIR/mnt/" "$WORK_DIR/iso"

umount "$WORK_DIR/mnt"

INITRAMFS_DIR="$WORK_DIR/initramfs"
mkdir -p "$INITRAMFS_DIR"

echo "Extracting initramfs..."
cd "$INITRAMFS_DIR"
zcat "$WORK_DIR/iso/boot/initramfs-lts" | cpio -idm

echo "Copying custom configs..."
if [ -d "$CONFIGS_DIR" ]; then
    cp -r "$CONFIGS_DIR"/* "$INITRAMFS_DIR/"
    echo "Configs copied successfully"
else
    echo "Warning: Configs directory $CONFIGS_DIR not found"
fi

echo "Rebuilding initramfs..."
cd "$INITRAMFS_DIR"
find . | cpio -H newc -o | gzip -9 > "$WORK_DIR/iso/boot/initramfs-lts"

echo "Creating custom ISO..."
xorriso -as mkisofs \
    -rational-rock \
    -volid "ALPINE_CUSTOM" \
    -output "$ISO_OUTPUT/HOS.iso" \
    -isohybrid-mbr /usr/share/syslinux/isohdpfx.bin \
    -b boot/syslinux/isolinux.bin \
    -c boot/syslinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    "$WORK_DIR/iso"

rm -rf "$WORK_DIR"

echo "Custom ISO created: $ISO_OUTPUT/HOS.iso"