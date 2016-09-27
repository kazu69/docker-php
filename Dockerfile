FROM kazu69/alpine-base:latest
MAINTAINER kazu69

# http://php.net/downloads.php
# http://php.net/gpg-keys.php
ENV PHP_VERSION 5.6.26
ENV PHP_FILENAME "php-${PHP_VERSION}.tar.xz"
ENV PHP_SHA256 203a854f0f243cb2810d1c832bc871ff133eccdf1ff69d32846f93bc1bef58a8
ENV GPG_KEYS 0BD78B5F97500D450838F95DFE857D9A90D90EC1 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3

RUN apk add --no-cache --virtual=.build-dep gnupg && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    curl -fSL "https://secure.php.net/get/$PHP_FILENAME/from/this/mirror" -o php.tar.xz && \
    echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c - && \
    curl -fSL "https://secure.php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o php.tar.xz.asc

RUN export GNUPGHOME="$(mktemp -d)" && \
    cd /tmp/build && \
    for key in $GPG_KEYS; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done && \
    gpg --batch --verify php.tar.xz.asc php.tar.xz && \
    rm -r "$GNUPGHOME" && \
    apk del .build-dep

ENV PHP_INI_DIR /usr/local/etc/php

RUN apk add --no-cache \
            autoconf \
            g++ \
            gcc \
            libc-dev \
            make \
            pkgconf \
            curl-dev \
            libedit-dev \
            libxml2-dev \
            openssl-dev \
            libmcrypt-dev \
            libxslt-dev \
            sqlite-dev && \
      cd /tmp/build && \
      tar -Jxf php.tar.xz && \
      cd php-5.6.26 && \
      ./configure \
          --with-config-file-path="$PHP_INI_DIR" \
          --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
          --with-curl \
          --with-iconv \
          --with-libedit \
          --with-mcrypt \
          --with-mhash \
          --with-mysql=mysqlnd \
          --with-mysqli=mysqlnd \
          --with-pdo-mysql=mysqlnd \
          --with-mysql-sock=/var/run/mysqld/mysqld.sock \
          --with-openssl \
          --with-pcre-regex \
          --enable-phar \
          --with-pear \
          --with-sqlite3 \
          --with-pdo-sqlite \
          --with-xsl \
          --with-zlib \
          --enable-bcmath \
          --enable-ctype \
          --enable-cli \
          --enable-calendar \
          --enable-dom \
          --enable-ftp \
          --enable-fileinfo \
          --enable-filter \
          --enable-json \
          --enable-libxml \
          --enable-mbstring \
          --enable-mbregex \
          --enable-mysqlnd \
          --enable-opcache \
          --enable-simplexm \
          --enable-session \
          --enable-short-tags \
          --enable-sockets \
          --enable-sysvsem \
          --enable-sysvshm \
          --enable-sysvmsg \
          --enable-shmop \
          --enable-tokenizer \
          --enable-pdo \
          --enable-phpdbg \
          --enable-posix \
          --enable-pcntl \
          --enable-xml \
          --enable-xmlwriter \
          --enable-xmlreader \
          --enable-zip \
          --disable-cgi && \
      make -j $(getconf _NPROCESSORS_ONLN) && \
      make install && \
      make clean

RUN curl -fSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
