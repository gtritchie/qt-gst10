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

# install libgstreamer and build tools
RUN apt-get install -y \
    make \
    libgstreamer1.0 

# perform configuration
RUN cd /qt/qt-everywhere-opensource-src-5.4.2 \
    && ./configure -opensource -confirm-license

# compile
RUN cd /qt/qt-everywhere-opensource-src-5.4.2 \
    && make \
    && make install

