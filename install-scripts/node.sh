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

  # nodejs
  mapfile -t NODE_VERSIONS < <(~/.nodenv/bin/nodenv install --list)
  if [[ ${NODE_VERSIONS[*]} =~ ${NODE} ]]; then
    set -ex \
      && ~/.nodenv/bin/nodenv install ${NODE} \
      && ~/.nodenv/bin/nodenv local ${NODE}
  fi
fi
