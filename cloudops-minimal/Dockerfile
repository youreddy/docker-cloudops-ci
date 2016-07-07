FROM alpine:3.3


# Install Ruby libraries
RUN echo "gem : --no-ri --no-rdoc" > ~/.gemrc  && apk update && apk upgrade \
    && apk add libxml2 libxslt libevent libffi glib ncurses readline \
    openssl yaml zlib curl  mariadb-libs libpq ruby ruby-io-console python wget \
    && rm -rf /var/cache/apk/*

RUN curl -sS  https://bootstrap.pypa.io/get-pip.py | python
RUN pip install awscli
RUN gem install bundler bosh_cli nokogiri

RUN \
  wget -nv https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64  -O /usr/local/bin/jq && \
  chmod +x /usr/local/bin/jq


ADD assets/config ~/.ssh/config

# spiff
RUN \
  wget -nv https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip -P /tmp && \
  unzip /tmp/spiff_linux_amd64.zip -d /tmp/ && \
  cp /tmp/spiff /usr/local/bin
