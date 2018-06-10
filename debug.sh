#!/bin/sh

set -ex

export TEMP_PREFIX=/tmp/fftests/external_libs/ffmpeg
export FFMPEG_EXTRA_CFLAGS='-mmacosx-version-min=10.11'

git clean -dxff ./

if [ ! -f ./.configured ]
then
	./configure \
		--prefix=${TEMP_PREFIX} \
		--extra-cflags="${FFMPEG_EXTRA_CFLAGS} -I${TEMP_PREFIX}/include -g" \
		--extra-ldflags="-L${TEMP_PREFIX}/lib" \
		--enable-debug \
		--disable-optimizations \
		`cat ./features.txt|grep -v "^#"|tr "\n" " "`
	>./.configured
fi

mv ${TEMP_PREFIX}/lib/libx264.a /tmp
rm -rf ${TEMP_PREFIX}
make -j32 install
mv /tmp/libx264.a ${TEMP_PREFIX}/lib/
>${TEMP_PREFIX}/.extracted
