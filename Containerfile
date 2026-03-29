FROM docker.io/nvidia/cuda:13.2.0-cudnn-runtime-ubuntu24.04

ARG HASHCAT_VERSION=7.1.2
 
RUN apt-get update && apt-get install -y \
    p7zip-full \
    wget \
    cuda-nvrtc-13-2 \
    cuda-cudart-13-2 \
    && rm -rf /var/lib/apt/lists/*
 
# Install hashcat from GitHub release
RUN wget https://github.com/hashcat/hashcat/releases/download/v${HASHCAT_VERSION}/hashcat-${HASHCAT_VERSION}.7z \
    && 7z x hashcat-${HASHCAT_VERSION}.7z \
    && cp hashcat-${HASHCAT_VERSION}/hashcat.bin /usr/bin/hashcat \
    && chmod +x /usr/bin/hashcat \
    && rm -rf hashcat-${HASHCAT_VERSION} hashcat-${HASHCAT_VERSION}.7z

# symlink cuda-13.2 to cuda
RUN ln -s /usr/local/cuda-13.2 /usr/local/cuda

# create missing unversioned symlink
RUN ln -s /usr/local/cuda/targets/x86_64-linux/lib/libnvrtc.so.13 \
          /usr/local/cuda/targets/x86_64-linux/lib/libnvrtc.so

# register the lib path with ldconfig
RUN echo "/usr/local/cuda/targets/x86_64-linux/lib" > /etc/ld.so.conf.d/cuda.conf \
    && ldconfig
