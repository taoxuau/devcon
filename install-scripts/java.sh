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

  # install maven
  set -ex \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends --yes maven

  # available versions
  JAVA_VERSIONS=(8 11 13 16)
  # install multiple java, e.g. JAVA="8,11"
  IFS=, read -ra TO_INSTALL <<<${JAVA}
  for SINGLE_JAVA in ${TO_INSTALL}
  do
    if [[ ${JAVA_VERSIONS[*]} =~ ${SINGLE_JAVA} ]]; then
      # install java
      set -ex && sudo apt-get install --no-install-recommends --yes openjdk-${JAVA}-jdk
      # configure jenv
      set -ex \
        && jenv add /usr/lib/jvm/java-${SINGLE_JAVA}-openjdk-amd64/ \
        && jenv versions | grep openjdk64 | xargs jenv local \
        && jenv doctor \
        && mvn --version
    fi
  done

  # clean up
  set -ex && sudo apt-get clean
fi
