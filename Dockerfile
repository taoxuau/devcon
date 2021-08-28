FROM ubuntu:20.04

# install essential packages
RUN set -ex \
  && yes | unminimize \
  && apt-get update \
  && apt-get upgrade --yes \
  && apt-get install --yes man sudo curl locales htop procps lsb-release vim nano git openssh-client dumb-init build-essential zsh \
  && apt-get clean

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8

# non-root user with sudo privileges
ARG USER=devops
RUN adduser --gecos '' --disabled-password --shell /usr/bin/zsh $USER \
  && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
USER $USER
ENV TERM=xterm-256color USER=$USER SHELL=/usr/bin/zsh
WORKDIR /home/$USER

# setup basic environment
ARG P10KZSH=https://raw.githubusercontent.com/taoxuau/devcon/master/default-confs/p10k.zsh
RUN set -ex && mkdir -p ~/.ssh \
  # oh-my-zsh
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  # powerlevel10k
  && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/powerlevel10k.sh)" \
  # oh-my-zsh plugins
  && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/ohmyzsh-plugins.sh)"

# rbenv and ruby
ARG RUBY=2.7.4
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/ruby.sh)"

# keep container running - https://stackoverflow.com/a/42873832/629950
CMD ["tail", "-f", "/dev/null"]

# https://github.com/Yelp/dumb-init
ENTRYPOINT ["dumb-init", "--"]
