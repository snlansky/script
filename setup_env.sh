#!/bin/sh


set -e
set -x

# Update the entire system to the latest releases

aptRepositories=(
  ppa:jonathonf/vim # vim
  ppa:git-core/ppa # git
  ppa:ansible/ansible # ansible
  ppa:webupd8team/java # java
  ppa:kelleyk/emacs # emacs
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" # docker-ce
)

apt update
apt upgrade

for ((i = 0; i < ${#aptRepositories[@]}; i++));
do
    echo "Adding apt repository: ${aptRepositories[$i]}"
    add-apt-repository -y -n "${aptRepositories[$i]}"
done


# Install some basic utilities
apt install -y build-essential libncurses-dev git make curl unzip gcc g++ libtool telnet wget tar unzip rar unrar ack-grep tmux zsh \
                binutils build-essential bison apt-transport-https ca-certificates software-properties-common gdebi \
                sysstat nmon htop atop iotop iftop nethogs ethtool nicstat dstat vnstat pstack strace colordiff \
                tmux zsh autojump ack-grep vim vim-gtk exuberant-ctags i3 suckless-tools flameshot ansible fcitx \
                mycli mongodb-clients mongo-tools redis-tools python-software-properties virtualbox emacs26


# ----------------------------------------------------------------
# Install docker
# ----------------------------------------------------------------
apt install docker.io
usermod -aG docker $(whoami)
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
npm install -g http-server cleaver


# ----------------------------------------------------------------
# Install java
# ----------------------------------------------------------------
# must init ppa:webupd8team/java repositore
apt install oracle-java8-installer
java -version
apt install maven


# ----------------------------------------------------------------
# Install rust
# ----------------------------------------------------------------
curl https://sh.rustup.rs -sSf | sh


# ----------------------------------------------------------------
# install debian packages
# ----------------------------------------------------------------
aptCache=/var/cache/apt/archives
debPackages=(
  http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
)
for i in ${debPackages[@]};
do
  filename=$aptCache/$(basename $i)
  if [[ ! -f ${filename} ]]; then
    echo -e "\nInstalling $i"
    curl -L -o$filename $i
    gdebi -n $filename
  fi
done


# ----------------------------------------------------------------
# https://github.com/robbyrussell/oh-my-zsh
# ----------------------------------------------------------------
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  echo -e "\nInstalling oh-my-zsh..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  chsh -s /bin/zsh
fi


# ----------------------------------------------------------------
# https://github.com/junegunn/fzf
# ----------------------------------------------------------------
if [[ ! -d $HOME/.fzf ]]; then
  echo -e "\nInstalling fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
fi


# Remove automatically all unused packages
apt autoremove -y
