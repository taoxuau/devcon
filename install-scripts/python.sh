#!/usr/bin/env bash
#
# install pyenv and python
#  - install pyenv
#  - install python
#
PYENV_ZSHRC=$(cat <<'EOF'
# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.pyenv/shims:$PATH"
eval "$(pyenv init -)"
EOF
)

if [[ -n ${PYTHON} ]]; then
  # install pyenv
  set -ex \
    && git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && echo $'\n'"$PYENV_ZSHRC" >> ~/.zshrc

  # initialize pyenv
  export PATH="$HOME/.pyenv/bin:$PATH"
  export PATH="$HOME/.pyenv/shims:$PATH"
  eval "$(pyenv init -)"

  # python-build
  # dependencies - https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  set -ex \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes make build-essential libssl-dev \
      zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
      xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && sudo apt-get clean

  # available versions
  mapfile -t PYTHON_VERSIONS < <(pyenv install --list)
  unset PYTHON_VERSIONS[0] # remove the words "Available versions:" from list

  # install multiple python, e.g. PYTHON="3.9.7, 3.8.12"
  IFS=, read -ra TO_INSTALL <<<${PYTHON}
  for SINGLE_PYTHON in ${TO_INSTALL[@]}
  do
    if [[ ${PYTHON_VERSIONS[*]} =~ ${SINGLE_PYTHON} ]]; then
      set -ex && pyenv install ${SINGLE_PYTHON}
    fi
  done

  # configure pyenv - use the first version found
  INSTALLED_VERSIONS=($(pyenv versions))
  if [[ -n ${INSTALLED_VERSIONS[0]} ]]; then
    set -ex \
      && pyenv local ${INSTALLED_VERSIONS[0]} \
      && pyenv versions
  fi
fi
