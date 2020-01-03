#!/bin/bash

GO_VER=1.13.5
# GO_URL=https://storage.googleapis.com/golang/go${GO_VER}.linux-amd64.tar.gz
GO_URL=https://dl.google.com/go/go${GO_VER}.linux-amd64.tar.gz

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go"

cat <<EOF >/etc/profile.d/goroot.sh
export GO111MODULE=on
export GOPROXY=https://goproxy.io
export GOROOT=$GOROOT
export GOPATH=$GOPATH
export PATH=\$PATH:$GOROOT/bin:$GOPATH/bin
EOF

source /etc/profile.d/goroot.sh

rm -rf $GOROOT
mkdir -p $GOROOT
mkdir -p $GOPATH
curl -sL $GO_URL | (cd $GOROOT && tar --strip-components 1 -xz)