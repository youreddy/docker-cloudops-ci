FROM ubuntu:16.04

# RUN locale-gen en_US.UTF-8
# RUN dpkg-reconfigure locales
# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

RUN apt-get update;\
    apt-get -y upgrade

RUN apt-get -y install \
      build-essential \
      git \
      ruby \
      ruby-dev \
      libxml2-dev \
      libsqlite3-dev \
      libxslt1-dev \
      libpq-dev \
      libmysqlclient-dev \
      zlib1g-dev \
      curl


# RUN apt-get install -y \
#     unzip \
#     gcc \
#     ruby \
#     git \
#     curl && \
#     apt-get clean

# spiff
RUN \
  curl -L https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip > /tmp/spiff_linux_amd64.zip && \
  unzip /tmp/spiff_linux_amd64.zip -d /tmp/ && \
  cp /tmp/spiff /usr/local/bin

#bosh-init
RUN \
  curl -L https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.92-linux-amd64 > /usr/local/bin/bosh-init && \
  chmod +x /usr/local/bin/bosh-init

# RUN gem install bosh_cli --no-ri --no-rdoc
