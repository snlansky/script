#!/bin/sh

NAME="$1"

if [[ ! -n "$NAME" ]] ;then
    NAME=${USER}
fi

groupadd docker

gpasswd -a $NAME docker

service docker restart

newgrp - docker
usermod -a -G docker $NAME
