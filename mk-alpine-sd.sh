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

BOOT_DEV=$(get_var boot_dev)

echo "Device for boot files: $BOOT_DEV"

