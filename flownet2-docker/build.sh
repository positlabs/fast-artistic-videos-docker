#! /bin/bash
docker build -f Dockerfile \
    --build-arg FLOWNET2_MODELS=`../dev/env FLOWNET2_MODELS` \
    --build-arg FLOWNET2_MODELS_KITTI=`../dev/env FLOWNET2_MODELS_KITTI` \
    --build-arg FLOWNET2_MODELS_SINTEL=`../dev/env FLOWNET2_MODELS_SINTEL` \
    -t positlabs/flownet2 .
