#!/bin/sh

set -ex

rm -rfv /tmp/a.*

make

DST_PORT=9999
SAVE_FILE=yes

BITRATE=128000
# CHANNELS=1
# RATE=8000

CODEC=opus

INPUT_FILE=$(realpath ~/work/media/mp4/cabron1.mp4)
INPUT_SETTINGS="-y -i ${INPUT_FILE} -vn"
REAL_TIME_INPUT_SETTINGS="-re ${INPUT_SETTINGS}"

ENCODING_SETTINGS=""
if [ "${BITRATE}" != "" ]; then
    ENCODING_SETTINGS="${ENCODING_SETTINGS} -b:a ${BITRATE}"
fi
if [ "${CHANNELS}" != "" ]; then
    ENCODING_SETTINGS="${ENCODING_SETTINGS} -ac ${CHANNELS}"
fi
if [ "${RATE}" != "" ]; then
    ENCODING_SETTINGS="${ENCODING_SETTINGS} -ar ${RATE}"
fi

RTP_SETTINGS=" \
    -f rtp \
    -payload_type 110 \
    -ssrc 2 \
    -sdp_file /tmp/a.sdp \
    rtp://127.0.0.1:${DST_PORT} \
"

if [ "${CODEC}" == "opus" ]; then
    # effective sampling rate is governed by the cutoff rate
    #+====================+===============+=====================+
    #|Abbreviation        |Audio bandwidth|Effective sample rate|
    #+====================+===============+=====================+
    #|NB (narrowband)     |4 kHz          |8 kHz                |
    #+--------------------+---------------+---------------------+
    #|MB (medium-band)    |6 kHz          |12 kHz               |
    #+--------------------+---------------+---------------------+
    #|WB (wideband)       |8 kHz          |16 kHz               |
    #+--------------------+---------------+---------------------+
    #|SWB (super-wideband)|12 kHz         |24 kHz               |
    #+--------------------+---------------+---------------------+
    #|FB (fullband)       |20 kHz         |48 kHz               |
    #+--------------------+---------------+---------------------+

    CODEC_SETTINGS=" \
        -acodec libopus \
        -application lowdelay \
        -frame_duration 2.5 \
    "
    # -cutoff 12000 \

    OUTPUT_FILE="/tmp/a.ogg"
else
    CODEC_SETTINGS=" \
        -acodec libfdk_aac \
        -profile:a aac_eld \
        -flags +global_header \
    "
    OUTPUT_FILE="/tmp/a.mp4"
fi

if [ "${SAVE_FILE}" == "yes" ]; then
    ./ffmpeg ${INPUT_SETTINGS} \
        ${CODEC_SETTINGS} \
        ${ENCODING_SETTINGS} \
        ${OUTPUT_FILE}
fi

./ffmpeg ${REAL_TIME_INPUT_SETTINGS} \
    ${CODEC_SETTINGS} \
    ${ENCODING_SETTINGS} \
    ${RTP_SETTINGS}
