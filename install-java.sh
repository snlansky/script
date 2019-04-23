#!/bin/bash

echo "Install java and maven"
add-apt-repository -y -n ppa:webupd8team/java
apt install oracle-java8-installer
java -version
apt install maven
