
#!/bin/sh

set -e

# if [ ! -f ${LOCAL_PREFIX}/lib/libfaac.a ]
# then
# 	FAAC_VERSION=1.28
# 	FAAC_BASE_NAME=faac-${FAAC_VERSION}
# 	FAAC_ZIP_NAME=${FAAC_BASE_NAME}.zip
# 	FAAC_URL=http://freefr.dl.sourceforge.net/project/faac/faac-src/${FAAC_BASE_NAME}/${FAAC_ZIP_NAME}

# 	(cd /tmp \
# 		&& curl ${FAAC_URL} -o ${FAAC_ZIP_NAME} \
# 		&& tar xvf ${FAAC_ZIP_NAME} \
# 		&& cd ${FAAC_BASE_NAME} \
# 		&& for i in `find . -type f`;do dos2unix $i;done \
# 		&& ./bootstrap \
# 		&& ./configure --disable-shared --enable-static --without-mp4v2 --prefix=${LOCAL_PREFIX} \
# 		&& make -j32 install \
# 	)
# fi

./configure \
	--prefix=${LOCAL_PREFIX} \
	--extra-cflags="-I${LOCAL_PREFIX}/include" \
	--extra-ldflags="-L${LOCAL_PREFIX}/lib" \
	--enable-gpl \
	--enable-libx264 \


rm -rf ${LOCAL_PREFIX}/include/libav*
rm -rf ${LOCAL_PREFIX}/lib/libav*
rm -rf ${LOCAL_PREFIX}/lib/pkgconfig/libav*

make -j32 install

