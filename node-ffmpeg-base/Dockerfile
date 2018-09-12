FROM irakli/nodejs:latest AS BUILD_IMAGE
LABEL maintainer="hkbwt.code@gmail.com"

RUN apt-get -y update
RUN apt-get -y install libzmq-dev
RUN apt-get -y install build-essential
RUN apt-get -y install python
RUN apt-get -y install graphicsmagick
RUN apt-get -y install libexiv2-12
RUN apt-get -y install libexiv2-dev
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe multiverse >> /etc/apt/sources.list; apt-get update; apt-get -y install autoconf automake build-essential git mercurial cmake libass-dev libgpac-dev libtheora-dev libtool libvdpau-dev libvorbis-dev pkg-config texi2html zlib1g-dev libmp3lame-dev wget yasm;

ADD build_ffmpeg.sh /build_ffmpeg.sh
RUN ["/bin/bash", "/build_ffmpeg.sh"]

FROM node:8.9
COPY --from=BUILD_IMAGE /usr/local/bin/aacgain /usr/local/bin/aacgain
COPY --from=BUILD_IMAGE /usr/local/bin/boxdumper /usr/local/bin/boxdumper
COPY --from=BUILD_IMAGE /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=BUILD_IMAGE /usr/local/bin/ffprobe /usr/local/bin/ffprobe
COPY --from=BUILD_IMAGE /usr/local/bin/ffserver /usr/local/bin/ffserver
COPY --from=BUILD_IMAGE /usr/local/bin/muxer /usr/local/bin/muxer
COPY --from=BUILD_IMAGE /usr/local/bin/remuxer /usr/local/bin/remuxer
COPY --from=BUILD_IMAGE /usr/local/bin/timelineeditor /usr/local/bin/timelineeditor
COPY --from=BUILD_IMAGE /usr/local/bin/x264 /usr/local/bin/x264



CMD ["ffmpeg"]
