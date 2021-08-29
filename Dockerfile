FROM ubuntu:20.04

# install essential packages
RUN set -ex \
  && yes | unminimize \
  && apt-get update \
  && apt-get upgrade --yes \
  && apt-get install --yes man sudo curl locales htop procps lsb-release vim nano git openssh-client dumb-init build-essential zsh \
  # https://serverfault.com/a/992421/542554
  && DEBIAN_FRONTEND=noninteractive apt-get install --yes tzdata \
  && apt-get clean \
  # https://wiki.debian.org/Locale#Manually
  && sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen

# non-root user with sudo privileges
ARG USER=devops
RUN adduser --gecos '' --disabled-password --shell /usr/bin/zsh $USER \
  && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
USER $USER
ENV LANG=en_US.UTF-8 TERM=xterm-256color USER=$USER SHELL=/usr/bin/zsh
WORKDIR /home/$USER
RUN set -ex && mkdir -p ~/.ssh

# oh-my-zsh and plugins, powerlevel10k
ARG P10KZSH=https://raw.githubusercontent.com/taoxuau/devcon/master/default-confs/p10k.zsh
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/ohmyzsh.sh)"

# rbenv and ruby
ARG RUBY
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/ruby.sh)"

# pyenv and python
ARG PYTHON
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/python.sh)"

# keep container running - https://stackoverflow.com/a/42873832/629950
CMD ["tail", "-f", "/dev/null"]

# https://github.com/Yelp/dumb-init
ENTRYPOINT ["dumb-init", "--"]
