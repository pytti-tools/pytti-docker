# pytti-docker

Port of PYTTI notebook geared towards local execution. Integrated with ClearML for job logging, monitoring, and comparison. 

Contributions welcome.

# Requirements

* docker
* ClearML 
  - either a local instance (requires docker-compose) or create a free account on the hosted service
  - Will change this to not be a requirement soon.
  - Also planning to add support for WandB, etc. 

# Setup

1. Clone and CD into this project
2. Add your `clearml.conf` to the root directory
3. Build the container

    $ docker build -t pytti:test .
    
  This automates installing packages for PYTTI and downloading pre-trained models.

4. Start the container

    $ mkdir /opt/colab/images_out
    $ docker run --rm -it -p 8181:8181 --gpus all -v /opt/colab/images_out:/opt/colab/images_out pytti:test
    
  You should know have a jupyter server running at http://localhost:8181/lab?token=UniqueNewYork . (You should change that token for security)
