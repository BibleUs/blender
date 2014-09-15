#!/bin/sh

VERSION=$(grep "BLENDER_VERSION\s" ./source/blender/blenkernel/BKE_blender.h | awk '{print $3}' | sed 's/\(.\)\(.\)/\1.\2/')
MANIFEST="/tmp/blender-${VERSION}-manifest.txt"
TARBALL="/tmp/blender-${VERSION}.tar.gz"

# Build master list
git ls-files > $MANIFEST

# Enumerate submodules
for lcv in $(git submodule | cut -f2 -d" ");do
	cd "$lcv";
	git ls-files | sed "s/^\(.*\)$/$lcv\/\1/g" >> $MANIFEST
	cd -;
done

# Create the tarball
tar --transform "s,^,blender-${VERSION}/,g" -zcf $TARBALL -T $MANIFEST

# Cleanup
rm $MANIFEST
