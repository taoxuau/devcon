#!/usr/bin/env bash
#
# install rbenv and ruby
#  - install rbenv
#  - install ruby
#
RBENV_ZSHRC=$(cat <<'EOF'
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOF
)

if [[ -n ${RUBY} ]]; then
  # install rbenv
  set -ex \
    && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && echo $'\n'"$RBENV_ZSHRC" >> ~/.zshrc

  # initialize rbenv
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  # ruby-build
  # dependencies - https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  set -ex \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes autoconf bison build-essential libssl-dev \
      libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
    && sudo apt-get clean

  # ruby-build
  # as an rbenv plugin - https://github.com/rbenv/ruby-build
  set -ex \
    && mkdir -p ~/.rbenv/plugins \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

  # available versions
  mapfile -t RUBY_VERSIONS < <(rbenv install --list-all)

  # install multiple ruby, e.g. RUBY="2.7.4, 3.0.2"
  IFS=, read -ra TO_INSTALL <<<${RUBY}
  for SINGLE_RUBY in ${TO_INSTALL[@]}
  do
    if [[ ${RUBY_VERSIONS[*]} =~ ${SINGLE_RUBY} ]]; then
      set -ex && rbenv install ${SINGLE_RUBY}
    fi
  done

  # configure rbenv - use the first version found
  INSTALLED_VERSIONS=($(rbenv versions))
  if [[ -n ${INSTALLED_VERSIONS[0]} ]]; then
    set -ex \
      && rbenv local ${INSTALLED_VERSIONS[0]} \
      && rbenv versions
  fi
fi
