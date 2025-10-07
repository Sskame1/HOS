#!/bin/sh
# HOS Tools Installer

BIN_DIR="/usr/bin"
HOS_PROJ_DIR="$(pwd)"

set -e

echo "HOS Tools Installation"
echo "========================="

# check rights
if [ "$(id) -u" -ne 0 ]; then
    echo "please run as root"
    exit 1
fi

# install snapshot
cp "$HOS_PROJ_DIR/hos-snapshot" "$BIN_DIR"
chmod +x "$BIN_DIR/tools/hos-snapshot"
