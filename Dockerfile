FROM ubuntu:16.04

# install qt download prereqs
RUN apt-get update \
    && apt-get install -y \
    wget

# download qt (do this early for caching)
RUN mkdir /qt \
    && cd /qt \
    && wget https://download.qt.io/archive/qt/5.4/5.4.2/single/qt-everywhere-opensource-src-5.4.2.tar.gz \
    && tar xzvf qt-everywhere-opensource-src-5.4.2.tar.gz

# install build tools
RUN apt-get install -y \
    chrpath \
    bison \ 
    flex \ 
    gperf \
    libfontconfig1-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libgstreamer1.0-dev  \
    libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev \
    libicu-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb1-dev \
    libxcb-glx0-dev \
    libxcomposite-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxml2-dev \
    libxrender-dev \
    libxslt-dev \
    make \
    ruby

# perform configuration
RUN mkdir -p /qt/Qt5.4.2/5.4/gcc_64 \
    && cd /qt/qt-everywhere-opensource-src-5.4.2 \
    && ./configure -prefix /qt/Qt5.4.2/5.4/gcc_64 -opensource -confirm-license -no-reduce-relocations -nomake tests -nomake examples -verbose -qt-xcb 

# compile (this takes a long time)
RUN cd /qt/qt-everywhere-opensource-src-5.4.2 \
    && make -j4  \
    && make install

# rewrite RPATH for libraries. by default the RPATH is set to the resolved
# -prefix passed to 'configure', but we need the libraries to be able to find
# each other regardless of where they're installed
RUN cd /qt/Qt5.4.2/5.4/gcc_64/lib \
    && chrpath -k -r '$ORIGIN' *.so; exit 0 

# rewrite RPATH for binaries
RUN cd /qt/Qt5.4.2/5.4/gcc_64/bin \
    && chrpath -k -r '$ORIGIN/../lib' *; exit 0 

# produce tarball 
RUN cd /qt \
    && tar czvf QtSDK-5.4.2-x86_64.tar.gz Qt5.4.2

