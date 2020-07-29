# Shebang line not needed. This file is sourced by init.
# Because this file is sourced, it does not need execute permission and thus can reside on a FAT filesystem.

PKG_DIR=/mnt/boot/wasak_packages

install_packages() {
    for pkg in "$PKG_DIR"/*.zip; do
        if [ -f "$pkg" ]; then
            unzip "$pkg"
            if [ -f POSTINST.sh ]; then
                . POSTINST.sh
            fi
        fi
    done
    for pkg in "$PKG_DIR"/*.tgz; do
        if [ -f "$pkg" ]; then
            tar -zxvf "$pkg"
            if [ -f POSTINST.sh ]; then
                . POSTINST.sh
            fi
        fi
    done
}

mkdir -p /lib
ln -s /mnt/boot/modules /lib/modules

mkdir -p /sys
mount -t sysfs sys /sys

# Pseudoterminals (telnetd, sshd, etc.) require /dev/pts
mkdir /dev/pts
/bin/mount -t devpts none /dev/pts

cd /
install_packages

echo "Welcome to the WaSaK test shell."
sh

