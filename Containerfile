FROM docker.io/nvidia/cuda:13.2.0-cudnn-runtime-ubuntu24.04

ARG HASHCAT_VERSION=7.1.2

# Install build-time deps, fetch & unpack hashcat, then purge what's no longer needed
RUN apt-get update && apt-get install -y \
        p7zip-full \
        wget \
        cuda-nvrtc-13-2 \
        cuda-cudart-13-2 \
    && wget -q https://github.com/hashcat/hashcat/releases/download/v${HASHCAT_VERSION}/hashcat-${HASHCAT_VERSION}.7z \
    && 7z x hashcat-${HASHCAT_VERSION}.7z \
    && mkdir -p /opt/hashcat \
    && mv hashcat-${HASHCAT_VERSION}/* /opt/hashcat/ \
    && rm -rf hashcat-${HASHCAT_VERSION} hashcat-${HASHCAT_VERSION}.7z \
    && chmod +x /opt/hashcat/hashcat.bin \
    && ln -s /opt/hashcat/hashcat.bin /usr/bin/hashcat \
    && chmod -R 777 /opt/hashcat \
    && apt-get purge -y --auto-remove wget p7zip-full \
    && rm -rf /var/lib/apt/lists/*

# CUDA symlinks and library registration
RUN ln -s /usr/local/cuda-13.2 /usr/local/cuda \
    && ln -s /usr/local/cuda/targets/x86_64-linux/lib/libnvrtc.so.13 \
              /usr/local/cuda/targets/x86_64-linux/lib/libnvrtc.so \
    && echo "/usr/local/cuda/targets/x86_64-linux/lib" > /etc/ld.so.conf.d/cuda.conf \
    && ldconfig

# OpenCL vendor directory
RUN mkdir -p /usr/bin/OpenCL \
    && ln -s /etc/OpenCL/vendors /usr/bin/OpenCL/vendors
