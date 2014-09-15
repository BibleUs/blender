#!/bin/sh

VERSION="v$(grep "BLENDER_VERSION\s" ./source/blender/blenkernel/BKE_blender.h | awk '{print $3}' | sed 's/\(.\)\(.\)/\1.\2/')"
MANIFEST="/tmp/blender-${VERSION}-manifest.txt"
TARBALL="/tmp/blender-${VERSION}.tar.gz"

# Build master list
echo "Building manifest of files..."
git ls-files > $MANIFEST

# Enumerate submodules
for lcv in $(git submodule | cut -f2 -d" ");do
	cd "$lcv";
	git ls-files | sed -n "s/^\(.*\)$/$lcv\/\1/g" 2>/dev/null >> $MANIFEST
	cd - > /dev/null;
done

# Create the tarball
echo -n "Creating ${TARBALL}..."
tar --transform "s,^,blender-${VERSION}/,g" -zcf $TARBALL -T $MANIFEST
echo "OK"

# Create checksum file
echo -n "Createing ${TARBALL}.md5sum..."
md5sum ${TARBALL} | sed 's#/tmp/##' > ${TARBALL}.md5sum
echo "OK"

# Cleanup
echo -n "Cleaning up..."
rm $MANIFEST
echo "OK"

echo "Done!"
echo "Your files are in /tmp"
