FROM alpine:3.3


# Install Ruby libraries
RUN echo "gem : --no-ri --no-rdoc" > ~/.gemrc && \
    apk update && apk upgrade && \
    apk add \
    bash \
    curl \
    gcc \
    glib \
    git \
    ncurses \
    openssl \
    make \
    mariadb-libs \
    musl-dev \
    readline \
    ruby \
    ruby-dev \
    ruby-io-console \
    libxslt \
    libpq \
    libevent \
    libgcrypt \
    libffi \
    libxml2 \
    python \
    wget \
    yaml \
    zlib \
    && rm -rf /var/cache/apk/*

RUN curl -sS  https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli
RUN gem install bundler json bosh_cli
RUN bundle config build.nokogiri --use-system-libraries

RUN \
  wget -nv https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64  -O /usr/local/bin/jq && \
  chmod +x /usr/local/bin/jq


ADD assets/config ~/.ssh/config

# spiff
RUN \
  wget -nv https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip -P /tmp && \
  unzip /tmp/spiff_linux_amd64.zip -d /tmp/ && \
  cp /tmp/spiff /usr/local/bin
