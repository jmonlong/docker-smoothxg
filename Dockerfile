FROM ubuntu:18.04
MAINTAINER jmonlong@ucsc.edu

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        git \
        gcc-8 g++-8 \
        make \
        cmake \
        pkg-config build-essential software-properties-common \
        libxml2-dev libssl-dev libmariadbclient-dev libcurl4-openssl-dev \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ARG smoothxg_git_revision=fa1508549db0fb44ec91221f9805bbe51a2e9b07

RUN git clone --recursive https://github.com/ekg/smoothxg.git && \
        cd smoothxg && \
        git fetch --tags origin && \
        git checkout "$smoothxg_git_revision" && \
        git submodule update --init --recursive && \
        cmake -H. -Bbuild && \
        cmake --build build --

ENV PATH /build/smoothxg/bin:$PATH

ENV SMOOTHXG_COMMIT $smoothxg_git_revision
