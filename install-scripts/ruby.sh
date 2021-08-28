#!/usr/bin/env bash
#
# install rbenv and ruby
#  - install rbenv
#  - install ruby (default = 2.7.4)
#
# rbenv
RBENV=$(cat <<'EOF'
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOF
)

set -ex \
  && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
  && echo $'\n'"$RBENV" >> ~/.zshrc

# ruby-build
# dependencies - https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
set -ex \
  && apt-get update \
  && apt-get install --yes autoconf bison libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

# ruby-build
# as an rbenv plugin - https://github.com/rbenv/ruby-build
set -ex \
  && mkdir -p ~/.rbenv/plugins \
  && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && ~/.rbenv/bin/rbenv install $RUBY \
  && ~/.rbenv/bin/rbenv local $RUBY
