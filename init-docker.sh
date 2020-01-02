#!/bin/sh

curl https://releases.rancher.com/install-docker/18.09.sh | sh

sudo groupadd docker
# Add user account to the docker group
sudo gpasswd -a ${USER} docker

# service docker restart

newgrp - docker

usermod -a -G docker ${USER}


# https://github.com/docker/compose
(command -v docker-compose >/dev/null 2>&1) || {
  echo -e "\nInstalling docker-compose..."
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

