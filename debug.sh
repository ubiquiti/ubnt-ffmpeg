#/bin/sh

set -e

export TEMP_PREFIX=/Users/shiretu/work/evostream/builders/cmake/external_libs/libav
export LIBAV_EXTRA_CFLAGS='-mmacosx-version-min=10.11'

if [ ! -f ./.configured ]
then
	./configure \
		--prefix=${TEMP_PREFIX} \
		--extra-cflags="${LIBAV_EXTRA_CFLAGS} -I${TEMP_PREFIX}/include -g" \
		--extra-ldflags="-L${TEMP_PREFIX}/lib" \
		--enable-debug \
		--disable-optimizations \
		`cat ./features.txt|tr "\n" " "`
	>./.configured
fi

make -j32 install

