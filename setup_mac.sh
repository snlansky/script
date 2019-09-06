#!/bin/bash

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install git
brew install tmux
brew install zsh fzf kubernetes-cli autojump cmake
brew install automake pkg-config pcre xz
brew install lrzsz

# ----------------------------------------------------------------
# https://github.com/robbyrussell/oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
  echo -e "\nInstalling oh-my-zsh..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  chsh -s /bin/zsh
fi
