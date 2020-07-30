# Shebang not required. Sourced by pkg_build.

# Get the networking and WPA stuff from NOOBS and create package.

mkdir -p "$dir/src"
mkdir -p "$dir/root"

noobs_unzip() {
    local noobs_zip=$(find "$DOWNLOADS" | grep "NOOBS_lite" | tail -n1)
    if [ -f "$noobs_zip" ]; then
        ( cd "$dir/src" && unzip -o "$noobs_zip" "recovery.rfs" && unsquashfs "recovery.rfs")
    else
        echo "Could not find NOOBS in downloads directory."
    fi
}

mycp () {
    local src="$dir/src/squashfs-root/$1"
    local dst=$(dirname "$dir/root/$1")
    mkdir -p "$dst"
    cp -a $src "$dst/"
}

build_tgz() {
    cp "$dir/POSTINST.sh" "$dir/root"
    ( cd "$dir/root" && tar --owner=0 --group=0 -zcvf "$PKG_DST/noobs_wpa.tgz" * )
}

noobs_unzip
mycp sbin/dhcpcd
mycp lib/ld*
mycp lib/ld*
mycp lib/libuClibc*
mycp lib/libc.so.0
mycp lib/firmware
mycp etc/init.d/S30dbus
mycp usr/bin/dbus-daemon
mycp usr/bin/dbus-uuidgen
mycp usr/lib/libdbus*
mycp usr/lib/libexpat*
mycp lib/libpthread*
mycp lib/libgcc*
mycp lib/libdl*
mycp etc/dbus-1/system.conf
mycp etc/dbus-1/system.d
mycp etc/passwd
mycp usr/sbin/wpa*
mycp etc/network/interfaces
mycp lib/librt*
mycp etc/libnl
mycp usr/lib/libnl*
mycp usr/lib/libssl*
mycp usr/lib/libcrypto*
mycp lib/libm*
mycp libexec
mycp usr/share
mycp etc/group
build_tgz
