# Shebang not required. Sourced by pkg_build.

mkdir -p "$dir/root/bin"
cp "$DOWNLOADS/ttyd_linux.armhf" "$dir/root/bin"

build_tgz() {
    cp "$dir/POSTINST.sh" "$dir/root"
    chmod +x "$dir/root/bin/ttyd_linux.armhf"
    ( cd "$dir/root" && tar --owner=0 --group=0 -zcvf "$PKG_DST/ttyd.tgz" * )
}

build_tgz
