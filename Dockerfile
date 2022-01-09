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

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python


RUN mkdir -p /opt/colab

WORKDIR /opt/colab

COPY pytti_5_beta.ipynb .

#RUN pip install -r requirements.txt \
RUN pip install jupyterlab==3.2.5 ipywidgets \
    && jupyter nbextension enable --py widgetsnbextension
    
# https://pytorch.org/get-started/locally/
RUN pip3 install \ 
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
RUN pip install \
   gdown \
   tensorflow \
   transformers \
   PyGLM \
   ftfy \
   regex \
   tqdm \
   omegaconf \ 
   pytorch-lightning \
   kornia \
   einops \
   imageio-ffmpeg \
   adjustText \ 
   exrex \ 
   bunch \
   matplotlib-label-lines \
   pandas \
   imageio \
   seaborn \
   sklearn

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
RUN apt-get install -y python3-opencv

#RUN echo $PATH
#ENV PATH="${PATH}:./GMA/core"
#ENV PATH="$PATH:./GMA/core"
ENV PYTHONPATH=./GMA/core
#RUN echo $PATH

# this works
RUN touch ./GMA/core/__init__.py

#############

RUN pip install clearml
COPY pytti_cli_w_clearml.py .
#COPY clearml.conf /home/clearml.conf
COPY clearml.conf /root/clearml.conf
COPY default_params.json .

#CMD jupyter notebook --NotebookApp.allow_origin='https://colab.research.google.com' --allow-root --port $COLAB_PORT --NotebookApp.port_retries=0 --ip 0.0.0.0
CMD jupyter notebook --port $COLAB_PORT --NotebookApp.port_retries=0 --ip 0.0.0.0 --no-browser --NotebookApp.token=UniqueNewYork --allow-root