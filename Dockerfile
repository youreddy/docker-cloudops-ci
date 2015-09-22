FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update; apt-get -y upgrade; apt-get clean

RUN apt-get install -y \
      git \
      unzip \
      wget \
      curl \
      expect \
      make \
      tree \
      language-pack-en; \
      apt-get clean

ADD assets/config ~/.ssh/config

RUN \
  wget -nv http://stedolan.github.io/jq/download/linux64/jq -P /usr/local/bin && \
  chmod +x /usr/local/bin/jq

# chruby
RUN mkdir /tmp/chruby && \
  cd /tmp && \
  curl https://codeload.github.com/postmodern/chruby/tar.gz/v0.3.9 | tar -xz && \
  cd /tmp/chruby-0.3.9 && \
  sudo ./scripts/setup.sh && \
  rm -rf /tmp/chruby

# ruby-install
RUN mkdir /tmp/ruby-install && \
  cd /tmp && \
  curl https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.5.0 | tar -xz && \
  cd /tmp/ruby-install-0.5.0 && \
  sudo make install && \
  rm -rf /tmp/ruby-install

#install ruby 2.1.7
RUN ruby-install ruby 2.1.7 && \
  cp /etc/profile.d/chruby.sh /etc/profile.d/chruby-with-default-ruby.sh && \
  echo "chruby 2.1.7" >> /etc/profile.d/chruby-with-default-ruby.sh

#Bundler
RUN bash -l -c "chruby 2.1.7; gem install bundler --no-rdoc --no-ri"

#bosh_cli
RUN bash -l -c "chruby 2.1.7; gem install bosh_cli --no-rdoc --no-ri"

#install ruby 2.2.2
RUN ruby-install ruby 2.2.2

#Bundler
RUN bash -l -c "chruby 2.2.2; gem install bundler --no-rdoc --no-ri"

#bosh_cli
RUN bash -l -c "chruby 2.2.2; gem install bosh_cli --no-rdoc --no-ri"
