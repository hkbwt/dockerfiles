#!/bin/bash

set -ex

IMAGENAME="hkbwt/youtube-dl"
SCRIPTPATH=
PROJECTPATH=
BUILDPATH=
CONFIGPATH=

VIDEO_PLAYLISTS=(
)

AUDIO_PLAYLISTS=(
)

if [ -z "$(docker images $IMAGENAME -q)" ]; then
  docker build -t $IMAGENAME $BUILDPATH
fi

for PL in ${VIDEO_PLAYLISTS}; do
  docker run --rm \
    -v "downloads:/downloads" \
    -v "${CONFIGPATH}/video.conf:/youtube-dl/config:ro" \
    -v "${CONFIGPATH}/.netrc:/root/.netrc:ro" \
    $IMAGENAME \
    --config-location /youtube-dl/config \
    $PL
done


for PL in ${AUDIO_PLAYLISTS}; do
  docker run --rm \
    -v "downloads:/downloads" \
    -v "${CONFIGPATH}/music.conf:/youtube-dl/config:ro" \
    -v "${CONFIGPATH}/.netrc:/root/.netrc:ro" \
    $IMAGENAME \
    --config-location /youtube-dl/config \
    $PL
done
