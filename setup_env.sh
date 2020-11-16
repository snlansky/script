#!/bin/bash

sudo apt install curl git

echo -e "Backuping existing apt configuration"
timestr=$(date +%Y%m%d%H%M)
sudo tar -zcPf /etc/apt.$timestr.tar.gz /etc/apt

# aptKeys=(
#   https://download.docker.com/linux/ubuntu/gpg # docker-ce
# )
# for k in ${aptKeys[@]}; do echo "Adding apt key: ${k}"; curl -fsSL $k | sudo apt-key add -; done

aptRepositories=(
  ppa:jonathonf/vim # vim
  ppa:git-core/ppa # git
  ppa:kelleyk/emacs # emacs
)
for ((i = 0; i < ${#aptRepositories[@]}; i++));
do
  echo "Adding apt repository: ${aptRepositories[$i]}"
  sudo add-apt-repository -y -n "${aptRepositories[$i]}"
done

sudo apt update
sudo apt install -y lsb-release lsb-core net-tools telnet wget git-extras make gcc g++ cmake clang libtool pkg-config unzip rar unrar \
                    mercurial binutils build-essential bison apt-transport-https ca-certificates software-properties-common gdebi \
                    sysstat nmon htop atop iotop iftop nethogs ethtool nicstat dstat vnstat pstack strace colordiff openssh-server \
                    tmux zsh autojump ack-grep silversearcher-ag vim vim-gtk neovim exuberant-ctags suckless-tools \
                    flameshot tree vlc i3 fcitx jq emacs26 exfat-utils libzmq3-dev libssl-dev protobuf-compiler libreadline-dev \
                    fonts-powerline fonts-firacode cloc


# ----------------------------------------------------------------
# start ssh service
sudo /etc/init.d/ssh start


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
  curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sh install.sh
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
# install fasd jump
git clone https://github.com/clvv/fasd.git
cd fasd
sudo make install
# ----------------------------------------------------------------
# install by pip
# console file manager with VI key bindings
# https://github.com/ranger/range
# pip install ranger-fm

# https://github.com/starship/starship
# curl -fsSL https://starship.rs/install.sh | bash


# ----------------------------------------------------------------
# Remove automatically all unused packages
sudo apt autoremove -y

echo "place reboot computer"
