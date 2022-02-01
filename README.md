# pytti-docker

Port of PYTTI notebook geared towards local execution.

Contributions welcome.

## Requirements

* docker

## Setup

1. Clone and CD into this project
2. Build the container

      ``` $ docker build -t pytti:test . ```
    
      This automates installing packages for PYTTI and downloading pre-trained models.

4. Start the container

      ``` 
$ mkdir /opt/colab/images_out
$ docker run --rm -it \
      -p 8181:8181 \
      --gpus all\
       -v /opt/colab/images_out:/opt/colab/images_out \
       -v /opt/colab/videos:/opt/colab/videos
       pytti:test 
```
      
      You should now have a jupyter server running at http://localhost:8181/lab?token=UniqueNewYork . (You should change that token for security)

## Usage

You should now be able to run the pytti beta-p5 notebook. 

Additionally, the container contains a modified version of the notebook code which can be run as a script. This script is configured with OmegaConf/Hydra yaml files. To use this script:

1. Define a new experiment by adding a config file to the ./config/conf directory. You only need to specify anything you want changed from the defaults, which are specified in ./config/default.yaml . Let's say you named your experiment configuration: ./config/conf/demo.yaml

2. Open a terminal on the jupyter server
3. Run the script, passing the experiment defining config as an argument for hydra.

      ``` $ python pytti/workhorse.py conf=demo ```
    
  Because the config is managed by hydra, you can override experiment parameters by specifying them on the command line, e.g.

      ``` $ python pytti/workhorse.py conf=demo save_every=20 steps_per_scene=1000```
