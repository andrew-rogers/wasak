#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

# Create a boot directory for holding files to be zipped
BOOT="$ROOT/tmp"
BOOT_ZIP="$ROOT/boot.zip"
mkdir -p "$BOOT"

create_init_ramfs() {
    echo "create_init_ramfs() is not yet implemented, coming real soon!"
    touch "$BOOT/wasak_init.img"
}

unzip_firmware() {
    local zip="$1"
    
    # Find kernel in zip
    local kernel=$(unzip -l "$zip" | grep "kernel8\.img" | awk '{print $4}')
    
    # If found, unzip it and its siblings. Avoid extracting all that opt stuff.
    if [ -n "$kernel" ] ; then
        local boot=$(dirname "$kernel")
        unzip "$zip" "$boot/*" -d "$BOOT"
    fi
    
    # Get location of extracted kernel
    if [ -f "$BOOT/$kernel" ] ; then
        echo "Extracted kernel: $BOOT/$kernel"
        KERNEL="$BOOT/$kernel"
        set_var KERNEL "$BOOT/$kernel"
    fi
}

create_zip() {
    local boot=$(dirname "$KERNEL")
    ( cd "$boot" && zip "$BOOT_ZIP" -r * )
    ( cd "$BOOT" && zip "$BOOT_ZIP" -r cmdline.txt config.txt wasak_init.img )
}

create_init_ramfs
unzip_firmware "$DOWNLOADS/firmware-stable.zip"

if [ -f "$KERNEL" ] ; then
    echo "console=serial0,115200 console=tty1 rootwait init=/init" > "$BOOT/cmdline.txt"
    echo "arm_64bit=1" > "$BOOT/config.txt"
    echo "initramfs wasak_init.img followkernel" >> "$BOOT/config.txt"
    create_zip
fi
