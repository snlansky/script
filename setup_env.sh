#!/bin/bash

set -e
set -x

echo -e "Backuping existing apt configuration"
timestr=$(date +%Y%m%d%H%M)
tar -zcPf /etc/apt.$timestr.tar.gz /etc/apt

#aptKeys=(
#  https://download.docker.com/linux/ubuntu/gpg # docker-ce
#)
#for k in ${aptKeys[@]}; do echo "Adding apt key: ${k}"; curl -fsSL $k | sudo apt-key add -; done

aptRepositories=(
  ppa:jonathonf/vim # vim
  ppa:git-core/ppa # git
  ppa:ansible/ansible # ansible
  ppa:webupd8team/java # javaF
  ppa:kelleyk/emacs # emacs
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" # docker-ce
)
for ((i = 0; i < ${#aptRepositories[@]}; i++));
do
    echo "Adding apt repository: ${aptRepositories[$i]}"
    add-apt-repository -y -n "${aptRepositories[$i]}"
done


apt update
apt install -y build-essential libncurses-dev git make curl unzip gcc g++ libtool telnet wget tar unzip rar unrar ack-grep tmux zsh \
                binutils bison apt-transport-https ca-certificates software-properties-common gdebi net-tools \
                sysstat nmon htop atop iotop iftop nethogs ethtool nicstat dstat vnstat pstack strace colordiff \
                tmux zsh autojump ack-grep vim vim-gtk exuberant-ctags tree i3 suckless-tools flameshot ansible fcitx \
                mycli mongodb-clients mongo-tools redis-tools python-software-properties virtualbox emacs26 vlc \
                docker.io


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
  if [ ! -f $filename ]; then
    echo -e "\nInstalling $i"
    curl -L -o$filename $i
    gdebi -n $filename
  fi
done

# Install docker
# ----------------------------------------------------------------
usermod -aG docker $(whoami)
# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version


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


# Install npm
# ----------------------------------------------------------------
apt install npm
npm install -g http-server cleaver


# Install java
# ----------------------------------------------------------------
# must init ppa:webupd8team/java repositore
apt install oracle-java8-installer
java -version
apt install maven


# Install rust
# ----------------------------------------------------------------
curl https://sh.rustup.rs -sSf | bash


# https://github.com/robbyrussell/oh-my-zsh
# ----------------------------------------------------------------
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  echo -e "\nInstalling oh-my-zsh..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  chsh -s /bin/zsh
fi


# https://github.com/junegunn/fzf
# ----------------------------------------------------------------
if [[ ! -d $HOME/.fzf ]]; then
  echo -e "\nInstalling fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
fi


# Remove automatically all unused packages
apt autoremove -y
