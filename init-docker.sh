#!/bin/sh

set -x

sudo apt install curl git

curl https://releases.rancher.com/install-docker/19.03.sh | sh


echo "install docker success!"

# install docker-compose
sudo apt install docker-compose

# install k8s
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version

# sudo groupadd docker
# Add user account to the docker group
sudo gpasswd -a snlan docker
# sudo usermod -a -G docker snlan
sudo service docker restart
newgrp - docker
