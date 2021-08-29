#!/usr/bin/env bash
#
# install pyenv and python
#  - install pyenv
#  - install python
#
PYENV_ZSHRC=$(cat <<'EOF'
# pyenv
export PATH="$HOME/.pyenv/bin:${PATH}"
export PATH="$HOME/.pyenv/shims:${PATH}"
eval "$(pyenv init -)"
EOF
)

if [[ -n ${PYTHON} ]]; then
  # pyenv
  set -ex \
    &&  git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && echo $'\n'"$PYENV_ZSHRC" >> ~/.zshrc

  # python-build
  # dependencies - https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  set -ex \
    && sudo apt-get update \
    && sudo apt-get install –-no-install-recommends --yes make build-essential libssl-dev \
      zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
      xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && sudo apt-get clean

  # available versions
  mapfile -t PYTHON_VERSIONS < <(~/.pyenv/bin/pyenv install --list)
  # remove the words "Available versions:" from list
  unset PYTHON_VERSIONS[0]
  # python
  if [[ ${PYTHON_VERSIONS[*]} =~ ${PYTHON} ]]; then
    set -ex \
      && ~/.pyenv/bin/pyenv install ${PYTHON} \
      && ~/.pyenv/bin/pyenv local ${PYTHON}
  fi
fi
