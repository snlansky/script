#!/bin/sh

sudo apt install curl git

curl https://releases.rancher.com/install-docker/18.09.sh | sh

sudo groupadd docker
# Add user account to the docker group
sudo gpasswd -a snlan docker

# service docker restart

newgrp - docker

sudo usermod -a -G docker snlan


# https://github.com/docker/compose
(command -v docker-compose >/dev/null 2>&1) || {
  echo -e "\nInstalling docker-compose..."
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

# install k8s
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
