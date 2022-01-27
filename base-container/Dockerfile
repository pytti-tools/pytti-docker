
#ARG CUDA_VERSION=11.3

FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04

# install Python
ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools
    
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

##########

RUN apt-get install -y \
    git \
    curl

RUN mkdir -p /opt/colab/images_out
WORKDIR /opt/colab

#COPY pytti_5_beta.ipynb .
RUN git clone https://github.com/pytti-tools/pytti-notebook.git
RUN cp pytti-notebook/pytti_5_beta.ipynb .

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
   scikit-learn \
   loguru \
   hydra-core \
   setuptools==59.5.0

# suppress interactive tzdata configuration
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

# install cv2
# experiencing issues all of a sudden. Hopefully --fix-missing resolves it?
RUN apt-get update --fix-missing
RUN apt-get install -y python3-opencv

# for video in/out
RUN apt-get install -y ffmpeg



