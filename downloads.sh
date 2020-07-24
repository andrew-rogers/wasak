#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

get_downloads() {
    local prev="$PWD"
    cd "$DOWNLOADS"
    [ ! -f "firmware-stable.zip" ] && wget "https://github.com/raspberrypi/firmware/archive/stable.zip" -O "firmware-stable.zip"
    [ ! -f "busybox-armv7l" ] && wget "https://www.busybox.net/downloads/binaries/1.21.1/busybox-armv7l"
    [ ! -f "gen_init_cpio.c" ] && wget "https://github.com/raspberrypi/linux/blob/rpi-5.4.y/usr/gen_init_cpio.c"
    cd "$prev"
}

get_downloads
