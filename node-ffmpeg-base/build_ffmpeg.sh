#!/bin/bash
set -xe
SOURCE_DIR=/usr/local/src
BUILD_DIR=/usr/local

#install required things from apt
installLibs() {
echo "Installing prerequisites"
sudo apt-get update
sudo apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev nasm
}

# Compile L-SMASH
comileLSmash() {
echo "Compiling L-Smash"
cd $SOURCE_DIR/ffmpeg_source
wget -O l-smash-2.9.1.tar.gz https://github.com/l-smash/l-smash/archive/v2.9.1.tar.gz
tar xzvf l-smash-2.9.1.tar.gz
cd l-smash-2.9.1

./configure
make -j $(nproc)
make install
}


# Compile libx264
compileLibX264() {
echo "Compiling libx264"
cd $SOURCE_DIR/ffmpeg_source
wget -O x264.tar.bz2 http://download.videolan.org/pub/x264/snapshots/x264-snapshot-20171026-2245.tar.bz2
tar xjvf x264.tar.bz2 && mv x264-snapshot-20171026-2245 x264
cd x264

./configure ./configure --prefix="$BUILD_DIR/ffmpeg_build" --bindir="$BUILD_DIR/bin" --enable-static --disable-asm
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean
}

# Compile libx265
compileLibX265() {
echo "Compiling libx265"
cd $SOURCE_DIR/ffmpeg_source
wget -O x265.tar.gz https://bitbucket.org/multicoreware/x265/downloads/x265_2.5.tar.gz
tar xzvf x265.tar.gz
cd x265_2.5/build/linux

cmake -DCMAKE_INSTALL_PREFIX:PATH="$BUILD_DIR/ffmpeg_build" ../../source
make -j $(nproc)
make install
}

#Compile libfdk-acc
compileLibfdkcc() {
echo "Compiling libfdk-acc"
cd $SOURCE_DIR/ffmpeg_source
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/archive/v0.1.5.tar.gz
tar xzvf fdk-aac.tar.gz
cd fdk-aac-0.1.5

autoreconf -fiv
./configure --prefix="$BUILD_DIR/ffmpeg_build" --disable-shared
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean
}

#Compile libmp3lame
compileLibMP3Lame() {
echo "Compiling libmp3lame"
cd $SOURCE_DIR/ffmpeg_source
wget -O lame-3.99.5.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5

./configure --prefix="$BUILD_DIR/ffmpeg_build" --enable-nasm --disable-shared
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean
}

#Compile libvpx
compileLibPvx() {
echo "Compiling libvpx"
cd $SOURCE_DIR/ffmpeg_source
wget -O libvpx.tar.bz2 storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.6.0.tar.bz2
tar xjvf libvpx.tar.bz2
cd libvpx-1.6.0

./configure --prefix="$BUILD_DIR/ffmpeg_build" --disable-examples
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) clean
}

#Compile libopus
compileLibOpus() {
echo "Compiling libopus"
cd $SOURCE_DIR/ffmpeg_source
wget -O opus.tar.gz http://downloads.xiph.org/releases/opus/opus-1.1.3.tar.gz
tar xzvf opus.tar.gz
cd opus-1.1.3

./configure --prefix="$BUILD_DIR/ffmpeg_build" --disable-shared
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean
}

#Compile ffmpeg
compileFfmpeg() {
echo "Compiling ffmpeg"
cd $SOURCE_DIR/ffmpeg_source
wget -O ffmpeg.tar.bz2 http://ffmpeg.org/releases/ffmpeg-3.4.tar.bz2
tar xjvf ffmpeg.tar.bz2
cd ffmpeg-3.4

PKG_CONFIG_PATH="$BUILD_DIR/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$BUILD_DIR/ffmpeg_build" \
  --extra-cflags="-I$BUILD_DIR/ffmpeg_build/include" \
  --extra-ldflags="-L$BUILD_DIR/ffmpeg_build/lib" \
  --bindir="$BUILD_DIR/bin" \
  --enable-gpl \
  --enable-libx264 \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-vaapi \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-nonfree
make -j$(nproc)
make -j$(nproc) install
make -j$(nproc) distclean
hash -r
}

# Compile aacgain
compileAacgain() {
cd $SOURCE_DIR/ffmpeg_source
git clone --depth 1 https://github.com/mulx/aacgain.git
cd $SOURCE_DIR/ffmpeg_source/aacgain/mp4v2
./configure && make -k -j $(nproc) || true # some commands fail but build succeeds
cd $SOURCE_DIR/ffmpeg_source/aacgain/faad2
./configure && make -k -j $(nproc) || true # some commands fail but build succeeds
cd $SOURCE_DIR/ffmpeg_source/aacgain
./configure && make -j $(nproc) && make install
}


#The process
mkdir -p $SOURCE_DIR/ffmpeg_source
cd $SOURCE_DIR/ffmpeg_source

installLibs
comileLSmash
compileLibX264
#compileLibX265
compileLibfdkcc
compileLibMP3Lame
compileLibOpus
compileLibPvx
compileAacgain
compileFfmpeg
echo "Complete!"

