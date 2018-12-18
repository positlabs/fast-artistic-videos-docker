# https://github.com/manuelruder/fast-artistic-videos

# https://github.com/lmb-freiburg/flownet2
FROM positlabs/flownet2

# use bash
SHELL ["/bin/bash", "-c"]

# define volume for i/o
VOLUME ["/io"]

# install torch, locked at commit hash
RUN apt-get update; apt-get install -y \
    unzip \
    git-core \
    cmake \
    curl \
    sudo \
    libreadline-dev \
    libwebkitgtk-3.0-0 wget

RUN git clone https://github.com/torch/distro.git /torch --recursive; \
    cd /torch && git checkout 0219027e6c4644a0ba5c5bf137c989a0a8c9e01b \
    ./install-deps; \
    ./install.sh; \
    source ~/.bashrc;

# install lua modules
RUN /torch/install/bin/luarocks install zlib; \
    /torch/install/bin/luarocks install torch; \
    /torch/install/bin/luarocks install nn; \
    /torch/install/bin/luarocks install image; \
    /torch/install/bin/luarocks install lua-cjson;

# install CUDA v7
RUN curl http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb -o cuda-repo-ubuntu1404_7.5-18_amd64.deb; \
    sudo dpkg -i --force-all cuda-repo-ubuntu1404_7.5-18_amd64.deb; \
    sudo apt-get update; \
    sudo apt-get install -y cuda-7.5;

# install CUDA lua modules
RUN /torch/install/bin/luarocks install findCUDA; \
    /torch/install/bin/luarocks install cutorch; \
    /torch/install/bin/luarocks install cunn;

# install ffmpeg (required by FAV)
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:mc3man/trusty-media && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y ffmpeg

# install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -; \
    apt-get install -y nodejs;

# clone fast-artistic-videos
RUN mkdir /fast-artistic-videos && \
    git clone -b dev https://github.com/positlabs/fast-artistic-videos.git /fast-artistic-videos

# grab paths from build args
ARG FAV_MODELS_ROOT
ENV FAV_MODELS_ROOT=${FAV_MODELS_ROOT}

# download pretrained models
RUN chmod +x /fast-artistic-videos/models/download_models.sh; \
    cd /fast-artistic-videos; \
    /fast-artistic-videos/models/download_models.sh ${FAV_MODELS_ROOT}

# install stnbhwd (GPU accelerated warping)
RUN cd /fast-artistic-videos/stnbdhw/; \
    /torch/install/bin/luarocks make stnbdhw-scm-1.rockspec;

# use cuDNN to accelerate convolutions and reduce memory footprint.
RUN  /torch/install/bin/luarocks install cudnn;

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
    python get-pip.py && \
    pip install --upgrade protobuf --ignore-installed six && \
    rm get-pip.py

# for some reason, torch needs to update even though we just installed it
# this fixes borked outputs, as described in https://github.com/manuelruder/fast-artistic-videos/issues/7
RUN cd /torch && ./update.sh;

# add caffe to pythonpath
ENV PYTHONPATH=/flownet2/flownet2/python/
RUN chmod +x /fast-artistic-videos/stylizeVideo_flownet.sh

# set up cli stuff
WORKDIR /app
COPY ./ /app

# flownet runner modified to recycle the caffe net. WAY faster.
COPY run-flownet-many.py /flownet2/flownet2/scripts/run-flownet-many.py

# gsutil for dev stuff
# RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
#     echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     apt-get update -y && apt-get install google-cloud-sdk -y

CMD [ "/app/fav" ]
# CMD tail -f /dev/null
