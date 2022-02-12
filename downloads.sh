#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

get_downloads() {
    [ ! -f "firmware-stable.zip" ] && wget "https://github.com/raspberrypi/firmware/archive/stable.zip" -O "firmware-stable.zip"
    [ ! -f "busybox-armv7l" ] && wget "https://www.busybox.net/downloads/binaries/1.21.1/busybox-armv7l"
    [ ! -f "gen_init_cpio.c" ] && wget "https://github.com/raspberrypi/linux/raw/rpi-5.4.y/usr/gen_init_cpio.c"
    [ ! -f "alpine-rpi-3.15.0-aarch64.tar.gz" ] && wget "https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/aarch64/alpine-rpi-3.15.0-aarch64.tar.gz"
    [ ! -f "ttyd-1.6.3-r3.apk" ] && wget "http://dl-cdn.alpinelinux.org/alpine/edge/community/aarch64/ttyd-1.6.3-r3.apk"
}

( mkdir -p "$DOWNLOADS" && cd "$DOWNLOADS" && get_downloads )
