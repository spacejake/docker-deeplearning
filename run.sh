#!/bin/bash

declare src=$1
declare data=$2

echo "Data Path: $data_path"

xhost +local:root; \
    docker run --runtime=nvidia -it --shm-size=16G \
    -e DISPLAY=$DISPLAY \
    -e "QT_X11_NO_MITSHM=1" \
    -e CUDACXX=/usr/local/cuda/bin/nvcc \
    --privileged \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $src:/workspace/src:rw \
    -v $data:/workspace/data:rw \
    tfv1-15-cuda10-0-py3-ubuntu18

#xhost +local:root; \
#    docker run --runtime=nvidia -it --shm-size=16G \
#    -p 5000:8888 -p 5001:6006 \
#    -e DISPLAY=$DISPLAY \
#    -e "QT_X11_NO_MITSHM=1" \
#    -e CUDACXX=/usr/local/cuda/bin/nvcc \
#    --privileged \
#    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#    -v $src:/workspace/src:rw \
#    -v $data:/workspace/data:rw \
#    tfv1-15-cuda10-0-py3-ubuntu18


