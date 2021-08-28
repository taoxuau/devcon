#!/usr/bin/env bash
#
# install oh-my-zsh plugins
#  - install zsh-autosuggestions
#  - install zsh-syntax-highlighting
#
PLUGINS=(git zsh-autosuggestions zsh-syntax-highlighting)

set -ex \
  # zsh-autosuggestions
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  # zsh-syntax-highlighting
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  # update plugins list
  && sed -i -e "s/^plugins=.*/plugins=${PLUGINS}/g" ~/.zshrc
