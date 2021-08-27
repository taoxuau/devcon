FROM ubuntu:20.04

# install essential packages
RUN set -ex \
  && yes | unminimize \
  && apt-get update \
  && apt-get upgrade --yes \
  && apt-get install --yes man sudo curl locales htop procps lsb-release vim nano git openssh-client dumb-init build-essential zsh \
  # ruby-build
  && apt-get install --yes autoconf bison libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
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

# setup development environment
ARG RUBY=2.7.4
RUN set -ex \
  # oh-my-zsh
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  # powerlevel10k
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
  && sed -i -e 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc \
  && curl -o ~/.p10k.zsh https://raw.githubusercontent.com/taoxuau/devcon/master/p10k.zsh \
  && P10KHEADER=$(curl   https://raw.githubusercontent.com/taoxuau/devcon/master/p10k.header.zshrc) \
  && P10KFOOTER=$(curl   https://raw.githubusercontent.com/taoxuau/devcon/master/p10k.footer.zshrc) \
  && echo "$P10KHEADER\n" | cat - ~/.zshrc > /tmp/myzshrc && mv /tmp/myzshrc ~/.zshrc \
  && echo "\n$P10KFOOTER" >> ~/.zshrc \
  && ~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install -f \
  # zsh-autosuggestions
  && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
  # zsh-syntax-highlighting
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
  # update plugins
  && sed -i -e 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc \
  # rbenv
  && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
  && echo "\n# rbenv"  >> ~/.zshrc \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc \
  && echo 'eval "$(rbenv init -)"'  >> ~/.zshrc \
  && mkdir -p ~/.rbenv/plugins \
  && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && ~/.rbenv/bin/rbenv install $RUBY \
  && ~/.rbenv/bin/rbenv local $RUBY

# keep container running - https://stackoverflow.com/a/42873832/629950
CMD ["tail", "-f", "/dev/null"]

# https://github.com/Yelp/dumb-init
ENTRYPOINT ["dumb-init", "--"]
