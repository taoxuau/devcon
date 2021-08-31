#!/usr/bin/env bash
#
# install nodenv and nodejs
#  - install nodenv
#  - install nodejs
#
NODENV_ZSHRC=$(cat <<'EOF'
# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
EOF
)

if [[ -n ${NODE} ]]; then
  # nodenv
  set -ex \
    && git clone https://github.com/nodenv/nodenv.git ~/.nodenv \
    && echo $'\n'"$NODENV_ZSHRC" >> ~/.zshrc

  # node-build
  # dependencies - https://github.com/nodenv/node-build/wiki#suggested-build-environment
  set -ex \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes python3 g++ make \
    && sudo apt-get clean

  # node-build
  # as an nodenv plugin - https://github.com/nodenv/node-build
  set -ex \
    && mkdir -p ~/.nodenv/plugins \
    && git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build

  # available versions
  mapfile -t NODE_VERSIONS < <(~/.nodenv/bin/nodenv install --list)

  # install multiple node, e.g. NODE="12.22.5, 14.17.5"
  IFS=, read -ra TO_INSTALL <<<${NODE}
  for SINGLE_NODE in ${TO_INSTALL[@]}
  do
    if [[ ${NODE_VERSIONS[*]} =~ ${SINGLE_NODE} ]]; then
      set -ex && ~/.nodenv/bin/nodenv install ${SINGLE_NODE}
    fi
  done

  # configure nodenv - use the first version found
  INSTALLED_VERSIONS=($(nodenv versions))
  if [[ -n ${INSTALLED_VERSIONS[0]} ]]; then
    set -ex \
      && ~/.nodenv/bin/nodenv local ${INSTALLED_VERSIONS[0]} \
      && ~/.nodenv/bin/nodenv versions
  fi
fi
