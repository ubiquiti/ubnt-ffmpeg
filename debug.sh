#!/bin/sh

set -e

DEST_FOLDER=${LOCAL_PREFIX}
PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${LOCAL_PREFIX}/lib/pkgconfig

if [ ! -f ./.configured ]; then
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
	>./.configured
fi

make -j32
./ffmpeg -y -rtsp_transport tcp -i rtsp://10.0.20.2:9997/0418D6A0F52E_0 -acodec copy -vcodec copy -f flv /dev/null
