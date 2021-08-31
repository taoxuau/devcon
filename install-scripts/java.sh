#!/usr/bin/env bash
#
# install jenv and java
#  - install jenv
#  - install java and maven
#
JENV_ZSHRC=$(cat <<'EOF'
# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
EOF
)
# available versions
JAVA_VERSIONS=(8 11 13 16)

if [[ -n ${JAVA} ]]; then
  # install jenv
  set -ex \
    && git clone https://github.com/jenv/jenv.git ~/.jenv \
    && echo $'\n'"$JENV_ZSHRC" >> ~/.zshrc

  # initialize jenv
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"

  # make sure JAVA_HOME is set, maven is enabled
  set -ex \
    && jenv enable-plugin export \
    && jenv enable-plugin maven

  # apt-get update once
  set -ex && sudo apt-get update

  # install multiple java, e.g. JAVA="8,11"
  IFS=, read -ra TO_INSTALL <<<${JAVA}
  for SINGLE_JAVA in ${TO_INSTALL[@]}
  do
    if [[ ${JAVA_VERSIONS[*]} =~ ${SINGLE_JAVA} ]]; then
      # install java
      set -ex \
        && sudo apt-get install --no-install-recommends --yes openjdk-${SINGLE_JAVA}-jdk \
        && jenv add /usr/lib/jvm/java-${SINGLE_JAVA}-openjdk-amd64/
    fi
  done

  # configure jenv - use the first version found
  INSTALLED_VERSIONS=($(jenv versions | grep openjdk64))
  if [[ -n ${INSTALLED_VERSIONS[0]} ]]; then
    set -ex \
      && jenv local ${INSTALLED_VERSIONS[0]} \
      && jenv doctor
  fi

  # install maven
  set -ex \
    && sudo apt-get install --no-install-recommends --yes maven \
    && sudo apt-get clean
fi
