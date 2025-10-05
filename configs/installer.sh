#!/bin/sh
# HOS Tools Installer

set -e

echo "HOS Tools Installation"
echo "========================="

INSTALL_DIR="/usr/local/bin"
PROJECT_DIR="$(pwd)"

# Checking rights
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root: sudo ./scripts/installer.sh"
    exit 1
fi

# Installing the utility hos-snapshot
echo "Installing hos-snapshot..."
cp "$PROJECT_DIR/tools/hos-snapshot" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/hos-snapshot"

# Create a config for monitored paths
mkdir -p /etc/hos
cat > /etc/hos/tracked-paths.conf << 'CONFIG'
# HOS Tracked Paths - automatically monitored by hos-snapshot
/etc/motd
/etc/issue
/etc/hostname
/etc/init.d/hos-*
/root/.profile
/root/.bashrc
/usr/local/bin/hos-*
CONFIG

echo "Installed:"
echo "   - hos-snapshot -> $INSTALL_DIR/hos-snapshot"
echo "   - Config -> /etc/hos/tracked-paths.conf"
echo ""
echo " Usage:"
echo "   hos-snapshot        # Save current system state"
echo "   git add . && git commit -m 'update' && git push"
echo ""
echo " Note: Run hos-snapshot after any system changes!"

chmod +x scripts/installer.sh