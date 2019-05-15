#!/bin/bash

sudo apt install curl

echo -e "Backuping existing apt configuration"
timestr=$(date +%Y%m%d%H%M)
sudo tar -zcPf /etc/apt.$timestr.tar.gz /etc/apt

aptKeys=(
  https://download.docker.com/linux/ubuntu/gpg # docker-ce
)
for k in ${aptKeys[@]}; do echo "Adding apt key: ${k}"; curl -fsSL $k | sudo apt-key add -; done

aptRepositories=(
  ppa:jonathonf/vim # vim
  ppa:git-core/ppa # git
  ppa:kelleyk/emacs # emacs
  # ppa:ansible/ansible # ansible
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" # docker-ce
)
for ((i = 0; i < ${#aptRepositories[@]}; i++));
do
  echo "Adding apt repository: ${aptRepositories[$i]}"
  sudo add-apt-repository -y -n "${aptRepositories[$i]}"
done

sudo apt update
sudo apt install -y lsb-release lsb-core net-tools telnet wget curl git git-extras make gcc g++ cmake libtool pkg-config unzip rar unrar \
                    mercurial binutils build-essential bison apt-transport-https ca-certificates software-properties-common gdebi \
                    sysstat nmon htop atop iotop iftop nethogs ethtool nicstat dstat vnstat pstack strace colordiff \
                    python-pip python3-pip tmux zsh autojump ack-grep silversearcher-ag vim vim-gtk exuberant-ctags suckless-tools flameshot \
                    mycli mongodb-clients mongo-tools redis-tools usb-creator-gtk telegram-desktop transmission \
                    docker-ce vlc virtualbox i3 ansible fcitx jq emacs26 kazam


# ----------------------------------------------------------------
# install debian packages
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
    sudo curl -L -o$filename $i
    sudo gdebi -n $filename
  fi
done

# ----------------------------------------------------------------
# install tmux
if [[ `tmux -V` != "tmux 2.8" ]]; then
  curl -L https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8.tar.gz -o tmux-2.8.tar.gz
  tar -zxvf tmux-2.8.tar.gz
  cd tmux-2.8
  sudo apt install libevent-dev ncurses-dev
  sudo ./configure
  sudo make
  sudo make install
  cd .. && sudo rm -rf tmux-2.8 tmux-2.8.tar.gz
fi


# ----------------------------------------------------------------
# https://github.com/robbyrussell/oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  echo -e "\nInstalling oh-my-zsh..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  chsh -s /bin/zsh
fi

# ----------------------------------------------------------------
# https://github.com/junegunn/fzf
if [ ! -d $HOME/.fzf ]; then
  echo -e "\nInstalling fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install
fi

# ----------------------------------------------------------------
# https://github.com/creationix/nvm
if [ ! -d $HOME/.nvm ]; then
  echo -e "\nInstalling nvm..."
  curl -L https://github.com/creationix/nvm/raw/v0.33.11/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  nvm install 8
  nvm use 8
  nvm alias default 8

  npm install -g http-server cleaver
fi


# ----------------------------------------------------------------
# Add user account to the docker group
sudo usermod -aG docker $(whoami)

# https://github.com/docker/compose
(command -v docker-compose >/dev/null 2>&1) || {
  echo -e "\nInstalling docker-compose..."
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

# ----------------------------------------------------------------
# Remove automatically all unused packages
sudo apt autoremove -y
