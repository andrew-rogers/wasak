#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

check_boot_dev() {
    local boot_dev="$1"
    if [ -n "$boot_dev" ] ; then

        # Check the device details have not changed
        local dev=$(echo "$boot_dev" | awk '{print $1}')
        local check=$(dev_fs_details "$dev")
        if [ "$boot_dev" = "$check" ] ; then
            echo "$check"
        fi
    fi
}

dev_fs_details() {
    local dev=$1
    local opts=$2

    if [ -z "$opts" ]; then
        opts=NAME,FSTYPE,FSAVAIL,MOUNTPOINT
    fi

    if [ "$dev" = "list" ]; then
        lsblk -l -o "$opts"
    else
        lsblk -n -o "$opts" "/dev/$dev"
    fi
}

ask_boot_dev() {

    # Get array of first partitions for each drive
    local arr=($(dev_fs_details list NAME | grep "[a-z]1$"))
    local i=0;

    # Create empty array
    local options=()

    # Iterate array
    local found="n"
    for dev in ${arr[@]}; do

        # Only list FAT partitions
        local fs=$(dev_fs_details "$dev" FSTYPE)
        if [ "$fs" = "vfat" ] ; then
            local line=$(dev_fs_details "$dev")
            i=$(( i + 1 ))
            IFS=''
            options+=( $i $line )
            found="y"
        fi
    done

    if [ "$found" = "y" ]; then
        # Use a menu dialog to allow user to select boot files partition
        local choice=$(dialog --clear \
                    --menu "Select the partition to extract the boot files:" \
                    15 80 6 \
                    ${options[@]} \
                    2>&1 >/dev/tty)

        clear > /dev/tty

        if [ -n "$choice" ] ; then
            echo "${options[$(( choice * 2 - 1 ))]}"
        fi
    fi
}

cp_sd() {
    local src="$1"
    local dst="$2"

    local mnt=$(get_mnt)

    # Check mount point has at least four characters, i.e. isn't root filesystem.
    if [ "${#mnt}" -ge "4" ] ; then
        cp "$src" "$mnt/$dst"
    fi
}

untgz_sd() {
    local tgz="$1"

    local mnt=$(get_mnt)

    # Check mount point has at least four characters, i.e. isn't root filesystem.
    if [ "${#mnt}" -ge "4" ] ; then
        ( cd "$mnt" && tar -zxvf "$tgz" )
    fi
}

get_mnt() {
    if [ -n "$BOOT_DEV" ] ; then
        local dev=$(echo "$BOOT_DEV" | awk '{print $1}')
        dev_fs_details "$dev" MOUNTPOINT
    fi
}

# Do all the required downloads
$ROOT/downloads.sh

BOOT_DEV=$(get_var boot_dev)
echo "Device for boot files: $BOOT_DEV"

# Un-tar the boot files
MNT=$(get_mnt)
if [ ! -f "$MNT/config.txt" ]; then
    alpine=$(find $DOWNLOADS | grep alpine)
    untgz_sd "$alpine"
fi

# Headless overlay
OVL=wasak.apkovl.tar.gz
( cd overlay && tar --owner=0 --group=0 -zcvf ../$OVL *)
cp_sd "$OVL"

# ttyd to apks
cp_sd "$(find $DOWNLOADS | grep 'ttyd.*\.apk')" apks

# Check for wifi.txt
WIFI=wifi.txt
if [ ! -f "$MNT/$WIFI" ] ; then
    echo "The $WIFI file was not found on $MNT. This will be needed for wireless networks."
fi

