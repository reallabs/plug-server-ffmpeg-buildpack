# This needs to match the ubuntu version in the heroku stack
FROM ubuntu:20.04

# Update package manager
RUN apt-get update

# Install dependencies for build process
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libfreetype6-dev \
    libgnutls28-dev \
    libmp3lame-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    meson \
    ninja-build \
    pkg-config \
    texinfo \
    wget \
    yasm \
    zlib1g-dev \
    libunistring-dev \
    libaom-dev

# Create working directories
RUN mkdir -p ~/ffmpeg_sources ~/bin

# Install dependency for libx264
RUN apt-get --assume-yes install libx264-dev

# Configure and compile app
RUN cd ~/ffmpeg_sources && \
    wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --bindir="$HOME/bin" \
    --enable-small \
    --enable-gpl \
    --enable-libx264 \
    --enable-nonfree && \
    PATH="$HOME/bin:$PATH" make && \
    make install && \
    hash -r

# Test if installation was succesful
RUN ~/bin/ffmpeg -version
