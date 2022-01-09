
mkdir -p /opt/projdata

cd ~/proj/pytti-docker

./download_models.sh

sudo docker build -t pytti:test .
sudo docker run --rm -it -p 8181:8181 --gpus all -v /opt/projdata:/opt/colab/images_out pytti:test
sudo docker ps

