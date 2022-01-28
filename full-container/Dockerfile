ARG OWNER=pyttitools
ARG BASE_CONTAINER=$OWNER/pytti-base:test
FROM $BASE_CONTAINER

RUN git clone https://github.com/openai/CLIP.git && \
    git clone https://github.com/CompVis/taming-transformers.git && \
    git clone https://github.com/shariqfarooq123/AdaBins.git && \
    git clone https://github.com/zacjiang/GMA.git

RUN git clone --branch p5-cli https://github.com/pytti-tools/pytti-core.git pytti && cd pytti && git checkout fc414318

# this works
RUN touch /opt/colab/GMA/core/__init__.py

COPY download_models.sh .
RUN mkdir ./models
RUN mkdir -p AdaBins/pretrained
#RUN ./download_models.sh && \
#    cp models/AdaBins_nyu.pt AdaBins/pretrained/ 


COPY models/AdaBins_nyu.pt AdaBins/pretrained/   

ENV PYTHONPATH=/opt/colab/GMA/core:./:./pytti:/opt/colab

#############


#RUN ${PIP} install clearml
#COPY ./pytti_cli_w_clearml.py .
#COPY clearml.conf /root/clearml.conf
#RUN touch /root/clearml.conf
#COPY ./config /opt/colab/config


CMD jupyter notebook --port $COLAB_PORT --NotebookApp.port_retries=0 --ip 0.0.0.0 --no-browser --NotebookApp.token=UniqueNewYork --allow-root
