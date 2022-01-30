FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04

# CI/CD
ARG CI_BRANCH_NAME=p5-cli

# Python
ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# Jupyter
ARG COLAB_PORT=8181
EXPOSE ${COLAB_PORT}
ENV COLAB_PORT ${COLAB_PORT}

# Tensorboard
ARG TENSORBOARD_PORT=6006
EXPOSE ${TENSORBOARD_PORT}
ENV TENSORBOARD_PORT ${TENSORBOARD_PORT}

#################

#RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get update --fix-missing && apt-get -y dist-upgrade

#RUN apt-get install -y \
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
    apt-get install -y \
        ${PYTHON} \
        ${PYTHON}-pip \
        git \
        curl \
        tzdata \
        ffmpeg \
        python3-opencv

RUN ${PIP} --no-cache-dir install --upgrade \
    pip
    
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

RUN mkdir -p /opt/colab/images_out
RUN mkdir -p /opt/colab/videos
WORKDIR /opt/colab

RUN ${PIP} install --no-cache-dir jupyterlab==3.2.5 ipywidgets \
    && jupyter nbextension enable --py widgetsnbextension
    
RUN ${PIP} install --no-cache-dir --use-deprecated=html5lib \ 
      torch==1.10.2+cu113 \
      torchvision==0.11.3+cu113 \
      torchaudio==0.10.2+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

RUN git clone --branch ${CI_BRANCH_NAME} https://github.com/pytti-tools/pytti-core.git pytti && cd pytti && git checkout da342e7
RUN git clone --branch ${CI_BRANCH_NAME} https://github.com/pytti-tools/pytti-notebook.git && cd pytti-notebook && git checkout 09c1d32
RUN cp pytti-notebook/pytti_5_beta.ipynb .

RUN ${PIP} install --no-cache-dir -r pytti/requirements.txt
