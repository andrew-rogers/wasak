# Shebang line not needed. This file is sourced by init.
# Because this file is sourced, it does not need execute permission and thus can reside on a FAT filesystem.

BOOT=/mnt/boot
PKG_DIR="$BOOT/wasak_packages"

install_packages() {
    for pkg in "$PKG_DIR"/*.zip; do
        if [ -f "$pkg" ]; then
            wasak_log "Expanding package: $pkg"
            unzip "$pkg"
            if [ -f POSTINST.sh ]; then
                . POSTINST.sh
            fi
        fi
    done
    for pkg in "$PKG_DIR"/*.tgz; do
        if [ -f "$pkg" ]; then
            wasak_log "Expanding package: $pkg"
            tar -zxvf "$pkg"
            if [ -f POSTINST.sh ]; then
                . POSTINST.sh
            fi
        fi
    done
}

wasak_log() {
    local log_file="$BOOT/wasak.log"
    if [ -f "$log_file" ]; then
        printf "%s\n" "$*" >> "$log_file"
    else
        printf "%s\n" "$*" >&2
    fi
}

wasak_log "Running $BOOT/wasak.sh"

mkdir -p /lib || wasak_log "Could not create /lib directory."

if [ -d "$BOOT/modules" ]; then
    ln -s /mnt/boot/modules /lib/modules
else
    wasak_log "Kernel modules not found in $BOOT"
fi

mkdir -p /sys || wasak_log "Could not create /sys mount point."
mount -t sysfs sys /sys || wasak_log "Could not mount sysfs."

# Pseudoterminals (telnetd, sshd, etc.) require /dev/pts
mkdir /dev/pts
/bin/mount -t devpts none /dev/pts || wasak_log "Could not mount devpts."

cd /
install_packages

sync

