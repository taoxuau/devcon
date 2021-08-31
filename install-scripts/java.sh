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
  # jenv
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

  JAVA_VERSIONS=(8 11 13 16)
  if [[ ${JAVA_VERSIONS[*]} =~ ${JAVA} ]]; then
    # install java and maven
    set -ex \
      && sudo apt-get install --no-install-recommends --yes openjdk-${JAVA}-jdk maven \
      && sudo apt-get clean

    # configure jenv
    set -ex \
      && jenv add /usr/lib/jvm/java-${JAVA}-openjdk-amd64/ \
      && jenv versions | grep openjdk64 | xargs jenv local \
      && jenv doctor \
      && mvn --version
  fi
fi
