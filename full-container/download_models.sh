#! /usr/bin/bash

# AdaBins/pretrained/AdaBins_nyu.pt - 941M
if [ -f models/AdaBins_nyu.pt ]
then
    echo "AdaBins model found"
else
    echo "AdaBins model not found. Downloading locally."
    gdown -O ./models/ https://drive.google.com/uc?id=1lvyZZbC9NLcS8a__YPcUP7rDiIpbRpoF
fi

# For CLIP models, see: CLIP/clip/clip.py