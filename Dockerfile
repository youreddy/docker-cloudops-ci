FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update; apt-get -y upgrade; apt-get clean

RUN apt-get install -y \
      build-essential \
      curl \
      cmake \
      expect \
      git \
      unzip \
      pkg-config \
      tree \
      language-pack-en \
      libxslt-dev \
      libxml2-dev \
      libssl-dev \
      libreadline6 \
      libreadline6-dev \
      libyaml-dev \
      openssl \
      python \
      python-software-properties \
      language-pack-en \
      mysql-client \
      ; \
      apt-get clean

ADD assets/config ~/.ssh/config

RUN \
  wget -nv https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64  -O /usr/local/bin/jq && \
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
  curl https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.6.0 | tar -xz && \
  cd /tmp/ruby-install-0.6.0 && \
  sudo make install && \
  rm -rf /tmp/ruby-install

#install ruby 2.1.7
RUN ruby-install ruby 2.1.7 && \
  cp /etc/profile.d/chruby.sh /etc/profile.d/chruby-with-default-ruby.sh && \
  echo "chruby 2.1.7" >> /etc/profile.d/chruby-with-default-ruby.sh

#install ruby 2.2.2
RUN ruby-install ruby 2.2.2

#install ruby 2.2.4
RUN ruby-install ruby 2.2.4

#install ruby 2.3.1
RUN ruby-install ruby 2.3.1

# Install needed gems for each version of ruby
RUN \
  bash -l -c ' \
  ruby_version_array=($(chruby | sed "s/\*//" | tr \\n \ )); \
  for i in "${ruby_version_array[@]}"; \
  do \
    chruby $i; \
    gem install bundler bosh_cli nokogiri --no-rdoc --no-ri; \
  done'

#aws cli
RUN \
  curl "https://bootstrap.pypa.io/get-pip.py" |python && \
  pip install awscli


# spiff
RUN \
  wget -nv https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip -P /tmp && \
  unzip /tmp/spiff_linux_amd64.zip -d /tmp/ && \
  cp /tmp/spiff /usr/local/bin


#vagrant
RUN \
  wget -nv https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb  -P /tmp && \
  dpkg -i /tmp/vagrant_1.8.4_x86_64.deb && \
  rm -rf /tmp/*
RUN \
  vagrant plugin install vagrant-aws       --plugin-version 0.7.0

#bosh-init
RUN \
  wget -nv https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.92-linux-amd64 -O /usr/local/bin/bosh-init && \
  chmod +x /usr/local/bin/bosh-init
