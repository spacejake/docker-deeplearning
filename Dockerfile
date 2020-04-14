FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
#FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04 

# Install System Deps
RUN apt-get update

# Setup TZData
ADD setup-tzdata.sh /setup-tzdata.sh
RUN /setup-tzdata.sh

RUN apt-get install -y --no-install-recommends \
        automake \
        build-essential \
        crossbuild-essential-arm64 gcc-aarch64-linux-gnu g++-aarch64-linux-gnu\
        ca-certificates \
        curl \
        checkinstall \
        git \
        vim \
        libglfw3-dev freeglut3 freeglut3-dev \
        libegl1-mesa-dev libgles2-mesa-dev \
        libcurl3-dev \
        libfreetype6-dev \
        libpng-dev \
        libtool \
        libzmq3-dev \
        libpng-dev \
        libboost-all-dev \
        mlocate \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        pkg-config \
        software-properties-common \
        swig \
        unzip \
        wget \
        zip \
        zlib1g-dev \
        ca-certificates \
        python-qt4 \
        libjpeg-dev \
        openssl \
        x11-apps vim-gtk3\
        libx11-dev libxext-dev libdrm-dev x11proto-dri2-dev libxfixes-dev \        
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Python 3
RUN curl -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     bash ~/miniconda.sh -b -p /opt/conda && \     
     rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda --version

# Python Deps
RUN conda config --set always_yes yes --set changeps1 no 
RUN conda update -q conda 
RUN conda install progress protobuf=3.8.0 tqdm h5py pandas Cython contextlib2 pillow lxml matplotlib scikit-learn
RUN conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
RUN conda install -c conda-forge coloredlogs notebook

RUN pip --no-cache-dir install \
    future>=0.17.1 \
    grpcio \
    keras_applications>=1.0.8 \
    keras_preprocessing>=1.1.0 \
    mock \
    tqdm \
    numpy \
    requests \
    opencv-python \
    scipy>=0.17.0 \
    scikit-image \
    six \
    wheel \
    setuptools \
    pyrender \
    tensorflow==2.0.0 \
    tensorboard==2.0.0 \
    pyyaml \
    labelImg \
    pycocotools

# Setup Work dirs
RUN mkdir /workspace
WORKDIR /workspace
RUN chmod -R a+w /workspace

# Set up Bazel
# TFv1.15.0 & 2.0
ENV BAZEL_VERSION 0.26.1
#TFv1.14.0
#ENV BAZEL_VERSION 0.24.1 
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

RUN apt-get update

