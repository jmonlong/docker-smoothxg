FROM ubuntu:18.04
MAINTAINER jmonlong@ucsc.edu

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ARG THREADS=4

RUN apt-get update && \
        apt-get -qqy install zlib1g zlib1g-dev libomp-dev && \
        apt-get -qqy install build-essential software-properties-common && \
        add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
        apt-get update > /dev/null && \
        apt-get -qqy install gcc-snapshot && \
        apt-get update > /dev/null && \
        apt-get -qqy install gcc-8 g++-8 && \
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8 && \
        apt-get -qqy install cmake git

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
        pkg-config \
        python3-dev \
        libxml2-dev libssl-dev libmariadbclient-dev libcurl4-openssl-dev \ 
        apt-transport-https software-properties-common dirmngr gpg-agent \ 
        && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ARG smoothxg_git_revision=5308db30f994f690fdc4fa9c90f9f42716d4b21f

RUN git clone --recursive https://github.com/ekg/smoothxg.git && \
        cd smoothxg && \
        git fetch --tags origin && \
        git checkout "$smoothxg_git_revision" && \
        git submodule update --init --recursive && \
        cmake -H. -Bbuild && \
        cmake --build build -- -j $THREADS

ENV PATH /build/smoothxg/bin:$PATH

ENV SMOOTHXG_COMMIT $smoothxg_git_revision

WORKDIR /home
