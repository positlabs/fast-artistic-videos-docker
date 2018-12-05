## Note: Our Caffe version does not work with CuDNN 6
# FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
FROM nvidia/cuda:7.5-cudnn5-devel-ubuntu14.04

## Put everything in some subfolder
WORKDIR "/flownet2"

## The build context contains some files which make the raw FlowNet2
## repo fit for Docker
COPY FN2_Makefile.config ./
COPY FN2_run-flownet-docker.py ./

## Container's mount point for the host's input/output folder
VOLUME "/input-output"

## 1. Install packages
## 2. Download and install CUDA driver
## 3. Download and build DispNet/FlowNet Caffe distro
## 4. Remove some now unused packages and clean up (for a smaller image)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    module-init-tools \
    build-essential \
    ca-certificates \
    wget \
    curl \
    git \
    libatlas-base-dev \
    libboost-all-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libhdf5-serial-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libprotobuf-dev \
    libsnappy-dev \
    protobuf-compiler \
    python-dev \
    python-numpy \
    python-scipy \
    python-protobuf \
    python-pillow \
    python-skimage

RUN git clone https://github.com/lmb-freiburg/flownet2 && \
    cp ./FN2_Makefile.config ./flownet2/Makefile.config && \
    cp ./FN2_run-flownet-docker.py ./flownet2/scripts/run-flownet-docker.py && \
    cd flownet2 && \
    rm -rf .git

ARG FLOWNET2_MODELS
ENV FLOWNET2_MODELS=${FLOWNET2_MODELS}
ARG FLOWNET2_MODELS_KITTI
ENV FLOWNET2_MODELS_KITTI=${FLOWNET2_MODELS_KITTI}
ARG FLOWNET2_MODELS_SINTEL
ENV FLOWNET2_MODELS_SINTEL=${FLOWNET2_MODELS_SINTEL}

RUN echo ${FLOWNET2_MODELS}
RUN echo ${FLOWNET2_MODELS_KITTI}
RUN echo ${FLOWNET2_MODELS_SINTEL}

# TODO set paths in .env
# self hosted models drastically speed up download time
RUN cd /flownet2/flownet2/models && \
    curl ${FLOWNET2_MODELS} -o ./flownet2-models-kitti.tar.gz && \
    curl ${FLOWNET2_MODELS_KITTI} -o ./flownet2-models-sintel.tar.gz && \
    curl ${FLOWNET2_MODELS_SINTEL} -o ./flownet2-models.tar.gz && \
    tar xvzf ./flownet2-models-kitti.tar.gz && \
    tar xvzf ./flownet2-models-sintel.tar.gz && \
    tar xvzf ./flownet2-models.tar.gz

# slow download
# RUN cd /flownet2/flownet2/models && \
#     bash download-models.sh && \
#     rm flownet2-models.tar.gz

RUN cd /flownet2/flownet2 && \
    make -j`nproc` && \
    make -j`nproc` pycaffe

RUN apt-get remove -y \
        module-init-tools \
        build-essential \
        ca-certificates \
        git \
        curl \
        wget && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*
