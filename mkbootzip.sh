#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

FW_ZIP="$DOWNLOADS/firmware-stable.zip"

# Create a boot directory for holding files to be zipped
BOOT="$ROOT/tmp"
BOOT_ZIP="$ROOT/boot.zip"
mkdir -p "$BOOT"

create_init_ramfs() {
    if [ ! -f "$ROOT/gen_init_cpio" ] ; then
        ( cd "$ROOT" && gcc "$DOWNLOADS/gen_init_cpio.c" -o gen_init_cpio )
    fi

    local prev="$PWD"

    IMG=wasak_init.img

    cd "$ROOT"
    ./gen_init_cpio file_list.txt > "$IMG"
    gzip "$IMG"
    mv "$IMG.gz" "$BOOT/$IMG"

    cd "$prev"
}

unzip_firmware() {
    
    # Find kernel in zip
    local kernel=$(cat "$BOOT/fw_file_list.txt" | grep "kernel8\.img" | awk '{print $4}')
    
    # If found, unzip it and its siblings. Avoid extracting all that opt stuff.
    if [ -n "$kernel" ] ; then
        local boot=$(dirname "$kernel")
        unzip -qo "$FW_ZIP" "$boot/*" -d "$BOOT"
    fi
    
    # Get location of extracted kernel
    if [ -f "$BOOT/$kernel" ] ; then
        echo "Extracted kernel: $BOOT/$kernel"
        KERNEL="$BOOT/$kernel"
        set_var KERNEL "$BOOT/$kernel"
    fi
}

unzip_module() {
    if [ -z "$FWZ_MODULES" ]; then
        FWZ_MODULES=$(cat "$BOOT/fw_file_list.txt" | grep brcmfmac.ko | awk '{print $4}' | grep v8 | sed 's|/kernel/drivers/.*||')
        msg "Found kernel modules in $FW_ZIP at $FWZ_MODULES"
    fi

    local mod=$(cat "$BOOT/fw_file_list.txt" | grep "$FWZ_MODULES" | grep "/$1\.ko" | awk '{print $4}')
    if [ -n "$mod" ]; then
        unzip -qo "$FW_ZIP" "$mod" -d "$BOOT"
    else
        msg "Could not locate kernel module: $1"
    fi
}

create_zip() {
    local boot=$(dirname "$KERNEL")
    ( cd "$boot" && zip "$BOOT_ZIP" -r * && cd .. && zip "$BOOT_ZIP" -r modules/* )
    ( cd "$BOOT" && zip "$BOOT_ZIP" cmdline.txt config.txt wasak_init.img )
    ( cd "$ROOT" && zip "$BOOT_ZIP" wasak.sh )
    ( cd "$BOOT" && zip "$BOOT_ZIP" -r wasak_packages/* )
}

# Invoke the package builder
$ROOT/pkg_build.sh

create_init_ramfs

unzip -l "$FW_ZIP" > "$BOOT/fw_file_list.txt"

unzip_firmware

unzip_module ipv6
unzip_module nf_defrag_ipv6
unzip_module brcmfmac
unzip_module brcmutil
unzip_module sha256_generic
unzip_module libsha256
unzip_module cfg80211
unzip_module rfkill

if [ -f "$KERNEL" ] ; then
    echo "console=serial0,115200 console=tty1 rootwait init=/init" > "$BOOT/cmdline.txt"
    echo "arm_64bit=1" > "$BOOT/config.txt"
    echo "initramfs wasak_init.img followkernel" >> "$BOOT/config.txt"
    create_zip
fi
