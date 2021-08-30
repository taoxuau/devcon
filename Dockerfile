FROM taoxuau/ubuntu:20.04

# rbenv and ruby
ARG RUBY
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/ruby.sh)"

# pyenv and python
ARG PYTHON
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/python.sh)"

# nodenv and nodejs
ARG NODE
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/node.sh)"

# jenv and java
ARG JAVA
RUN set -ex && bash -c "$(curl -fsSL https://raw.githubusercontent.com/taoxuau/devcon/master/install-scripts/java.sh)"

# other preparation
RUN set -ex && mkdir -p ~/.ssh

# keep container running - https://stackoverflow.com/a/42873832/629950
CMD ["tail", "-f", "/dev/null"]

# https://github.com/Yelp/dumb-init
ENTRYPOINT ["dumb-init", "--"]
