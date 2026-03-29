FROM docker.io/nvidia/cuda:13.2.0-cudnn-runtime-ubuntu24.04

RUN apt-get update && apt-get install -y \
    hashcat \
    cuda-nvrtc-13-2 \
    cuda-cudart-13-2 \
    && rm -rf /var/lib/apt/lists/*

# symlink cuda-13.2 to cuda
RUN ln -s /usr/local/cuda-13.2 /usr/local/cuda

# create missing unversioned symlink
RUN ln -s /usr/local/cuda/targets/x86_64-linux/lib/libnvrtc.so.13 \
          /usr/local/cuda/targets/x86_64-linux/lib/libnvrtc.so

# register the lib path with ldconfig
RUN echo "/usr/local/cuda/targets/x86_64-linux/lib" > /etc/ld.so.conf.d/cuda.conf \
    && ldconfig
