
#!/bin/sh

set -e

DEST_FOLDER=${LOCAL_PREFIX}

./configure \
	--prefix=${DEST_FOLDER} \
	--extra-cflags="-fno-stack-check -I${LOCAL_PREFIX}/include -I${DEST_FOLDER}/include" \
	--extra-ldflags="-L${LOCAL_PREFIX}/lib -L${DEST_FOLDER}/lib" \
	--enable-gpl \
	--enable-nonfree \
	--enable-libx264 \
	--enable-libfdk-aac \
	--enable-libopus \
	--disable-encoder=opus \
	--disable-decoder=opus

	# --enable-debug \
	# --disable-optimizations \

make -j32 install
