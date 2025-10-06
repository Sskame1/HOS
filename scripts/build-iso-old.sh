#!/bin/sh
# HOS ISO Builder

set -e

echo "HOS ISO Builder"
echo "=================="

HOS_VERSION="0.0.1"
BUILD_DIR="/tmp/hos-build-$$"
ISO_NAME="HOS-${HOS_VERSION}-$(date +%Y%m%d)"
OUTPUT_DIR="output"

# Checking dependencies
echo "Checking dependencies..."
if ! command -v alpine-make-vm-image >/dev/null; then
    echo "alpine-make-vm-image not found. Installing..."
    sudo apk add alpine-make-vm-image
fi

if ! command -v mkisofs >/dev/null; then
    echo "mkisofs not found. Installing..."
    sudo apk add cdrtools
fi

# Create a temporary directory
mkdir -p "$BUILD_DIR" "$OUTPUT_DIR"
cd "$BUILD_DIR"

# Creating a base Alpine image
echo "Creating base Alpine image..."
sudo alpine-make-vm-image \
    --script-chroot \
    --image-format iso \
    --packages "bash git vim sudo curl wget" \
    --repositories-file /etc/apk/repositories \
    hos-base.iso

# Mounting ISO for customization
echo "Customizing with HOS configs..."
mkdir -p mnt new
sudo mount -o loop hos-base.iso mnt
sudo cp -r mnt/* new/

# Copying configs from the project
echo "Applying HOS configuration..."
cd -
sudo cp -r configs/* "$BUILD_DIR/new/" 2>/dev/null || true

# We create custom services
cd "$BUILD_DIR"
sudo mkdir -p new/etc/init.d

# Automatically create services from saved configurations
if [ -f new/etc/init.d/hos-* ]; then
    for service in new/etc/init.d/hos-*; do
        sudo chmod +x "$service"
    done
fi

# Creating the final ISO
echo "Creating final ISO..."
sudo mkisofs -o "../$OUTPUT_DIR/$ISO_NAME.iso" \
    -b boot/syslinux/isolinux.bin \
    -c boot/syslinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -J -R -V "HOS" \
    new

# Cleaning
cd -
sudo umount "$BUILD_DIR/mnt" 2>/dev/null || true
sudo rm -rf "$BUILD_DIR"

echo ""
echo "Build complete!"
echo "ISO: $OUTPUT_DIR/$ISO_NAME.iso"
echo ""
echo "To write to USB:"
echo "   sudo dd if=$OUTPUT_DIR/$ISO_NAME.iso of=/dev/sdX bs=4M status=progress"

chmod +x scripts/build-iso.sh