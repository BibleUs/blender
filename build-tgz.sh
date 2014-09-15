#!/bin/sh

VERSION="blender-2.71"
MANIFEST="/tmp/${VERSION}-manifest.txt"
TARBALL="/tmp/${VERSION}.tar.gz"

# Build master list
git ls-files > $MANIFEST

# Enumerate submodules
for lcv in $(git submodule | cut -f2 -d" ");do
	cd "$lcv";
	git ls-files | sed "s/^\(.*\)$/$lcv\/\1/g" >> $MANIFEST
	cd -;
done

# Create the tarball
tar --transform "s,^,${VERSION}/,g" -zcvf $TARBALL -T $MANIFEST

# Cleanup
rm $MANIFEST
