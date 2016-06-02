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
      libmysqlclient-dev \
      tree \
      cmake \
      pkg-config \
      build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 \
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
  curl https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.5.0 | tar -xz && \
  cd /tmp/ruby-install-0.5.0 && \
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

#chefdk
RUN \
  wget -nv https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.8.0-1_amd64.deb -P /tmp && \
  dpkg -i /tmp/chefdk_0.8.0-1_amd64.deb && \
  rm -rf /tmp/*

# spiff
RUN \
  wget -nv https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip -P /tmp && \
  unzip /tmp/spiff_linux_amd64.zip -d /tmp/ && \
  cp /tmp/spiff /usr/local/bin

#vagrant
RUN \
  wget -nv https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb  -P /tmp && \
  dpkg -i /tmp/vagrant_1.7.4_x86_64.deb && \
  rm -rf /tmp/*
RUN \
  vagrant plugin install vagrant-aws       --plugin-version 0.6.0 && \
  vagrant plugin install vagrant-berkshelf --plugin-version 4.0.4 && \
  vagrant plugin install vagrant-omnibus   --plugin-version 1.4.1

#packer
RUN \
  wget -nv https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip -P /tmp && \
  cd /usr/local/bin && \
  unzip /tmp/packer_0.8.6_linux_amd64.zip && \
  rm /tmp/packer_0.8.6_linux_amd64.zip

#bosh-init
RUN \
  wget -nv https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.80-linux-amd64 -O /usr/local/bin/bosh-init && \
  chmod +x /usr/local/bin/bosh-init
