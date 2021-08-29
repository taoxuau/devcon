#!/usr/bin/env bash
#
# install oh-my-zsh and plugins
#  - install oh-my-zsh
#  - install zsh-autosuggestions
#  - install zsh-syntax-highlighting
#
PLUGINS=(git zsh-autosuggestions zsh-syntax-highlighting)

set -ex \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  && sed -i -e "s/^plugins=.*/plugins=(${PLUGINS[*]})/g" ~/.zshrc
