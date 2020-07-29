#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

PKG_BUILD_DIR="$ROOT/pkg_build.d"
PKG_DST="$ROOT/tmp/wasak_packages"

mkdir -p "$PKG_DST"

for dir in "$PKG_BUILD_DIR"/*; do
    if [ -f "$dir/BUILDPKG.sh" ] ; then
        . "$dir/BUILDPKG.sh"
    else
        echo "BUILDPKG.sh not found in $dir"
    fi
done

