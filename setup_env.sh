#!/bin/sh


set -e
set -x

# Update the entire system to the latest releases
apt-get update
#apt-get dist-upgrade -y

# Install some basic utilities
apt-get install -y build-essential git make curl unzip g++ libtool tar ack tmux

# ----------------------------------------------------------------
# Install docker
# ----------------------------------------------------------------
apt install docker.io
./init-docker-group.sh snlan
docker run --rm busybox echo All good
# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
# ----------------------------------------------------------------
# Install Golang
# ----------------------------------------------------------------
GO_VER=1.12.1
GO_URL=https://storage.googleapis.com/golang/go${GO_VER}.linux-amd64.tar.gz

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go"
PATH=$GOROOT/bin:$GOPATH/bin:$PATH

cat <<EOF >/etc/profile.d/goroot.sh
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=\$PATH:$GOROOT/bin:$GOPATH/bin
EOF

rm -rf $GOROOT
mkdir -p $GOROOT

curl -sL $GO_URL | (cd $GOROOT && tar --strip-components 1 -xz)

# ----------------------------------------------------------------
# Install npm
# ----------------------------------------------------------------
apt install npm

# ----------------------------------------------------------------
# Install java
# ----------------------------------------------------------------
apt install python-software-properties
add-apt-repository ppa:webupd8team/java
sudo apt-get install oracle-java8-installer
java -version
apt install maven

# ----------------------------------------------------------------
# Install rust
# ----------------------------------------------------------------
curl https://sh.rustup.rs -sSf | sh