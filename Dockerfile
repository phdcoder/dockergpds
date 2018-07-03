FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
# ensure system is updated and has basic build tools
RUN apt-get -f -y upgrade
RUN apt-get clean
RUN apt-get update --fix-missing
RUN apt-get -f -y install \
    tmux \
    build-essential \
    gcc g++ make \
    binutils \
    curl \
    git \
	ffmpeg \
	openexr \
	libgtk2.0-0 \
    software-properties-common file locales uuid-runtime \
    wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    mercurial subversion
# Downgrade to cudnn 7.0, since it conflicts with Tensorflow 1.7 and 1.8
RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    libcudnn7=7.0.4.31-1+cuda9.0 \
    libcudnn7-dev=7.0.4.31-1+cuda9.0

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh	-O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh
	
ENV PATH /opt/conda/bin:$PATH

RUN conda install \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        scikit-learn \
        scikit-image \
        pandas \
        seaborn \
        Pillow \
        tqdm

# install tensorflow & keras
RUN pip --no-cache-dir install --upgrade \
        Keras \
        https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.7.0-cp36-cp36m-linux_x86_64.whl \
        https://bazel.blob.core.windows.net/opencv/opencv_python-3.4.0%2B2329983-cp36-cp36m-linux_x86_64.whl

