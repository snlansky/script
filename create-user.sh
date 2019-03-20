#!/bin/sh

name=$1
pass=$2

echo "you are setting username : ${name}"
echo "you are setting password : $pass for ${name}"

useradd -m -s /bin/bash ${name}

echo ${name}:${pass} | chpasswd

usermod -a -G sudo ${name}

usermod -a -G docker ${name}