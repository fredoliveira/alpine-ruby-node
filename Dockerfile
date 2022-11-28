FROM alpine:3.17.0

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1

ADD gemrc /root/.gemrc

# Ruby installation
RUN apk update \
    && apk add ruby \
    ruby-etc \
    ruby-bigdecimal \
    ruby-io-console \
    ruby-irb \
    ruby-json \
    ca-certificates \
    libressl \
    less \
    nodejs \
    yarn \
    && apk add --virtual .build-dependencies \
    build-base \
    ruby-dev \
    libressl-dev \
    && gem install bundler || apk add ruby-bundler \
    && bundle config build.nokogiri --use-system-libraries \
    && bundle config git.allow_insecure true \
    && gem install json \
    && gem cleanup \
    && apk del .build-dependencies \
    && rm -rf /usr/lib/ruby/gems/*/cache/* \
    /var/cache/apk/* \
    /tmp/* \
    /var/tmp/*
