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
      build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 \
      python-software-properties \
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
RUN bash -l -c "chruby 2.1.7; gem install bosh_cli --no-rdoc --no-ri"

#install ruby 2.2.2
RUN ruby-install ruby 2.2.2

#Bundler
RUN bash -l -c "chruby 2.2.2; gem install bundler --no-rdoc --no-ri"
RUN bash -l -c "chruby 2.1.7; gem install bosh_cli --no-rdoc --no-ri"

#aws cli
RUN \
  curl "https://bootstrap.pypa.io/get-pip.py" |python && \
  pip install awscli

#chefdk
RUN \
  wget -nv https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.8.0-1_amd64.deb -P /tmp && \
  dpkg -i /tmp/chefdk_0.8.0-1_amd64.deb && \
  rm -rf /tmp/*

#vagrant
RUN \
  wget -nv https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb  -P /tmp && \
  dpkg -i /tmp/vagrant_1.7.4_x86_64.deb && \
  rm -rf /tmp/*
RUN \
  vagrant plugin install vagrant-aws       --plugin-version 0.6.0 && \
  vagrant plugin install vagrant-berkshelf --plugin-version 4.0.4 && \
  vagrant plugin install vagrant-omnibus   --plugin-version 1.4.1

#packer
RUN \
  wget -nv https://dl.bintray.com/mitchellh/packer/packer_0.8.6_linux_amd64.zip -P /tmp && \
  cd /usr/local/bin && \
  unzip /tmp/packer_0.8.6_linux_amd64.zip && \
  rm /tmp/packer_0.8.6_linux_amd64.zip

#bosh-init
RUN \
  wget -nv https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.80-linux-amd64 -O /usr/local/bin/bosh-init && \
  chmod +x /usr/local/bin/bosh-init
