#ARG CUDA_VERSION=10.2
#ARG CUDA_VERSION=11.1
ARG CUDA_VERSION=11.3

#FROM nvidia/cuda:${CUDA_VERSION}-base-ubuntu18.04
#FROM nvidia/cuda:${CUDA_VERSION}-base-ubuntu20.04
FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04

# install Python
ARG _PY_SUFFIX=3
#ARG _PY_SUFFIX=3.9
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# See http://bugs.python.org/issue19846
#ENV LANG C.UTF-8

# https://askubuntu.com/questions/1318846/how-do-i-install-python-3-9
#RUN apt-get update && \
#    apt-get install -y software-properties-common && \
#    add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip


RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools
    
#RUN ${PIP} --no-cache-dir install --upgrade pip
#RUN ${PIP} install setuptools==1.1.5

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python


RUN mkdir -p /opt/colab

WORKDIR /opt/colab

COPY pytti_5_beta.ipynb .

#RUN pip install -r requirements.txt \
RUN ${PIP} install jupyterlab==3.2.5 ipywidgets \
    && jupyter nbextension enable --py widgetsnbextension
    
# https://pytorch.org/get-started/locally/
RUN ${PIP} install \ 
      torch==1.10.1+cu113 \
      torchvision==0.11.2+cu113 \
      torchaudio==0.10.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

ARG COLAB_PORT=8181
EXPOSE ${COLAB_PORT}
ENV COLAB_PORT ${COLAB_PORT}

#############
# pytti requirements

# `install_everything()`
# tensorflow#==1.15.2 \
RUN ${PIP} install \
   tensorflow==2.7.0 \
   transformers==4.15.0

RUN ${PIP} install \
   gdown===4.2.0 \
   PyGLM==2.5.7 \
   ftfy==6.0.3 \
   regex \
   tqdm==4.62.3 \
   omegaconf==2.1.1 \ 
   pytorch-lightning==1.5.7 \
   kornia==0.6.2 \
   einops==0.3.2 \
   imageio-ffmpeg==0.4.5 \
   adjustText \ 
   exrex \ 
   bunch==1.0.1 \
   matplotlib-label-lines==0.4.3 \
   pandas==1.3.4 \
   imageio==2.13.5 \
   seaborn==0.11.2 \
   scikit-learn
   #sklearn
   #regex==2.5.109 \

RUN apt-get install -y git

RUN git clone https://github.com/openai/CLIP.git && \
    git clone https://github.com/CompVis/taming-transformers.git && \
    git clone --branch p5 https://github.com/sportsracer48/pytti.git && \
    git clone https://github.com/shariqfarooq123/AdaBins.git && \
    git clone https://github.com/zacjiang/GMA.git
    #git clone --branch p5.1 https://github.com/dmarx/pytti.git
    
RUN mkdir -p AdaBins/pretrained 
COPY models/AdaBins_nyu.pt AdaBins/pretrained/   

# suppress interactive tzdata configuration
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

# install cv2
# experiencing issues all of a sudden. Hopefully --fix-missing resolves it?
RUN apt-get update --fix-missing
RUN apt-get install -y python3-opencv

#ENV PYTHONPATH=./GMA/core
#ENV PYTHONPATH=./GMA/core:.
#ENV PYTHONPATH=./GMA/core:./:./pytti:/opt/colab
ENV PYTHONPATH=/opt/colab/GMA/core:./:./pytti:/opt/colab


# this works
#RUN touch ./GMA/core/__init__.py
RUN touch /opt/colab/GMA/core/__init__.py

#############

RUN ${PIP} install clearml==1.1.5
COPY pytti_cli_w_clearml.py .
#COPY clearml.conf /home/clearml.conf
COPY clearml.conf /root/clearml.conf
#COPY default_params.json .
COPY ./config /opt/colab/config

#RUN mkdir -p /opt/colab
#WORKDIR /opt/colab
#RUN mkdir -p /opt/colab/projdata
RUN mkdir -p /opt/colab/images_out

# TO DO: pre-download VQGAN models
RUN apt-get install -y curl

# for video in/out
RUN apt-get install -y ffmpeg

#CMD jupyter notebook --NotebookApp.allow_origin='https://colab.research.google.com' --allow-root --port $COLAB_PORT --NotebookApp.port_retries=0 --ip 0.0.0.0
CMD jupyter notebook --port $COLAB_PORT --NotebookApp.port_retries=0 --ip 0.0.0.0 --no-browser --NotebookApp.token=UniqueNewYork --allow-root